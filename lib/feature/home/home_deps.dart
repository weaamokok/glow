import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glow/domain/weather.dart';
import 'package:glow/feature/calendar/calendar_deps.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:glow/helper/helper_functions.dart';

import '../../domain/glow.dart';
import '../../helper/location_manager.dart';

class HomeDeps {
  static final checkPermission = Provider((ref) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      Geolocator.requestPermission();
    }
  });
  static final currentLocation = FutureProvider<Coord>((ref) async {
    await ref.read(checkPermission);
    final currentPosition = await Geolocator.getCurrentPosition();

    return Coord(lat: currentPosition.latitude, lon: currentPosition.longitude);
  });
  static final weatherProvider = FutureProvider<WeatherResponse?>((ref) async {
    final dio = Dio();
    final userLocation = await ref.watch(LocationHandler.getCurtrentLocation);

    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather?lat=${userLocation.latitude}&lon=${userLocation.longitude}&units=metric&appid=2b9775e044c23e8dfa57eec0d27c6626',
    );

    final weatherData = response.data;
    return WeatherResponse.fromJson(weatherData as Map<String, dynamic>);
  });

  static final actionControllerProvider =
      StateNotifierProvider<ActionController, AsyncValue<void>>((ref) {
        return ActionController(ref);
      });
}

class ActionController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  ActionController(this.ref) : super(const AsyncValue<void>.data(null));

  Future<AsyncValue<ActionStatus>> updateActionStatus({
    required ScheduleAction action,
    required String instanceId,
  }) async {
    try {
      final schedule = ref.read(CalendarDeps.scheduleProvider);
      if (schedule.value == null) {
        return AsyncValue.error('No schedule found', StackTrace.current);
      }
      // Create a deep copy of the schedule with updated action
      final updatedDailySchedules = schedule.value?.dailySchedule.map((daily) {
        final updatedActions = daily.actions?.map((e) {
          return e.id == action.id
              ? e.copyWith(instances: action.instances)
              : e;
        }).toList();
        return updatedActions != null
            ? daily.copyWith(actions: updatedActions)
            : daily;
      }).toList();

      final updatedSchedule = schedule.value?.copyWith(
        dailySchedule: updatedDailySchedules,
      );
      if (updatedSchedule == null) {
        return AsyncValue.error('No schedule found', StackTrace.current);
      }
      // Save the updated schedule
      final saveResult = await ref.read(
        PromptCreatorDeps.saveGlowScheduleProvider(updatedSchedule),
      );

      // Handle the save result
      return saveResult.when(
        loading: () => AsyncValue.loading(),
        data: (_) {
          final updatedStatus = updatedDailySchedules
              ?.expand((daily) => daily.actions ?? [])
              .firstWhere((e) => e.id == action.id)
              .instances
              ?.firstWhere((instance) => instance.id == instanceId)
              .status;

          ref.invalidate(CalendarDeps.scheduleProvider);
          return AsyncValue.data(updatedStatus);
        },
        error: (error, stack) => AsyncValue.error(error, stack),
      );
    } catch (e, stack) {
      return AsyncValue.error(e, stack);
    }
  }

  Future<AsyncValue<void>> deleteAction({
    required String actionId,
    required String instanceId,
  }) async {
    try {
      // 1. Get current schedule safely
      final schedule = ref.read(CalendarDeps.scheduleProvider);
      if (schedule.value == null) {
        return AsyncValue.error('No schedule found', StackTrace.current);
      }

      // 2. Create a deep copy of the schedule
      final updatedSchedule = schedule.value!.copyWith(
        dailySchedule: schedule.value!.dailySchedule.map((daily) {
          // 3. Update actions only if they contain the target instance
          final hasTargetAction = daily.actions?.any(
            (action) =>
                action.id == actionId &&
                action.instances?.any((inst) => inst.id == instanceId) == true,
          );

          if (hasTargetAction != true) return daily;

          return daily.copyWith(
            actions: daily.actions?.map((action) {
              // 4. Only modify the specific action
              if (action.id != actionId) return action;

              return action.copyWith(
                instances: action.instances
                    ?.where((instance) => instance.id != instanceId)
                    .toList(),
              );
            }).toList(),
          );
        }).toList(),
      );

      // 5. Save the updated schedule
      final saveResult = await ref.read(
        PromptCreatorDeps.saveGlowScheduleProvider(updatedSchedule),
      );

      // 6. Handle save result
      return saveResult.when(
        data: (_) {
          ref.invalidate(CalendarDeps.scheduleProvider);
          return const AsyncValue.data(null);
        },
        error: (error, stack) => AsyncValue.error(error, stack),
        loading: () => const AsyncValue.loading(),
      );
    } catch (e, st) {
      return AsyncValue.error(e, st);
    }
  }

  Future<AsyncValue<ScheduleAction>> addAction({
    required ScheduleAction newAction,
    required Slot slot,
  }) async {
    try {
      final schedule = ref.read(CalendarDeps.scheduleProvider);
      if (!schedule.hasValue) {
        return AsyncValue.error('No schedule found', StackTrace.current);
      }

      final updatedDailySchedules = schedule.value?.dailySchedule.map((daily) {
        final existingAction = daily.actions?.firstWhereOrNull(
          (action) => action.id == newAction.id,
        );
        if (existingAction != null) {
          final updatedActions = daily.actions?.map((e) {
            if (e.id == existingAction.id) {
              return newAction;
            } else {
              return e;
            }
          }).toList();
          return updatedActions != null
              ? daily.copyWith(actions: updatedActions)
              : daily;
        } else {
          //  schedule.value?.getSlot(time: )
          //find the slot of the action
          if (slot == daily.timeSlot) {
            return daily.copyWith(actions: [...?daily.actions, newAction]);
          } else {
            return daily;
          }
        }
      }).toList();

      final updatedSchedule = schedule.value?.copyWith(
        dailySchedule: updatedDailySchedules,
      );
      if (updatedSchedule == null) {
        return AsyncValue.error('No schedule found', StackTrace.current);
      }
      final saveResult = await ref.read(
        PromptCreatorDeps.saveGlowScheduleProvider(updatedSchedule),
      );
      // Handle the save result
      return saveResult.when(
        loading: () => AsyncValue.loading(),
        data: (data) {
          ref.invalidate(CalendarDeps.scheduleProvider);
          return AsyncValue.data(newAction);
        },
        error: (error, stack) => AsyncValue.error(error, stack),
      );
    } catch (e, st) {
      state = AsyncValue<void>.error(e, st);
      rethrow;
    }
  }
}
