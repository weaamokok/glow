import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/app/db_keys.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/feature/calendar/calendar_deps.dart';
import 'package:glow/helper/prompt_functions.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sembast/sembast.dart';

import '../../app/local_db.dart';
import '../../domain/user_info.dart';
import '../../helper/helper_functions.dart';
import '../../helper/locale_manager.dart';
import '../../helper/prompt_loader.dart';
import '../home/home_deps.dart';
import 'image_picker_step.dart';

class PromptCreatorDeps {
  static final addPromptImagesProvider =
      StateProviderFamily<Future<bool>, List<File?>>(
    (ref, arg) async {
      //add image to local
      var store = StoreRef.main();
      final imagesAsUnit8List = arg.map(
        (e) {
          return e?.readAsBytesSync();
        },
      ).toList();
      try {
        await store
            .record(
              DbKeys.userImages,
            )
            .put(await LocalDB.db, imagesAsUnit8List)
            .then(
          (value) {
            debugPrint('image added successfully!');
          },
        );
      } catch (e) {
        debugPrint('failed to add image: $e');

        return false;
      }
      return true;
    },
  ); //to local storage class/provider
  static final saveGlowScheduleProvider =
      StateProviderFamily<Future<AsyncValue<GlowSchedule>>, GlowSchedule>(
    (ref, arg) async {
      //add image to local
      var store = StoreRef.main();

      try {
        final savedSchedule = await store
            .record(
              DbKeys.glowSchedule,
            )
            .put(await LocalDB.db, arg.toMap(), merge: true)
            .then(
          (value) {
            debugPrint('glow schedule added successfully');
            return value as Map<String, dynamic>;
          },
        );
        return AsyncValue.data(GlowSchedule.fromMap(savedSchedule));
      } catch (e) {
        debugPrint('failed to add glow schedule: $e');
        return AsyncValue.error('failed to add glow schedule: $e',
            StackTrace.fromString(e.toString()));
      }
    },
  ); //to local storage class/provider
  static final addPromptPersonalInfoProvider =
      StateProviderFamily<Future<bool>, UserPersonalInfo>(
    (ref, arg) async {
      //add image to local
      var store = StoreRef.main();

      try {
        await store
            .record(
              DbKeys.userPersonalInfo,
            )
            .put(await LocalDB.db, arg.toMap())
            .then(
          (value) {
            debugPrint('user info added successfully');
          },
        );
        // print('post   ${arg}');
      } catch (e) {
        debugPrint('failed to add user info: $e');
        return false;
      }
      return true;
    },
  ); //to local storage class/provider
  static final modelProvider = Provider<GenerativeModel>(
    (ref) {
      final apiKey = dotenv.get(
        'GOOGLE_AI_API_KEY',
      );

      return GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            candidateCount: 8,
            responseMimeType: 'application/json',
          ));
    },
  );
  static final promptProvider =
      StateNotifierProvider<PromptNotifier, dynamic>((ref) {
    //  PromptNotifier.submitPrompt(ref: ref);
    return PromptNotifier(ref: ref);
  });
  static final promptCreatorProvider =
      FutureProvider<Either<Error, GlowSchedule>>(
    (
      ref,
    ) async {
      var store = StoreRef.main();

      // Get stored images
      final storedImages = (await store
              .record(DbKeys.userImages)
              .get(await LocalDB.db) as List<dynamic>?)
          ?.toList();

      if (storedImages == null || storedImages.isEmpty) {
        throw Exception("No images found in local storage");
      }

      // Safely convert each element to Uint8List
      final imageParts = <DataPart>[];
      for (final item in storedImages) {
        // Handle ImmutableList<Object?> case
        if (item is List<Object?>) {
          try {
            // Convert List<Object?> to List<int>
            final List<int> bytes = item.cast<int>();
            imageParts.add(DataPart('image/jpg', Uint8List.fromList(bytes)));
          } catch (e) {
            debugPrint('failed to convert images: $e');
            continue; // Skip invalid entries
          }
        } else if (item is Uint8List) {
          imageParts.add(DataPart('image/jpg', item));
        } else {
          debugPrint('Unsupported type: ${item.runtimeType}');
        }
      }
      // Get personal info
      final userInfo = UserPersonalInfo(
        job: 'doctor',
        gender: 'female',
        activity: ' mostly standing',
        workoutSchedule: '3 days a week or less',
        birthDate: '1998-01-01',
        hobbies: 'nothing',
        goals: 'to be prettier',
        notes: '..',
      );
      final locale = await ref.read(LocaleManager.appLocaleProvider.future);

      final prompt = scheduleCreationPrompt(
        local: locale,
        userInfo: userInfo,
      );

      final content = [
        Content.multi([
          TextPart(prompt),
          ...imageParts,
        ])
      ];
      final response =
          await ref.read(PromptCreatorDeps.modelProvider).generateContent(
                content,
              );

      debugPrint('response type${response.text.toString()}', wrapWidth: 100);
      final glowResponse = GlowSchedule.fromJson(response.text ?? '');
      await ref.read(PromptCreatorDeps.saveGlowScheduleProvider(glowResponse));
      for (var slot in glowResponse.dailySchedule) {
        slot.actions?.forEach((action) {
          final instances = action.generateInstances();
          slot.actions
              ?.firstWhereOrNull(
                (p0) => p0.id == action.id,
              )
              ?.instances
              ?.addAll(instances);
        });
      }

      return right(glowResponse);
    },
  );
  static final promptCreatorStepProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      ref.keepAlive();

      return useState(0);
    },
  );

  static final promptImagesProvider =
      StateNotifierProvider<PromptImagesNotifier, List<File?>>(
    (ref) => PromptImagesNotifier(),
  );
  static final promptPersonalInfoProvider =
      StateNotifierProvider<PromptPersonalInfoNotifier, UserPersonalInfo>(
    (ref) => PromptPersonalInfoNotifier(),
  );

  static final promptProgressProvider = ChangeNotifierProvider(
    (ref) {
      return useState(0.0);
    },
  );
}

