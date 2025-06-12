import 'package:flutter/material.dart';
import 'dart:io';
import '../services/background_service.dart';

class BackgroundWrapper extends StatefulWidget {
  final Widget child;
  final bool showOverlay;

  const BackgroundWrapper({
    Key? key,
    required this.child,
    this.showOverlay = true,
  }) : super(key: key);

  @override
  _BackgroundWrapperState createState() => _BackgroundWrapperState();
}

class _BackgroundWrapperState extends State<BackgroundWrapper> {
  String? _backgroundPath;

  @override
  void initState() {
    super.initState();
    // Load current background
    _backgroundPath = BackgroundService.currentBackgroundPath;

    // Listen to background changes
    BackgroundService.backgroundStream.listen((newBackgroundPath) {
      if (mounted) {
        setState(() {
          _backgroundPath = newBackgroundPath;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _backgroundPath != null
          ? BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(_backgroundPath!)),
                fit: BoxFit.cover,
              ),
            )
          : const BoxDecoration(color: Colors.black),
      child: widget.showOverlay && _backgroundPath != null
          ? Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: widget.child,
            )
          : widget.child,
    );
  }
}
