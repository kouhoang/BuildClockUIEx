import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/canvas_clock_widget.dart';
import '../widgets/background_wrapper.dart';

class CanvasClockScreen extends StatefulWidget {
  const CanvasClockScreen({Key? key}) : super(key: key);

  @override
  _CanvasClockScreenState createState() => _CanvasClockScreenState();
}

class _CanvasClockScreenState extends State<CanvasClockScreen>
    with AutomaticKeepAliveClientMixin<CanvasClockScreen> {
  String _hours = '00';
  String _minutes = '00';
  String _seconds = '00';
  bool _showColon = true;
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
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (mounted) {
          _updateTime();
          setState(() {
            _showColon = !_showColon;
          });
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
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
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
              child: CanvasClockWidget(
                hours: _hours,
                minutes: _minutes,
                seconds: _seconds,
                showColon: _showColon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
