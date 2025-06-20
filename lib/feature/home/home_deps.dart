import 'dart:async';
import 'dart:math';

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
  static final checkPermission = Provider(
    (ref) async {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever ||
          permission == LocationPermission.unableToDetermine) {
        Geolocator.requestPermission();
      }
    },
  );
  static final currentLocation = FutureProvider<Coord>(
    (ref) async {
      await ref.read(checkPermission);
      final currentPosition = await Geolocator.getCurrentPosition();

      return Coord(
          lat: currentPosition.latitude, lon: currentPosition.longitude);
    },
  );
  static final weatherProvider = FutureProvider<WeatherResponse?>(
    (
      ref,
    ) async {
      final dio = Dio();
      final userLocation = await ref.watch(LocationHandler.getCurtrentLocation);

      final response = await dio
          .get(
            'https://api.openweathermap.org/data/2.5/weather?lat=${userLocation.latitude}&lon=${userLocation.longitude}&units=metric&appid=2b9775e044c23e8dfa57eec0d27c6626',
          )
          .whenComplete(
            () => print('request was sent'),
          );

      final weatherData = response.data;
      return WeatherResponse.fromJson(weatherData as Map<String, dynamic>);
    },
  );
  static final greetingProvider = Provider(
    (ref) {
      var hour = DateTime.now().hour;
      var random = Random();
      int i = random.nextInt(50);

      if (hour < 12) {
        return [
          "Good morning, glow-getter! 🌞",
          "Rise and shine! Time to sparkle ✨",
          "Hello, sunshine! ☀️ Ready to glow?",
          "New day, new glow 💫",
          "Wakey wakey, beautiful! 🌼",
          "Mornings are better with you 😊",
          "Let’s slay this day! 💪",
          "Top of the morning to you! ☕",
          "Rise and bloom 🌸",
          "Today’s your canvas – paint it bright 🎨",
          "Hello, gorgeous! Time to thrive 💄",
          "Wake up and smell the possibilities! 🌈",
          "You + Morning = Magic ✨",
          "Let’s make today legendary 🌟",
          "Good morning, future self-improvement! 💯",
          "Rise like the champion you are 🏆",
          "Fresh start loading... 100% complete 🚀",
          "Today called – it said you’re gonna rock it 🤘",
          "Mornings are for winners – and that’s you! 🥇",
          "Hello daylight, hello greatness 🌄",
          "Wake up and glow up! 💡",
          "New dawn, new you 🌅",
          "Ready to conquer? ⚔️",
          "Let’s turn today into a masterpiece 🖼️",
          "Good morning, secret weapon! 🔑",
          "Today’s menu: Success + Confidence 📜",
          "Rise and radiate 💥",
          "Warning: This day contains 24 hours of potential 🕛",
          "Mornings don’t lie – you’ve got this! 💪",
          "Let’s brew confidence ☕✨",
          "Wake up and level up 🎮",
          "Bonjour! Let’s sparkle 🇫🇷✨",
          "Buenos días, go-getter! 🇪🇸💃",
          "Guten Morgen, superstar! 🇩🇪🌟",
          "Buongiorno, beautiful! 🇮🇹🌞",
          "Morning mantra: I am unstoppable 🧘♀️",
          "Alert: Today needs your magic 🧚♀️",
          "It’s glow o’clock! 💅",
          "New day, new slay 💇♀️",
          "Rise like royalty 👑",
          "You vs. the day – we know who’ll win 🥊",
          "Today’s forecast: 100% chance of awesome 🌦️",
          "Wake up and warrior up! 🛡️",
          "Let’s make today Instagram-worthy 📸",
          "Morning fuel: Ambition + Coffee ⛽☕",
          "Today’s agenda: Be fabulous 📃",
          "Warning: Confidence overload incoming 💥",
          "Ready to collect daily wins? 🏅",
          "It’s a bright new day! 😎",
          "Another 24, let’s make it count ⏳",
          "What’s your superpower today? 🦸♀️"
        ][i];
      }
      if (hour < 17) {
        return [
          "Afternoon vibes, glow champion! 🌤️",
          "Lunch break? More like glow break! 🥗✨",
          "Hello sunshine, part two! 🌞",
          "Midday magic incoming... ✨",
          "Fuel up & glow on! ⛽💄",
          "Afternoon agenda: Slay remaining hours ⏳",
          "You’re over the hump – coast downhill now 🏔️",
          "Post-lunch power surge activated 💥",
          "Rise from the food coma – we’ve got glowing to do! 🍝💫",
          "Golden hour? More like golden you! 🌇",
          "Afternoon reminder: You’re doing amazing! 👏",
          "Coffee break = Glow prep time ☕💅",
          "Don’t afternoon slump – afternoon JUMP! 🦘",
          "Make the PM as fierce as the AM 🐅",
          "Sun’s still up – so is your potential! ☀️",
          "Afternoon energy refresh: 100% charged 🔋",
          "Kon'nichiwa, gorgeous! 🇯🇷🌸 (Good afternoon!)",
          "Boa tarde, glow warrior! 🇵🇹⚔️",
          "Afternoon glow checklist: ✔️ Hydration ✔️ Confidence",
          "Warning: Second wind incoming 🌬️",
          "Day half full? Let’s make it overflow! 🥂",
          "Tea time = Self-care time 🍵💆♀️",
          "Don’t count hours – make hours count! ⏰",
          "Afternoon ambition level: Unstoppable 🚂",
          "Slump? What slump? Let’s sparkle! 💎",
          "Pro tip: Glow brighter after lunch 💡",
          "Midday mantra: I own this day 🧘♂️",
          "Afternoon forecast: 100% chance of fabulous 🌦️",
          "Power through like the queen you are 👑",
          "Need energy? Here’s some virtual matcha! 🍵💚",
          "Afternoon game plan: Smash goals → Glow 💥",
          "Remember: Even sunsets glow 🌅",
          "Day 50% complete – 50% more to conquer! 🎯",
          "Afternoon energy hack: Power pose time! 🦸♀️",
          "Buenas tardes, radiant one! 🇪🇸🌻",
          "Afternoon reset: Shoulders back, glow on! 💃",
          "Make the PM your personal victory lap 🏁",
          "Alert: Second act glow-up incoming 🎭",
          "Afternoon fuel: Ambition + Green tea 🍃",
          "Slay the afternoon like it’s morning 2.0 ⏱️",
          "Don’t dusk till you glow! 🌆",
          "Midday check: Still fabulous? ✔️",
          "Afternoon challenge: Out-shine the sun 🔆",
          "Productivity tip: Glow while you work 💻✨",
          "Afternoon mood: Quietly unstoppable 🤫💪",
          "Day halfway done? Let’s make the rest fun! 🎉",
          "Afternoon zen mode: Activated 🧘♀️",
          "Pro reminder: Hydration = Glow foundation 💦",
          "Afternoon stretch → Glow upgrade 🧘♂️💫",
          "Make the world your golden hour 🌟",
          "Afternoon secret: You improve as day progresses 📈"
        ][i];
      }
      return [
        "Evening glow protocol activated 🌆✨",
        "Sunset check: Did you glow today? 🌇",
        "Bonsoir, beautiful! Time to recharge 🇫🇷🌙",
        "Evening agenda: Unwind & shine down 🌠",
        "Golden hour → Golden you 🌟",
        "Dusk reminder: You were fabulous today 🌄",
        "Prep your beauty sleep throne 🛌💤",
        "Nightly ritual: Wash away the day 🧼✨",
        "Evening mantra: I am at peace 🧘♀️",
        "Buonasera, radiant soul! 🇮🇷🌌",
        "Moonrise = Your time to glow 🌕💫",
        "Evening check: 3 hydration stars today? 💦⭐️⭐️⭐️",
        "Twilight challenge: Reflect & glow 🌆",
        "Nighttime glow secret: Pillow magic 🛌✨",
        "Evening forecast: 100% chance of self-care 🌧️💆♀️",
        "Candlelit glow time 🕯️🌸",
        "Today's final act: Radiant relaxation 🎭✨",
        "Evening equation: Skincare + Gratitude = 💖",
        "Otsukaresama deshita! (Great work today!) 🇯🇵🎐",
        "Unplug to recharge 📵🔋",
        "Nightly reset: Tomorrow's canvas awaits 🎨",
        "Evening glow booster: Smile at today's wins 😊🏆",
        "Moonlit reminder: Rest is productive 🌝💤",
        "Bathing in starlight tonight? 🌠🛁",
        "Evening ritual: Wash off day, layer on glow 🧴💫",
        "Goodnight oil: Apply self-compassion 💧💖",
        "Today's final glow checkpoint ✨✅",
        "Evening fuel: Herbal tea + Kind thoughts 🍵💭",
        "Night mode: Silent glow activation 🤫✨",
        "Final light check: Still shining? 💡✔️",
        "Evening alchemy: Turn rest into beauty 💤➡️💅",
        "Tuck in your ambitions – they'll bloom tomorrow 🌷",
        "Tonight's assignment: Dream in HD 📺💭",
        "Night owl? Let’s glow responsibly 🦉✨",
        "Evening whisper: Tomorrow needs your light 💡",
        "Bedtime countdown: 3 skincare steps...2...1 🧖♀️⏳",
        "Starry night = Starry you 🌟👩🦰",
        "Evening science: Sleep = Beauty catalyst 🧪💤",
        "Moon phase: Full glow tonight 🌕💫",
        "Nightly prep: Tomorrow’s confidence starts now 📅💪",
        "Evening meditation: Breathe out today, in tomorrow 🌬️",
        "Final glow note: You’re worth the care 💌",
        "Tonight’s secret: Pillowcase magic (satin approved) 🌛",
        "Evening affirmation: You’re the brightest constellation 🌌",
        "Night owl? Let’s glow mindfully 🦉🧴",
        "Evening equation: Cleanse + Moisturize = 😴➡️😍",
        "Tuck today’s wins under your pillow 💤🏅",
        "Nightly reminder: Skin repairs while you sleep 🛌🔧",
        "Evening haiku: Wash, tone, treat/ Today’s glow settles deep/ Morning awaits 🌙",
        "Final glow alert: Tomorrow needs YOU 2.0 ⏰✨"
      ][i]; //make a list and choose randomly//ask ai to generate greetings
    },
  );
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
      if (!schedule.hasValue) {
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
          final hasTargetAction = daily.actions?.any((action) =>
              action.id == actionId &&
              action.instances?.any((inst) => inst.id == instanceId) == true);

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
          final updatedActions = daily.actions?.map(
            (e) {
              if (e.id == existingAction.id) {
                return newAction;
              } else {
                return e;
              }
            },
          ).toList();
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
          return AsyncValue.data(
            newAction,
          );
        },
        error: (error, stack) => AsyncValue.error(error, stack),
      );
    } catch (e, st) {
      state = AsyncValue<void>.error(e, st);
      rethrow;
    }
  }
}
