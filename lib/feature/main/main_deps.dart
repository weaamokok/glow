import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final indexBottomNavbarProvider = StateProvider<int>((ref) {
  return 0;
});
final model = Provider(
  (ref) => GenerativeModel(
      model: 'gemini-1.5-pro', apiKey: dotenv.env['API_KEY'] ?? ''),
);
final content = [Content.multi([])];
