import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

final indexBottomNavbarProvider = StateProvider<int>((ref) {
  return 0;
});
final model = Provider(
  (ref) => GenerativeModel(
      model: 'gemini-1.5-pro', apiKey: dotenv.env['API_KEY'] ?? ''),
);
final content = [Content.multi([])];

final isFirstRunProvider = Provider(
  (ref) async {
    //temporary
    final shared = await SharedPreferences.getInstance();
    final isFirstRun = shared.getBool('isFirstRun');
    if (isFirstRun == null) {
      return true;
      // shared.setBool('isFirstRun', true) ;
    } else if (isFirstRun) {
      return true;
    } else {
      return false;
    }
  },
);
