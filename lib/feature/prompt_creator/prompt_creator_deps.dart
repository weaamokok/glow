import 'dart:io';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/app/db_keys.dart';
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
              (value) {},
            );
      } catch (e) {
        return false;
      }
      return true;
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

//<editor-fold desc="Data Methods">
  UserPersonalInfo({
    this.job,
    this.gender,
    this.activity,
    this.workoutSchedule,
    this.birthDate,
    this.hobbies,
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
          hobbies == other.hobbies);

  @override
  int get hashCode =>
      job.hashCode ^
      gender.hashCode ^
      activity.hashCode ^
      workoutSchedule.hashCode ^
      birthDate.hashCode ^
      hobbies.hashCode;

  @override
  String toString() {
    return 'UserPersonalInfo{'
        ' job: $job,'
        ' gender: $gender,'
        ' activity: $activity,'
        ' workoutSchedule: $workoutSchedule,'
        ' birthDate: $birthDate,'
        ' hobbies: $hobbies,'
        '}';
  }

  UserPersonalInfo copyWith({
    String? job,
    String? gender,
    String? activity,
    String? workoutSchedule,
    String? birthDate,
    String? hobbies,
  }) {
    return UserPersonalInfo(
      job: job ?? this.job,
      gender: gender ?? this.gender,
      activity: activity ?? this.activity,
      workoutSchedule: workoutSchedule ?? this.workoutSchedule,
      birthDate: birthDate ?? this.birthDate,
      hobbies: hobbies ?? this.hobbies,
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
    );
  }
}
