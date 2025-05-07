// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:glow/helper/helper_functions.dart';

class GlowSchedule {
  GlowSchedule({
    required this.dailySchedule,
    required this.weeklyGoals,
    required this.preparationList,
    required this.progressMilestones,
  });

  final List<DailyTimeSlot> dailySchedule;
  final List<WeeklyGoal> weeklyGoals;
  final List<PreparationItem> preparationList;
  final List<ProgressMilestone> progressMilestones;

  GlowSchedule copyWith({
    List<DailyTimeSlot>? dailySchedule,
    List<WeeklyGoal>? weeklyGoals,
    List<PreparationItem>? preparationList,
    List<ProgressMilestone>? progressMilestones,
  }) {
    return GlowSchedule(
      dailySchedule: dailySchedule ?? this.dailySchedule,
      weeklyGoals: weeklyGoals ?? this.weeklyGoals,
      preparationList: preparationList ?? this.preparationList,
      progressMilestones: progressMilestones ?? this.progressMilestones,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'daily_schedule': dailySchedule.map((x) => x.toMap()).toList(),
      'weekly_goals': weeklyGoals.map((x) => x.toMap()).toList(),
      'preparation_list': preparationList.map((x) => x.toMap()).toList(),
      'progress_milestones': progressMilestones.map((x) => x.toMap()).toList(),
    };
  }

