import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import '../widgets/font_clock_widget.dart';
import '../services/background_service.dart';

class BackgroundSelectorScreen extends StatefulWidget {
  const BackgroundSelectorScreen({Key? key}) : super(key: key);

  @override
  _BackgroundSelectorScreenState createState() =>
      _BackgroundSelectorScreenState();
}

class _BackgroundSelectorScreenState extends State<BackgroundSelectorScreen>
    with AutomaticKeepAliveClientMixin<BackgroundSelectorScreen> {
  String? _backgroundImagePath;
  final ImagePicker _picker = ImagePicker();
  Timer? _timer;
  String _hours = '00';
  String _minutes = '00';
  String _seconds = '00';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load current background
    _backgroundImagePath = BackgroundService.currentBackgroundPath;

    // Listen to background changes
    BackgroundService.backgroundStream.listen((newBackgroundPath) {
      if (mounted) {
        setState(() {
          _backgroundImagePath = newBackgroundPath;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateTime();
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          _updateTime();
        } else {
          timer.cancel();
        }
      });
    }
  }

  void _updateTime() {
    if (!mounted) return;

    final now = DateTime.now();
    final newHours = now.hour.toString().padLeft(2, '0');
    final newMinutes = now.minute.toString().padLeft(2, '0');
    final newSeconds = now.second.toString().padLeft(2, '0');

    if (mounted) {
      setState(() {
        _hours = newHours;
        _minutes = newMinutes;
        _seconds = newSeconds;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        // Sử dụng BackgroundService để save và notify
        await BackgroundService.saveBackground(image.path);
        _showSuccessSnackBar('Background updated successfully!');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        // Sử dụng BackgroundService để save và notify
        await BackgroundService.saveBackground(image.path);
        _showSuccessSnackBar('Background updated successfully!');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to take photo: $e');
    }
  }

  Future<void> _removeBackground() async {
    try {
      // Use BackgroundService to remove and notify
      await BackgroundService.removeBackground();
      _showSuccessSnackBar('Background removed successfully!');
    } catch (e) {
      _showErrorSnackBar('Failed to remove background: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Select Image Source',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text(
                  'Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text(
                  'Camera',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        decoration: _backgroundImagePath != null
            ? BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(_backgroundImagePath!)),
                  fit: BoxFit.cover,
                ),
              )
            : const BoxDecoration(color: Colors.black),
        child: Container(
          decoration: BoxDecoration(
            color: _backgroundImagePath != null
                ? Colors.black.withOpacity(0.3)
                : Colors.transparent,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Custom Background',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose your own background image',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: FontClockWidget(
                          hours: _hours,
                          minutes: _minutes,
                          seconds: _seconds,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Live Preview - Background applies to all tabs',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                          shadows: const [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showImageSourceDialog,
                        icon: const Icon(Icons.wallpaper, color: Colors.white),
                        label: Text(
                          _backgroundImagePath != null
                              ? 'Change Background'
                              : 'Select Background',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    if (_backgroundImagePath != null) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _removeBackground,
                          icon: const Icon(Icons.clear, color: Colors.white),
                          label: const Text(
                            'Remove Background',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    Text(
                      _backgroundImagePath != null
                          ? 'Background is applied to all tabs instantly'
                          : 'Select an image from gallery or take a photo',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
