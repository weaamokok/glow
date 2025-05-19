// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'glow.dart';

class ActionInstance {
  String id;
  DateTime? date;
  ActionStatus? status;

  ActionInstance({
    required this.id,
    this.date,
    this.status,
  });

  ActionInstance copyWith({
    String? id,
    DateTime? date,
    ActionStatus? status,
  }) {
    return ActionInstance(
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date?.toIso8601String(),
      'status': status?.toJson(),
    };
  }

  factory ActionInstance.fromMap(Map<String, dynamic> map) {
    return ActionInstance(
      id: map['id'] as String,
      date:
          map['date'] != null ? DateTime.tryParse(map['date'] as String) : null,
      status: map['status'] != null
          ? ActionStatusExtension.fromJson(map['status'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActionInstance.fromJson(String source) =>
      ActionInstance.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ActionInstance(id: $id, date: $date, status: $status)';

  @override
  bool operator ==(covariant ActionInstance other) {
    if (identical(this, other)) return true;

    return other.id == id && other.date == date && other.status == status;
  }

  @override
  int get hashCode => id.hashCode ^ date.hashCode ^ status.hashCode;
}