  factory GlowSchedule.fromMap(Map<String, dynamic> map) {
    return GlowSchedule(
      dailySchedule: List<DailyTimeSlot>.from(
        (map['daily_schedule'] as List<dynamic>).map<DailyTimeSlot>(
          (x) => DailyTimeSlot.fromMap(x as Map<String, dynamic>),
        ),
      ),
      weeklyGoals: List<WeeklyGoal>.from(
        (map['weekly_goals'] as List<dynamic>).map<WeeklyGoal>(
          (x) => WeeklyGoal.fromMap(x as Map<String, dynamic>),
        ),
      ),
      preparationList: List<PreparationItem>.from(
        (map['preparation_list'] as List<dynamic>).map<PreparationItem>(
          (x) => PreparationItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      progressMilestones: List<ProgressMilestone>.from(
        (map['progress_milestones'] as List<dynamic>).map<ProgressMilestone>(
          (x) => ProgressMilestone.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GlowSchedule.fromJson(String source) =>
      GlowSchedule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GlowSchedule(daily_schedule: $dailySchedule, weekly_goals: $weeklyGoals, preparation_list: $preparationList, progress_milestones: $progressMilestones)';
  }

  @override
  bool operator ==(covariant GlowSchedule other) {
    if (identical(this, other)) return true;

    return listEquals(other.dailySchedule, dailySchedule) &&
        listEquals(other.weeklyGoals, weeklyGoals) &&
        listEquals(other.preparationList, preparationList) &&
        listEquals(other.progressMilestones, progressMilestones);
  }

  @override
  int get hashCode {
    return dailySchedule.hashCode ^
        weeklyGoals.hashCode ^
        preparationList.hashCode ^
        progressMilestones.hashCode;
  }
}

class DailyTimeSlot {
  final Slot? timeSlot;
  final String? startTime;
  final List<ScheduleAction>? actions;

  DailyTimeSlot({
    required this.timeSlot,
    required this.startTime,
    required this.actions,
  });

  DailyTimeSlot copyWith({
    Slot? timeSlot,
    String? startTime,
    List<ScheduleAction>? actions,
  }) {
    return DailyTimeSlot(
      timeSlot: timeSlot ?? this.timeSlot,
      startTime: startTime ?? this.startTime,
      actions: actions ?? this.actions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time_slot': timeSlot?.toJson(),
      'start_time': startTime,
      'actions': actions?.map((x) => x.toMap()).toList(),
    };
  }

  factory DailyTimeSlot.fromMap(Map<String, dynamic> map) {
    return DailyTimeSlot(
      timeSlot: map['time_slot'] != null
          ? TimeSlotExtension.fromJson(
              removeEmojis(map['time_slot']).toString().toLowerCase())
          : null,
      startTime: map['start_time'] as String,
      actions: map['actions'] != null
          ? List<ScheduleAction>.from(
              (map['actions'] as List<dynamic>).map<ScheduleAction>(
                (x) => ScheduleAction.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyTimeSlot.fromJson(String source) =>
      DailyTimeSlot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DailyTimeSlot(time_slot: $timeSlot, start_time: $startTime, actions: $actions)';

  @override
  bool operator ==(covariant DailyTimeSlot other) {
    if (identical(this, other)) return true;

    return other.timeSlot == timeSlot &&
        other.startTime == startTime &&
        listEquals(other.actions, actions);
  }

  @override
  int get hashCode => timeSlot.hashCode ^ startTime.hashCode ^ actions.hashCode;
}

class ScheduleAction {
  ScheduleAction({
    required this.id,
    required this.title,
    required this.duration,
    required this.category,
    required this.frequency,
    required this.recurring,
    required this.priority,
    required this.description,
    this.prepNeeded = false,
    this.location,
  });

  final String id;
  final String? title;
  final int? duration;
  final String? category;
  final List<String>? frequency;
  final bool recurring;
  final String? priority;
  final String? description;
  final bool? prepNeeded;
  final String? location;

  ScheduleAction copyWith({
    String? id,
    String? title,
    int? duration,
    String? category,
    List<String>? frequency,
    bool? recurring,
    String? priority,
    String? description,
    bool? prepNeeded,
    String? location,
  }) {
    return ScheduleAction(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      recurring: recurring ?? this.recurring,
      priority: priority ?? this.priority,
      description: description ?? this.description,
      prepNeeded: prepNeeded ?? this.prepNeeded,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'duration': duration,
      'category': category,
      'frequency': frequency,
      'recurring': recurring,
      'priority': priority,
      'description': description,
      'prep_needed': prepNeeded,
      'location': location,
    };
  }

  factory ScheduleAction.fromMap(Map<String, dynamic> map) {
    return ScheduleAction(
      id: map['id'] as String,
      title: map['title'] as String,
      duration: map['duration'] as int,
      category: map['category'] as String,
      frequency: map['frequency'] != null
          ? List<String>.from(map['frequency']
              as List<dynamic>) // Cast dynamic list to String list
          : null,
      recurring: map['recurring'] as bool,
      priority: map['priority'] as String,
      description: map['description'] as String,
      prepNeeded: map['prep_needed'] as bool,
      location: map['location'] != null ? map['location'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleAction.fromJson(String source) =>
      ScheduleAction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ScheduleAction(id: $id, title: $title, duration: $duration, category: $category, frequency: $frequency, recurring: $recurring, priority: $priority, description: $description, prep_needed: $prepNeeded, location: $location)';
  }

  @override
  bool operator ==(covariant ScheduleAction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.duration == duration &&
        other.category == category &&
        listEquals(other.frequency, frequency) &&
        other.recurring == recurring &&
        other.priority == priority &&
        other.description == description &&
        other.prepNeeded == prepNeeded &&
        other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        duration.hashCode ^
        category.hashCode ^
        frequency.hashCode ^
        recurring.hashCode ^
        priority.hashCode ^
        description.hashCode ^
        prepNeeded.hashCode ^
        location.hashCode;
  }
}

class WeeklyGoal {
  final String? id;
  final String? title;
  final String? type;
  final String? frequency;
  final String? bestDay;
  final int? duration;
  final String? timeOfDay;

  WeeklyGoal({
    required this.id,
    required this.title,
    required this.type,
    required this.frequency,
    required this.bestDay,
    required this.duration,
    required this.timeOfDay,
  });

  WeeklyGoal copyWith({
    String? id,
    String? title,
    String? type,
    String? frequency,
    String? bestDay,
    int? duration,
    String? timeOfDay,
  }) {
    return WeeklyGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      bestDay: bestDay ?? this.bestDay,
      duration: duration ?? this.duration,
      timeOfDay: timeOfDay ?? this.timeOfDay,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'type': type,
      'frequency': frequency,
      'best_day': bestDay,
      'duration': duration,
      'time_of_day': timeOfDay,
    };
  }

  factory WeeklyGoal.fromMap(Map<String, dynamic> map) {
    return WeeklyGoal(
      id: map['id'] as String,
      title: map['title'] as String,
      type: map['type'] as String,
      frequency: map['frequency'] as String,
      bestDay: map['best_day'] as String?,
      duration: map['duration'] as int,
      timeOfDay: map['time_of_day'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WeeklyGoal.fromJson(String source) =>
      WeeklyGoal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WeeklyGoal(id: $id, title: $title, type: $type, frequency: $frequency, best_day: $bestDay, duration: $duration, time_of_day: $timeOfDay)';
  }

  @override
  bool operator ==(covariant WeeklyGoal other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.type == type &&
        other.frequency == frequency &&
        other.bestDay == bestDay &&
        other.duration == duration &&
        other.timeOfDay == timeOfDay;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        type.hashCode ^
        frequency.hashCode ^
        bestDay.hashCode ^
        duration.hashCode ^
        timeOfDay.hashCode;
  }
}

class PreparationItem {
  final String? id;
  final String? task;
  final String? category;
  final DateTime? deadline;
  final String? urgency;

  PreparationItem({
    required this.id,
    required this.task,
    required this.category,
    required this.deadline,
    required this.urgency,
  });

  PreparationItem copyWith({
    String? id,
    String? task,
    String? category,
    DateTime? deadline,
    String? urgency,
  }) {
    return PreparationItem(
      id: id ?? this.id,
      task: task ?? this.task,
      category: category ?? this.category,
      deadline: deadline ?? this.deadline,
      urgency: urgency ?? this.urgency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'task': task,
      'category': category,
      'deadline': deadline.toString(),
      'urgency': urgency,
    };
  }

  factory PreparationItem.fromMap(Map<String, dynamic> map) {
    return PreparationItem(
      id: map['id'] as String,
      task: map['task'] as String,
      category: map['category'] as String,
      deadline: DateTime.tryParse(map['deadline']),
      // Parse ISO string
      urgency: map['urgency'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PreparationItem.fromJson(String source) =>
      PreparationItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PreparationItem(id: $id, task: $task, category: $category, deadline: $deadline, urgency: $urgency)';
  }

  @override
  bool operator ==(covariant PreparationItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.task == task &&
        other.category == category &&
        other.deadline == deadline &&
        other.urgency == urgency;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        task.hashCode ^
        category.hashCode ^
        deadline.hashCode ^
        urgency.hashCode;
  }
}

class ProgressMilestone {
  final String? id;
  final String? title;
  final DateTime? targetDate;
  final List<String>? successMetrics;

  ProgressMilestone({
    required this.id,
    required this.title,
    required this.targetDate,
    required this.successMetrics,
  });

  ProgressMilestone copyWith({
    String? id,
    String? title,
    DateTime? targetDate,
    List<String>? successMetrics,
  }) {
    return ProgressMilestone(
      id: id ?? this.id,
      title: title ?? this.title,
      targetDate: targetDate ?? this.targetDate,
      successMetrics: successMetrics ?? this.successMetrics,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'target_date': targetDate?.toString(),
      'success_metrics': successMetrics,
    };
  }

  factory ProgressMilestone.fromMap(Map<String, dynamic> map) {
    return ProgressMilestone(
      id: map['id'] as String,
      title: map['title'] as String,
      targetDate: DateTime.tryParse(map['target_date']),
      // Parse ISO string

      successMetrics: map['success_metrics'] != null
          ? List<String>.from(map['success_metrics']
              as List<dynamic>) // Cast dynamic list to String list
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProgressMilestone.fromJson(String source) =>
      ProgressMilestone.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProgressMilestone(id: $id, title: $title, target_date: $targetDate, success_metrics: $successMetrics)';
  }

  @override
  bool operator ==(covariant ProgressMilestone other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.targetDate == targetDate &&
        listEquals(other.successMetrics, successMetrics);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        targetDate.hashCode ^
        successMetrics.hashCode;
  }
}

enum Slot {
  morning,
  evening,
  night,
  afternoon,
  undefined;
}

extension TimeSlotExtension on Slot {
  String toJson() {
    return toString().split('.').last;
  }

  static Slot fromJson(String raw) {
    final clean = raw.replaceAll(RegExp(r'[^a-zA-Z]'), '').toLowerCase();

    return switch (clean) {
      'morning' => Slot.morning,
      'afternoon' => Slot.afternoon,
      'evening' => Slot.evening,
      'night' => Slot.night,
      _ => Slot.undefined,
    };
  }
}
