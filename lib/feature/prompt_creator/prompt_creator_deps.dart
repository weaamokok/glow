import 'dart:async';
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/app/db_keys.dart';
import 'package:glow/domain/glow.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sembast/sembast.dart';

import '../../app/local_db.dart';
import '../../domain/user_info.dart';
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
      StateProviderFamily<Future<bool>, GlowSchedule>(
    (ref, arg) async {
      //add image to local
      var store = StoreRef.main();

      try {
        await store
            .record(
              DbKeys.glowSchedule,
            )
            .put(await LocalDB.db, arg.toMap())
            .then(
          (value) {
            debugPrint('glow schedule added successfully');
          },
        );
        // print('post   ${arg}');
      } catch (e) {
        debugPrint('failed to add glow schedule: $e');
        return false;
      }
      return true;
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
      StateNotifierProvider<PromptNotifier, FutureOr<AsyncValue<String?>>>(
          (ref) {
    //  PromptNotifier.submitPrompt(ref: ref);
    return PromptNotifier();
  });

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

class PromptNotifier extends StateNotifier<FutureOr<AsyncValue<String?>>> {
  PromptNotifier() : super(const AsyncLoading());

  FutureOr<AsyncValue<GlowSchedule?>> submitPrompt(
      {required WidgetRef ref}) async {
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
      final promptInfoMap = await store
          .record(DbKeys.userPersonalInfo)
          .get(await LocalDB.db) as Map<String, dynamic>;
      final promptInfo = UserPersonalInfo.fromMap(promptInfoMap);
      final testPromptInfo = UserPersonalInfo(
        job: 'doctor',
        gender: 'female',
        activity: ' mostly standing',
        workoutSchedule: '3 days a week or less',
        birthDate: '1998-01-01',
        hobbies: 'nothing',
        goals: 'to be prettier',
        notes: '..',
      );

      final prompt = '''
Generate a personalized glow-up routine in JSON format optimized for calendar/schedule display. Follow these requirements:

1. **Structure Requirements:**
{
  "daily_schedule": [
    {
      "time_slot": "Morning/Afternoon/Evening/Night",
      "start_time": "HH:MM", // Estimated ideal time
      "actions": [
        {
          "id": "unique-id",
          "title": "Action name",
          "duration": X, // Minutes
          "category": "Physical|Skincare|Mental|etc.",
          "frequency": ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"], // Days
          "recurring": true/false,
          "priority": "High/Medium/Low",
          "description": "Step-by-step instructions",
          "prep_needed": true/false,
          "location": "Home/Gym/Office/etc."
        }
      ]
    }
  ],
  "weekly_goals": [
    {
      "id": "unique-id",
      "title": "Goal name",
      "type": "Social|Fitness|Skill|etc.",
      "frequency": "Weekly/Bi-weekly",
      "best_day": "Monday-Friday",
      "duration": X, // Minutes
      "time_of_day": "Morning/Afternoon/Evening"
    }
  ],
  "preparation_list": [
    {
      "id": "unique-id",
      "task": "Item to acquire/prepare",
      "category": "Shopping/Research/Setup",
      "deadline": "YYYY-MM-DD",
      "urgency": "High/Medium/Low"
    }
  ],
  "progress_milestones": [
    {
      "id": "unique-id",
      "title": "Milestone name",
      "target_date": "YYYY-MM-DD",
      "success_metrics": ["metric1", "metric2"]
    }
  ]
}

2. **Key Personalization Factors:**
- Age: ${testPromptInfo.birthDate}
- Occupation: ${testPromptInfo.job} (consider commute/working hours)
- Current fitness schedule: ${testPromptInfo.workoutSchedule}
- Style preferences/note to consider: ${testPromptInfo.notes}
- hobbies: ${testPromptInfo.hobbies}
- personal goal: ${testPromptInfo.goals}
- gender: ${testPromptInfo.gender}
- Available time slots: {calculate_free_time_based_on_job}
- Budget: {estimate_based_on_occupation}

3. **Scheduling Rules:**
- Never schedule more than 2 new habits per week
- Minimum 30 minutes buffer between work-related and self-care activities
- Morning routines max 45 minutes
- Evening routines max 1 hour
- Weekly goals should align with days off work when possible
- Include progressive overload for fitness goals

4. **Output Requirements:**
- All time slots must have concrete start times add related emoji to time_slot
- Duration in whole minutes only
- Include location requirements
- Specify needed preparation items
- Add progress checkpoints
- Flag conflicts with typical work hours
- Include alternate actions for bad days

5. **Special Instructions:**
- Assume user wakes up at {calculate_wakeup_time_based_on_job}
- Prioritize home-based activities for first 2 weeks
- Suggest specific YouTube workout videos when relevant
- Recommend exact product names for skincare don't recommend product from companies that support israel, recommend korean skin care but not from COSRX company
- Include 5-minute buffer between consecutive tasks

Focus on creating a time-bound, executable schedule rather than general advice. The output should be ready for direct import into a digital calendar.''';

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

      debugPrint('response type${response.text ?? ''}');

      final glowResponse = GlowSchedule.fromJson(response.text ?? '');
      ref.read(PromptCreatorDeps.saveGlowScheduleProvider(glowResponse));
  
      state = AsyncValue<GlowSchedule?>.data(glowResponse);
      return state;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.empty);
      debugPrint('Error in prompt response: $e');
      return state;
    }
  }
}
