// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GAction {
  GAction({
    this.id,
    this.title,
    this.description,
    this.timeRange,
    this.duration,
    this.frequency,
    this.repeated,
    this.setReminder,
    this.tips,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? timeRange;
  final bool? repeated;
  final bool? setReminder;
  final String? duration;
  final String? frequency;
  final String? tips;

  GAction copyWith({
    String? id,
    String? title,
    String? description,
    String? timeRange,
    bool? repeated,
    bool? setReminder,
  }) {
    return GAction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timeRange: timeRange ?? this.timeRange,
      repeated: repeated ?? this.repeated,
      setReminder: setReminder ?? this.setReminder,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'time_range': timeRange,
      'repeated': repeated,
      'set_reminder': setReminder,
    };
  }

  factory GAction.fromMap(Map<String, dynamic> map) {
    return GAction(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      timeRange: map['time_range'] != null ? map['time_range'] as String : null,
      repeated: map['repeated'] != null ? map['repeated'] as bool : null,
      setReminder:
          map['set_reminder'] != null ? map['set_reminder'] as bool : null,
    );
  }

  @override
  String toString() {
    return 'GAction(id: $id, title: $title, description: $description, time_range: $timeRange, repeated: $repeated, set_reminder: $setReminder)';
  }

  @override
  bool operator ==(covariant GAction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.timeRange == timeRange &&
        other.repeated == repeated &&
        other.setReminder == setReminder;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        timeRange.hashCode ^
        repeated.hashCode ^
        setReminder.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory GAction.fromJson(String source) =>
      GAction.fromMap(json.decode(source) as Map<String, dynamic>);
}
