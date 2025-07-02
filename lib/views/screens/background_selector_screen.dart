import 'dart:io';
import 'package:build_clock/widgets/font_clock_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/background_selector_view_model.dart';
import '../../viewmodels/font_clock_view_model.dart';

class BackgroundSelectorScreen extends StatefulWidget {
  const BackgroundSelectorScreen({super.key});

  @override
  _BackgroundSelectorScreenState createState() =>
      _BackgroundSelectorScreenState();
}

class _BackgroundSelectorScreenState extends State<BackgroundSelectorScreen>
    with AutomaticKeepAliveClientMixin<BackgroundSelectorScreen> {
  // Store ScaffoldMessenger reference safely
  ScaffoldMessengerState? _scaffoldMessenger;
  BackgroundSelectorViewModel? _backgroundViewModel;
  FontClockViewModel? _clockViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely store ScaffoldMessenger reference
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    _backgroundViewModel?.dispose();
    _clockViewModel?.dispose();
    _scaffoldMessenger = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            _backgroundViewModel = BackgroundSelectorViewModel()..initialize();
            return _backgroundViewModel!;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            _clockViewModel = FontClockViewModel()..initialize();
            return _clockViewModel!;
          },
        ),
      ],
      child: Consumer2<BackgroundSelectorViewModel, FontClockViewModel>(
        builder: (context, backgroundViewModel, clockViewModel, child) {
          return Scaffold(
            body: Container(
              decoration: backgroundViewModel.backgroundConfig.hasBackground
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                          File(backgroundViewModel.backgroundConfig.imagePath!),
                        ),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const BoxDecoration(color: Colors.black),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundViewModel.backgroundConfig.hasBackground
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.transparent,
                ),
                child: Column(
                  children: [
                    // Header
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

                    // Preview Clock
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.5),
                                  width: 2,
                                ),
                              ),
                              child: FontClockWidget(
                                hours: clockViewModel.clockData.hours,
                                minutes: clockViewModel.clockData.minutes,
                                seconds: clockViewModel.clockData.seconds,
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

                    // Action Buttons
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Select/Change Background Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _showImageSourceDialog(backgroundViewModel),
                              icon: const Icon(
                                Icons.wallpaper,
                                color: Colors.white,
                              ),
                              label: Text(
                                backgroundViewModel
                                        .backgroundConfig
                                        .hasBackground
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          // Remove Background Button
                          if (backgroundViewModel
                              .backgroundConfig
                              .hasBackground) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _removeBackground(backgroundViewModel),
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 16),

                          // Status Text
                          Text(
                            backgroundViewModel.backgroundConfig.hasBackground
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
        },
      ),
    );
  }

  void _showImageSourceDialog(BackgroundSelectorViewModel viewModel) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
                onTap: () => _handleImageSelection(
                  dialogContext,
                  viewModel,
                  () => viewModel.pickImageFromGallery(),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text(
                  'Camera',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => _handleImageSelection(
                  dialogContext,
                  viewModel,
                  () => viewModel.pickImageFromCamera(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleImageSelection(
    BuildContext dialogContext,
    BackgroundSelectorViewModel viewModel,
    Future<void> Function() action,
  ) async {
    Navigator.of(dialogContext).pop();

    await action();

    if (!mounted) return;

    if (viewModel.errorMessage == null) {
      _showSuccessSnackBar('Background updated successfully!');
    } else {
      _showErrorSnackBar(viewModel.errorMessage!);
      viewModel.clearError(); // Clear error after showing
    }
  }

  void _removeBackground(BackgroundSelectorViewModel viewModel) async {
    await viewModel.removeBackground();

    if (!mounted) return;

    if (viewModel.errorMessage == null) {
      _showSuccessSnackBar('Background removed successfully!');
    } else {
      _showErrorSnackBar(viewModel.errorMessage!);
      viewModel.clearError(); // Clear error after showing
    }
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted || _scaffoldMessenger == null) return;

    _scaffoldMessenger!.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted || _scaffoldMessenger == null) return;

    _scaffoldMessenger!.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
