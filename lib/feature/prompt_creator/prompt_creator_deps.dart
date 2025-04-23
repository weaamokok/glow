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
Generate a detailed, personalized glow-up routine in JSON format for the person in the photo, considering their individual characteristics and lifestyle. The routine should be healthy, realistic, and sustainable. Follow this structure:

{
  "area_of_focus": [
    {
      "id": "1",
      "title": "Physical Health & Fitness",
      "description": "Specific improvement goals for this area",
      "actions": [
        {
          "id": "1",
          "title": "Action title",
          "description": "Detailed instructions",
          "time_range": "Morning/Afternoon/Evening or specific time if important",
          "duration": "X minutes/hours",
          "frequency": "Daily/Weekly/etc.",
          "repeated": true/false,
          "tips": "Additional helpful advice"
        }
      ]
    }
  ],
  "general_advice": "Overall recommendations for the glow-up journey"
}

Key requirements:
1. Create a holistic plan covering these areas (adjust based on individual needs):
   - Physical health & fitness
   - Skincare & grooming
   - Fashion & personal style
   - Mental wellbeing
   - Social skills & confidence
   - Hobby development

2. Personalization factors to consider:
   - Current age: ${testPromptInfo.birthDate ?? ''} (calculate age)
   - Gender: ${testPromptInfo.gender ?? ''}
   - Occupation: ${testPromptInfo.job ?? ''} (consider work demands and dress code)
   - Workout schedule: ${testPromptInfo.workoutSchedule ?? ''}
   - Current activity level: ${testPromptInfo.activity ?? ''}
   - Hobbies: ${testPromptInfo.hobbies ?? ''} (incorporate where possible)
   - Additional notes: ${testPromptInfo.notes ?? ''}
   - Additional notes: ${testPromptInfo.notes ?? ''}

3. Guidelines:
   - All suggestions must be healthy and safe
   - No unrealistic time commitments (max 1-2 new habits per week)
   - Gradual progression in difficulty
   - Budget-friendly options where possible
   - Include rest days and recovery time
   - Suggest measurable goals
   - Account for their existing schedule
   - Provide alternatives for different energy levels

4. Output notes:
   - Include estimated time commitments for each action
   - Specify whether actions are repeated or one-time
   - Add priority levels if certain actions are more important
   - Provide seasonal considerations if relevant
   - Include preparation steps where needed

The schedule should be practical enough to implement immediately while allowing flexibility for unexpected events. Focus on sustainable changes rather than quick fixes.
''';

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
      print('area of focus ${glowResponse.areaOfFocus?.length}');
      state = AsyncValue<GlowSchedule?>.data(glowResponse);
      return state;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.empty);
      debugPrint('Error in prompt response: $e');
      return state;
    }
  }
}
