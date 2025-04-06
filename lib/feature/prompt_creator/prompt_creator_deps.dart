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
        print('pre  ${arg}');

        await store
            .record(
              DbKeys.userPersonalInfo,
            )
            .put(await LocalDB.db, arg.toMap())
            .then(
          (value) {
            print('ew ${arg}');
          },
        );
        print('post   ${arg}');
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
  static final promptProvider = StateProvider(
    (ref) async {
      var store = StoreRef.main();
      try {
        // Get stored images
        final storedImages = await store
            .record(DbKeys.userImages)
            .get(await LocalDB.db) as List<dynamic>?;

        if (storedImages == null || storedImages.isEmpty) {
          throw Exception("No images found in local storage");
        }

        // Safely convert each element to Uint8List
        final imageParts = <DataPart>[];
        for (final item in storedImages) {
          if (item is List<int>) {
            imageParts.add(DataPart('image/jpeg', Uint8List.fromList(item)));
          } else if (item is Uint8List) {
            imageParts.add(DataPart('image/jpeg', item));
          }
          // Add other type checks if needed
        }

        // Get personal info
        final promptInfoMap = await store
            .record(DbKeys.userPersonalInfo)
            .get(await LocalDB.db) as Map<String, dynamic>;
        final promptInfo = UserPersonalInfo.fromMap(promptInfoMap);

        final prompt =
            '''give a detailed routine/schedule to the person in the photo to give them a glow-up, I need you to specify the things that they need to work on, and then give me what their schedule would look like every day,
                   make the schedule realistic based on the info about the person do not give any unhealthy, harmful unrealistic actions, and no plastic surgeries, consider the following info about that person:
                  gender: ${promptInfo.gender}
                  birthDate : ${promptInfo.birthDate}
                 what they do as job: ${promptInfo.job}
                 their work schedule: ${promptInfo.workoutSchedule}
             how often they workout: ${promptInfo.activity}
              hobbies : ${promptInfo.hobbies}
              addition notes: ${promptInfo.notes}
              ''';
        final content = [
          Content.multi([
            TextPart(prompt),
            ...imageParts,
          ])
        ];

        var response = await ref.read(modelProvider).generateContent(content);
        print('response --${response.text}');
        return response.text;
      } catch (e) {
        print('error $e');
        rethrow;
      }
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
  static final promptPersonalInfoProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      ref.keepAlive();

      return useState<UserPersonalInfo>(UserPersonalInfo());
    },
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
      job: map['job'] as String,
      gender: map['gender'] as String,
      activity: map['activity'] as String,
      workoutSchedule: map['workoutSchedule'] as String,
      birthDate: map['birthDate'] as String,
      hobbies: map['hobbies'] as String,
      goals: map['goals'] as String,
      notes: map['notes'] as String,
    );
  }
}
