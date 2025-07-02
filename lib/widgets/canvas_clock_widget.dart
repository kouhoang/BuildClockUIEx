import 'package:flutter/material.dart';
import 'clock_painter.dart';

class CanvasClockWidget extends StatelessWidget {
  final String hours;
  final String minutes;
  final String seconds;
  final bool showColon;

  const CanvasClockWidget({
    Key? key,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.showColon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(320, 80),
        painter: ClockPainter(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          showColon: showColon,
        ),
      ),
    );
  }
}