class PromptImagesNotifier extends StateNotifier<List<File?>> {
  PromptImagesNotifier()
      : super(List.filled(UserImagesTypes.values.length, null));

  void updateImage(int index, File? file) {
    state = List<File?>.from(state)..[index] = file;
  }
}

class PromptPersonalInfoNotifier extends StateNotifier<UserPersonalInfo> {
  PromptPersonalInfoNotifier() : super(UserPersonalInfo());

  void updateActivity(String activity) {
    state = state.copyWith(activity: activity);
  }

  void updateHobbies(String hobbies) {
    state = state.copyWith(hobbies: hobbies);
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void updateWorkoutSchedule(String workoutSchedule) {
    state = state.copyWith(workoutSchedule: workoutSchedule);
  }

  void updateGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void updateGoals(String goals) {
    state = state.copyWith(goals: goals);
  }

  void updateJob(String job) {
    state = state.copyWith(job: job);
  }

  void updateBirthDate(String birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }
}

class PromptNotifier extends StateNotifier {
  PromptNotifier({required this.ref}) : super(const AsyncLoading());
  final Ref ref;

  FutureOr<AsyncValue<GlowSchedule?>> submitPrompt() async {
    AsyncValue<GlowSchedule?> state = AsyncValue.loading();
    var store = StoreRef.main();
    try {
      // Get stored images
      final storedImages = (await store
              .record(DbKeys.userImages)
              .get(await LocalDB.db) as List<dynamic>?)
          ?.toList();

      if (storedImages == null || storedImages.isEmpty) {
        throw Exception("No images found in local storage");
      }

      // Safely convert each element to Uint8List
      final imageParts = <DataPart>[];
      for (final item in storedImages) {
        // Handle ImmutableList<Object?> case
        if (item is List<Object?>) {
          try {
            // Convert List<Object?> to List<int>
            final List<int> bytes = item.cast<int>();
            imageParts.add(DataPart('image/jpg', Uint8List.fromList(bytes)));
          } catch (e) {
            debugPrint('failed to convert images: $e');
            continue; // Skip invalid entries
          }
        } else if (item is Uint8List) {
          imageParts.add(DataPart('image/jpg', item));
        } else {
          debugPrint('Unsupported type: ${item.runtimeType}');
        }
      }
      // Get personal info
      final userInfo = UserPersonalInfo(
        job: 'doctor',
        gender: 'female',
        activity: ' mostly standing',
        workoutSchedule: '3 days a week or less',
        birthDate: '1998-01-01',
        hobbies: 'nothing',
        goals: 'to be prettier',
        notes: '..',
      );
      final locale = await ref.read(LocaleManager.appLocaleProvider.future);

      final prompt = scheduleCreationPrompt(
        local: locale,
        userInfo: userInfo,
      );

      final content = [
        Content.multi([
          TextPart(prompt),
          ...imageParts,
        ])
      ];
      final response =
          await ref.read(PromptCreatorDeps.modelProvider).generateContent(
                content,
              );

      debugPrint('response type${response.text.toString()}', wrapWidth: 100);
      final glowResponse = GlowSchedule.fromJson(response.text ?? '');
      await ref.read(PromptCreatorDeps.saveGlowScheduleProvider(glowResponse));
      for (var slot in glowResponse.dailySchedule) {
        slot.actions?.forEach((action) {
          final instances = action.generateInstances();
          slot.actions
              ?.firstWhereOrNull(
                (p0) => p0.id == action.id,
              )
              ?.instances
              ?.addAll(instances);
        });
      }
      ref.invalidate(CalendarDeps.scheduleProvider);

      state = AsyncValue<GlowSchedule?>.data(glowResponse);
      return state;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.empty);
      debugPrint('Error in prompt response: $e');
      return state;
    }
  }

