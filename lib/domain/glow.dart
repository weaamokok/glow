// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:glow/domain/area.dart';

class GlowResponse {
  GlowResponse({
    this.areaOfFocus,
    this.generalAdvice,
  });

  final List<AreaOfFocus>? areaOfFocus;
  final String? generalAdvice;

  GlowResponse copyWith({
    List<AreaOfFocus>? areaOfFocus,
    String? generalAdvice,
  }) {
    return GlowResponse(
      areaOfFocus: areaOfFocus ?? this.areaOfFocus,
      generalAdvice: generalAdvice ?? this.generalAdvice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'area_of_focus': areaOfFocus?.map((x) => x.toMap()).toList(),
      'general_advice': generalAdvice,
    };
  }
factory GlowResponse.fromMap(Map<String, dynamic> map) {
  return GlowResponse(
    areaOfFocus: map['area_of_focus'] != null
        ? List<AreaOfFocus>.from(
            (map['area_of_focus'] as List<dynamic>).map<AreaOfFocus>(
              (x) => AreaOfFocus.fromMap(x as Map<String, dynamic>),
            ),
          )
        : null,
    generalAdvice: map['general_advice'] != null
        ? map['general_advice'] as String
        : null,
  );
}

  @override
  String toString() =>
      'GlowResponse(area_of_focus: $areaOfFocus, general_advice: $generalAdvice)';

  @override
  bool operator ==(covariant GlowResponse other) {
    if (identical(this, other)) return true;

    return listEquals(other.areaOfFocus, areaOfFocus) &&
        other.generalAdvice == generalAdvice;
  }

  @override
  int get hashCode => areaOfFocus.hashCode ^ generalAdvice.hashCode;

  String toJson() => json.encode(toMap());

  factory GlowResponse.fromJson(String source) =>
      GlowResponse.fromMap(json.decode(
        source,
        reviver: (key, value) => value,
      ) as Map<String, dynamic>);
}
