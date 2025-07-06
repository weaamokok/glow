import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../domain/user_info.dart';

class PromptLoader {
  static Map<String, String>? _prompts;

  static Future<void> loadPrompts() async {
    final jsonString =
        await rootBundle.loadString('assets/prompts/schedule_prompts.json');
    print('recived json${jsonString}');
    final cleanJson = jsonString
        .replaceAll(r'\', r'\\')
        .replaceAll('\n', r'\n')
        .replaceAll('"', r'\"');

    ;
    final Map<String, dynamic> jsonMap = jsonDecode(cleanJson);

    _prompts = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static String? getPrompt(String langCode) {
    return _prompts?[langCode] ?? _prompts?['en'];
  }

  static String renderPrompt(String template, UserPersonalInfo user) {
    return template
        .replaceAll('{birthDate}', user.birthDate ?? '')
        .replaceAll('{job}', user.job ?? '')
        .replaceAll('{workoutSchedule}', user.workoutSchedule ?? '')
        .replaceAll('{hobbies}', user.hobbies ?? "")
        .replaceAll('{goals}', user.goals ?? '')
        .replaceAll('{notes}', user.notes ?? '')
        .replaceAll('{gender}', user.gender ?? '');
  }

  String escapeJson(String input) => input
      .replaceAll(r'\', r'\\')
      .replaceAll('\n', r'\n')
      .replaceAll('"', r'\"');

  static Future<String> getFilledPrompt({
    required Locale locale,
    required UserPersonalInfo userInfo,
  }) async {
    print('local $locale');

    if (_prompts == null) {
      await loadPrompts();
    }
    final langCode = locale.languageCode;
    final raw = getPrompt(langCode);
    if (raw == null) {
      throw Exception('Prompt not found for language: $langCode');
    }
    return renderPrompt(raw, userInfo);
  }
}