  Future<AsyncValue<ScheduleAction>> updateActionPrompt(
      {required ScheduleAction action, required bool isEdit}) async {
    final actionController =
        ref.read(HomeDeps.actionControllerProvider.notifier);
    try {
      if (isEdit) {
        final updatingResult = await actionController.addAction(
            newAction: action, slot: Slot.undefined);
        return updatingResult.map(
            data: (data) => AsyncData(data.value),
            error: (error) => AsyncError(error, error.stackTrace),
            loading: (loading) => AsyncLoading());
      }
      final prompt = actionUpdatePrompt(action: action);

      final response =
          await ref.read(PromptCreatorDeps.modelProvider).generateContent(
        [Content.text(prompt)],
      );

      final responseText = response.text;
      if (responseText == null || responseText.isEmpty) {
        throw Exception('Empty response from AI model');
      }

      // Extract JSON from markdown code block if present
      String jsonString = responseText;
      final jsonMatch =
          RegExp(r'```json\n([\s\S]*?)\n```').firstMatch(responseText);
      if (jsonMatch != null) {
        jsonString = jsonMatch.group(1)!;
      }

      debugPrint('Received action update: $jsonString');

      final updatedAction = UpdateActionResponse.fromJson(jsonString);

      final updatedActionInstances = updatedAction.action.generateInstances();

      final updatingResult = await actionController.addAction(
          newAction:
              updatedAction.action.copyWith(instances: updatedActionInstances),
          slot: updatedAction.slot);
      return updatingResult.map(
          data: (data) => AsyncData(data.value),
          error: (error) => AsyncError(error, error.stackTrace),
          loading: (loading) => AsyncLoading());
    } catch (e, stackTrace) {
      debugPrint('Error updating action: $e\n$stackTrace');
      // Fallback: Return original action with error flag
      return AsyncError(e, stackTrace);
    }
  }
}

class UpdateActionResponse {
  const UpdateActionResponse({
    required this.action,
    required this.slot,
  });

  final ScheduleAction action;
  final Slot slot;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UpdateActionResponse &&
          runtimeType == other.runtimeType &&
          action == other.action &&
          slot == other.slot);

  @override
  int get hashCode => action.hashCode ^ slot.hashCode;

  @override
  String toString() {
    return 'UpdateActionResponse{action: $action, slot: $slot, }';
  }

  UpdateActionResponse copyWith({
    ScheduleAction? action,
    Slot? slot,
  }) {
    return UpdateActionResponse(
      action: action ?? this.action,
      slot: slot ?? this.slot,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'slot': slot,
    };
  }

  factory UpdateActionResponse.fromMap(Map<String, dynamic> map) {
    return UpdateActionResponse(
      action: ScheduleAction.fromMap(map['action'] as Map<String, dynamic>),
      slot: TimeSlotExtension.fromJson(
          removeEmojis(map['slot']).toString().toLowerCase()),
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateActionResponse.fromJson(String source) =>
      UpdateActionResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
