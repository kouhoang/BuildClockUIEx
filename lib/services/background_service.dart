import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';

class BackgroundService {
  static const String _backgroundKey = 'background_image_path';
  static String? _currentBackgroundPath;

  // Stream controller to notify when background changes
  static final StreamController<String?> _backgroundController =
      StreamController<String?>.broadcast();

  // Stream to listen background changes
  static Stream<String?> get backgroundStream => _backgroundController.stream;

  static String? get currentBackgroundPath => _currentBackgroundPath;

  static Future<void> loadBackground() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPath = prefs.getString(_backgroundKey);
      if (savedPath != null && File(savedPath).existsSync()) {
        _currentBackgroundPath = savedPath;
      } else {
        _currentBackgroundPath = null;
      }
      // Notify listeners only if controller is not closed
      if (!_backgroundController.isClosed) {
        _backgroundController.add(_currentBackgroundPath);
      }
    } catch (e) {
      _currentBackgroundPath = null;
      if (!_backgroundController.isClosed) {
        _backgroundController.add(null);
      }
    }
  }

  static Future<void> saveBackground(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_backgroundKey, path);
      _currentBackgroundPath = path;
      // Notify all listeners về background mới
      if (!_backgroundController.isClosed) {
        _backgroundController.add(_currentBackgroundPath);
      }
    } catch (e) {
      throw Exception('Failed to save background');
    }
  }

  static Future<void> removeBackground() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_backgroundKey);
      _currentBackgroundPath = null;
      // Notify all listeners background removed
      if (!_backgroundController.isClosed) {
        _backgroundController.add(null);
      }
    } catch (e) {
      throw Exception('Failed to remove background');
    }
  }

  static void dispose() {
    if (!_backgroundController.isClosed) {
      _backgroundController.close();
    }
  }
}
