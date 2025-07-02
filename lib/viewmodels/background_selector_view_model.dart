import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import '../models/background_config.dart';
import '../services/background_service.dart';
import 'base_view_model.dart';

class BackgroundSelectorViewModel extends BaseViewModel {
  final ImagePicker _picker = ImagePicker();
  StreamSubscription<String?>? _backgroundSubscription;
  BackgroundConfig _backgroundConfig = BackgroundConfig();

  // Callback for success/error messages
  Function(String)? onSuccess;
  Function(String)? onError;

  BackgroundConfig get backgroundConfig => _backgroundConfig;

  void initialize() async {
    if (isDisposed) return;

    await _loadBackground();
    _backgroundSubscription = BackgroundService.backgroundStream.listen((
      backgroundPath,
    ) {
      if (isDisposed) return;
      _backgroundConfig = BackgroundConfig(imagePath: backgroundPath);
      notifyListeners();
    });
  }

  Future<void> _loadBackground() async {
    if (isDisposed) return;

    setLoading(true);
    try {
      await BackgroundService.loadBackground();
      if (isDisposed) return;
      _backgroundConfig = BackgroundConfig(
        imagePath: BackgroundService.currentBackgroundPath,
      );
      notifyListeners();
    } catch (e) {
      if (isDisposed) return;
      setError('Failed to load background: $e');
      onError?.call('Failed to load background: $e');
    } finally {
      if (!isDisposed) {
        setLoading(false);
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    if (isDisposed) return;

    try {
      clearError();
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null && !isDisposed) {
        await BackgroundService.saveBackground(image.path);
        onSuccess?.call('Background updated successfully!');
      }
    } catch (e) {
      if (!isDisposed) {
        final errorMsg = 'Failed to pick image: $e';
        setError(errorMsg);
        onError?.call(errorMsg);
      }
    }
  }

  Future<void> pickImageFromCamera() async {
    if (isDisposed) return;

    try {
      clearError();
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null && !isDisposed) {
        await BackgroundService.saveBackground(image.path);
        onSuccess?.call('Background updated successfully!');
      }
    } catch (e) {
      if (!isDisposed) {
        final errorMsg = 'Failed to take photo: $e';
        setError(errorMsg);
        onError?.call(errorMsg);
      }
    }
  }

  Future<void> removeBackground() async {
    if (isDisposed) return;

    try {
      clearError();
      await BackgroundService.removeBackground();
      onSuccess?.call('Background removed successfully!');
    } catch (e) {
      if (!isDisposed) {
        final errorMsg = 'Failed to remove background: $e';
        setError(errorMsg);
        onError?.call(errorMsg);
      }
    }
  }

  @override
  void dispose() {
    _backgroundSubscription?.cancel();
    _backgroundSubscription = null;
    onSuccess = null;
    onError = null;
    super.dispose();
  }
}
