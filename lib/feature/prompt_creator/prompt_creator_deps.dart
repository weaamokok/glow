import 'dart:async';
import 'dart:convert';
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
import '../../domain/action_instance.dart';
import '../../domain/user_info.dart';
import '../../helper/helper_functions.dart';
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
          "startDate":"YYYY-MM-DD",
          "endDate":"YYYY-MM-DD",
          "frequency": ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"], // Days
          "recurring": true/false,
          "priority": "High/Medium/Low",
          "description": "Step-by-step instructions",
          "prep_needed": true/false,
          "location": "Home/Gym/Office/etc.",
      
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
-the actions starts from ${DateTime.now()} to 3 months add the start date and end date form actions accordingly
-make sure the json response in correctly formatted 
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

      debugPrint('response type${response.text.toString()}', wrapWidth: 100);
      final glowResponse = GlowSchedule.fromJson(response.text ?? '');
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
      ref.read(PromptCreatorDeps.saveGlowScheduleProvider(glowResponse));
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
      final prompt = '''
Update the following action by filling missing fields based on existing schedule context.
Return  the updated action and timeSlot in valid JSON format without any additional text or explanations.

Original action:
${action.toJson()}

Update rules:
1. Preserve existing values unless they're null/empty
2. Add realistic duration based on action type duration type is int in Minutes
3. Set appropriate category if missing
4. Generate sensible description if empty
5. Add recurrence rules if relevant
6. Never modify 'instances' field
7. Ensure all dates are in ISO 8601 format
8. add slot that matches the action
9. if action is not recurring create an $ActionInstance and set date property to ${DateTime.now()} it should look like {'id':'unique-id','date':'','status':'todo'}
match the types in the original glow up response 
the returned response should look like :
{
"action":${action.toJson()},//updated action
"slot":"Morning/Afternoon/Evening/Night"
}
''';

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
