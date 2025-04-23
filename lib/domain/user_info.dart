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
