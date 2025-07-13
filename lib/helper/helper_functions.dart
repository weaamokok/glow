import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

String removeEmojis(String input) {
  // Regex pattern to match most emojis
  const emojiRegex =
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';
  return input.replaceAll(RegExp(emojiRegex), '');
}

DateTime getDateTimeWithTime(String timeString) {
  final now = DateTime.now();
  try {
    final parsedTime = DateFormat.Hm().parse(timeString);

    return DateTime(
        now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
  } catch (e) {
    // Fallback to current time
    return DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }
}

DateTime getDateTimeWithNoTime(String dateString) {
  final now = DateTime.now();
  try {
    final parsedTime = DateFormat('yyyy-MM-dd').parse(dateString);

    return DateTime(parsedTime.year, parsedTime.month, parsedTime.day, 00, 00);
  } catch (e) {
    debugPrint('error in getting date -$e');
    // Fallback to current time
    return DateTime(now.year, now.month, now.day, 00, 00);
  }
}

Future<List<File?>> uint8ListToFile(List<dynamic> imagesFromMemory) async {
  try {
    final tempDir = await getTemporaryDirectory();

    final files =
        await Future.wait(imagesFromMemory.asMap().entries.map((entry) async {
      final index = entry.key;
      final imageData = entry.value;

      Uint8List bytes;
      if (imageData is Uint8List) {
        bytes = imageData;
      } else if (imageData is List<Object?>) {
        bytes = Uint8List.fromList(imageData.cast<int>());
      } else {
        return null;
      }

      final file = File('${tempDir.path}/user_image_$index.jpg');
      await file.writeAsBytes(bytes);
      print('file is $file');
      return file;
    }));

    return files;
  } catch (e) {
    print('error: $e');
    return [];
  }
}

extension FirstWhereOrNullExtension<T> on Iterable<T> {
  /// Returns the first element that satisfies [test], or `null` if none.
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension LocaleMapExtension on Locale? {
  Map<String, String?>? toMap() {
    if (this == null) return null;
    return {
      'languageCode': this!.languageCode,
      'countryCode': this!.countryCode,
    };
  }

  static Locale? fromMap(Map<String, dynamic>? map) {
    if (map == null || map['languageCode'] == null) return null;
    return Locale(
      map['languageCode'] as String,
      map['countryCode'] as String?,
    );
  }
}

List<DateTime?> currentWeek() {
  return List.generate(
    7,
    (index) {
      if (index < 3) {
        return DateTime.now().subtract(Duration(days: index + 1));
      } else if (index == 3) {
        return DateTime.now();
      } else if (index > 3) {
        return DateTime.now().add(Duration(days: 7 - index));
      } else {
        return null;
      }
    },
  );
}

String getEmojiFromIconId(String? iconId) {
  switch (iconId) {
    case '01d':
      return '☀️'; // Clear sky day
    case '01n':
      return '🌙'; // Clear sky night
    case '02d':
    case '02n':
      return '⛅'; // Few clouds
    case '03d':
    case '03n':
      return '☁️'; // Scattered clouds
    case '04d':
    case '04n':
      return '🌥️'; // Broken clouds
    case '09d':
    case '09n':
      return '🌧️'; // Shower rain
    case '10d':
    case '10n':
      return '🌦️'; // Rain
    case '11d':
    case '11n':
      return '⛈️'; // Thunderstorm
    case '13d':
    case '13n':
      return '❄️'; // Snow
    case '50d':
    case '50n':
      return '🌫️'; // Mist
    default:
      return '❓'; // Unknown
  }
}

final weekDays = ["Mon", "Tues", "Wed", "Thur", "Fri", "Sat", "Sun"];
