import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/font_clock_widget.dart';
import '../widgets/background_wrapper.dart';

class FontClockScreen extends StatefulWidget {
  const FontClockScreen({Key? key}) : super(key: key);

  @override
  _FontClockScreenState createState() => _FontClockScreenState();
}

class _FontClockScreenState extends State<FontClockScreen>
    with AutomaticKeepAliveClientMixin<FontClockScreen> {
  String _hours = '00';
  String _minutes = '00';
  String _seconds = '00';
  Timer? _timer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Clock with background container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.green.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: FontClockWidget(
                hours: _hours,
                minutes: _minutes,
                seconds: _seconds,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
