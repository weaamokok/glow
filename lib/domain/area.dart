// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:glow/domain/action.dart';

class AreaOfFocus {
  final String? id;
  final String? title;
  final String? description;
  final List<GAction>? actions;

  AreaOfFocus({
    this.id,
    this.title,
    this.description,
    this.actions,
  });

  AreaOfFocus copyWith({
    String? id,
    String? title,
    String? description,
    List<GAction>? actions,
  }) {
    return AreaOfFocus(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      actions: actions ?? this.actions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'actions': actions?.map((x) => x.toMap()).toList(),
    };
  }

  factory AreaOfFocus.fromMap(Map<String, dynamic> map) {
    return AreaOfFocus(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      actions: map['actions'] != null
          ? List<GAction>.from(
              (map['actions'] as List<dynamic>).map<GAction?>(
                (x) => GAction.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }



  @override
  String toString() {
    return 'AreaOfFocus(id: $id, title: $title, description: $description, actions: $actions)';
  }

  @override
  bool operator ==(covariant AreaOfFocus other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        listEquals(other.actions, actions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        actions.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory AreaOfFocus.fromJson(String source) => AreaOfFocus.fromMap(json.decode(source) as Map<String, dynamic>);
}
