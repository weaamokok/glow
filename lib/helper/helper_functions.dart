import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

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

extension FirstWhereOrNullExtension<T> on Iterable<T> {
  /// Returns the first element that satisfies [test], or `null` if none.
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
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
