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
