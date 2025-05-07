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

extension FirstWhereOrNullExtension<T> on Iterable<T> {
  /// Returns the first element that satisfies [test], or `null` if none.
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
