import 'dart:async';
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/app/db_keys.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sembast/sembast.dart';

import '../../app/local_db.dart';
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
              (value) {},
            );
      } catch (e) {
        return false;
      }
      return true;
    },
  );
  static final addPromptPersonalInfoProvider =
      StateProviderFamily<Future<bool>, UserPersonalInfo>(
    (ref, arg) async {
      //add image to local
      var store = StoreRef.main();
      // final personalInfo = arg.map(
      //   (e) => e?.value.text,
      // );
      try {
        await store
            .record(
              DbKeys.userPersonalInfo,
            )
            .put(await LocalDB.db, arg.toMap())
            .then(
          (value) {
            // print('ew ${arg}');
          },
        );
        // print('post   ${arg}');
      } catch (e) {
        print('error $e');
        return false;
      }
      return true;
    },
  );
  static final modelProvider = Provider<GenerativeModel>(
    (ref) {
      final apiKey = dotenv.get(
        'GOOGLE_AI_API_KEY',
      );

      return GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
      );
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

class UserPersonalInfo {
  String? job;
  String? gender;
  String? activity;
  String? workoutSchedule;
  String? birthDate;
  String? hobbies;
  String? goals;
  String? notes;

//<editor-fold desc="Data Methods">
  UserPersonalInfo({
    this.job,
    this.gender,
    this.activity,
    this.workoutSchedule,
    this.birthDate,
    this.hobbies,
    this.goals,
    this.notes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPersonalInfo &&
          runtimeType == other.runtimeType &&
          job == other.job &&
          gender == other.gender &&
          activity == other.activity &&
          workoutSchedule == other.workoutSchedule &&
          birthDate == other.birthDate &&
          hobbies == other.hobbies &&
          goals == other.goals &&
          notes == other.notes);

  @override
  int get hashCode =>
      job.hashCode ^
      gender.hashCode ^
      activity.hashCode ^
      workoutSchedule.hashCode ^
      birthDate.hashCode ^
      hobbies.hashCode ^
      goals.hashCode ^
      notes.hashCode;

  @override
  String toString() {
    return 'UserPersonalInfo{'
        ' job: $job,'
        ' gender: $gender,'
        ' activity: $activity,'
        ' workoutSchedule: $workoutSchedule,'
        ' birthDate: $birthDate,'
        ' hobbies: $hobbies,'
        ' goals: $goals,'
        ' notes: $notes,'
        '}';
  }

  UserPersonalInfo copyWith({
    String? job,
    String? gender,
    String? activity,
    String? workoutSchedule,
    String? birthDate,
    String? hobbies,
    String? goals,
    String? notes,
  }) {
    return UserPersonalInfo(
      job: job ?? this.job,
      gender: gender ?? this.gender,
      activity: activity ?? this.activity,
      workoutSchedule: workoutSchedule ?? this.workoutSchedule,
      birthDate: birthDate ?? this.birthDate,
      hobbies: hobbies ?? this.hobbies,
      goals: goals ?? this.goals,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'job': job,
      'gender': gender,
      'activity': activity,
      'workoutSchedule': workoutSchedule,
      'birthDate': birthDate,
      'hobbies': hobbies,
      'goals': goals,
      'notes': notes,
    };
  }

  factory UserPersonalInfo.fromMap(Map<String, dynamic> map) {
    return UserPersonalInfo(
      job: map['job'] as String?,
      gender: map['gender'] as String?,
      activity: map['activity'] as String?,
      workoutSchedule: map['workoutSchedule'] as String?,
      birthDate: map['birthDate'] as String?,
      hobbies: map['hobbies'] as String?,
      goals: map['goals'] as String?,
      notes: map['notes'] as String?,
    );
  }
}

class PromptNotifier extends StateNotifier<FutureOr<AsyncValue<String?>>> {
  PromptNotifier() : super(const AsyncLoading());

  FutureOr<AsyncValue<String?>> submitPrompt({required WidgetRef ref}) async {
    AsyncValue<String?> state = AsyncValue.loading();
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
      print('stored images $storedImages');
      for (final item in storedImages) {
        print('item type ${item.runtimeType}');

        // Handle ImmutableList<Object?> case
        if (item is List<Object?>) {
          try {
            // Convert List<Object?> to List<int>
            final List<int> bytes = item.cast<int>();
            imageParts.add(DataPart('image/jpg', Uint8List.fromList(bytes)));
            print('Successfully converted ImmutableList<Object?> to Uint8List');
          } catch (e) {
            print('Failed to cast item to List<int>: $e');
            continue; // Skip invalid entries
          }
        } else if (item is Uint8List) {
          print('Item is already Uint8List');
          imageParts.add(DataPart('image/jpg', item));
        } else {
          print('Unsupported type: ${item.runtimeType}');
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

      final prompt =
          '''return a detailed routine/schedule to the person in the photo to give them a glow-up in JSON in the following structure :
            {
"area_of_focus": [
"id": "1",
"title": "Physical Health & Fitness",
actions:
["id":"","title":"","time_range":"","repeated":false,]
],
}
            , I need you to specify the things that they need to work on, and then give me what their schedule would look like every day,
                   make the schedule realistic based on the info about the person do not give any unhealthy, harmful unrealistic actions, and no plastic surgeries, consider the following info about that person:
                  gender: ${testPromptInfo.gender ?? ''}
                  birthDate : ${testPromptInfo.birthDate ?? ''}
                 what they do as job: ${testPromptInfo.job ?? ''}
                 their work schedule: ${testPromptInfo.workoutSchedule ?? ''}
             how often they workout: ${testPromptInfo.activity ?? ''}
              hobbies : ${testPromptInfo.hobbies ?? ''}
              addition notes: ${testPromptInfo.notes ?? ''}

              ''';
      final content = [
        Content.multi([
          TextPart(prompt),
          ...imageParts,
        ])
      ];
      print('--prompt image part ${imageParts}');
      final response =
          await ref.read(PromptCreatorDeps.modelProvider).generateContent(
                content,
              );
      print('response --${response.text}');
      state = AsyncValue<String?>.data(response.text);
      return state;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.empty);
      print('error $e');
      return state;
    }
  }
}
