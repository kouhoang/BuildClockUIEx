import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _backgroundKey = 'background_image_path';

  static Future<String?> getBackgroundPath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_backgroundKey);
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveBackgroundPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backgroundKey, path);
  }

  static Future<void> removeBackgroundPath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_backgroundKey);
  }
}
