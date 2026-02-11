import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static Future<void> init() async {
    if (dotenv.isInitialized) return;
    await dotenv.load(fileName: '.env');
  }

  static String get baseUrl {
    if (!dotenv.isInitialized) {
      throw StateError(
        'AppEnv not initialized. Call AppEnv.init() before using baseUrl.',
      );
    }
    final raw = dotenv.env['Base_URL'] ?? '';
    return raw.trim().replaceAll(RegExp(r'/+$'), '');
  }
}
