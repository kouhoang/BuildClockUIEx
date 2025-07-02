import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ClockPainter extends CustomPainter {
  final String hours;
  final String minutes;
  final String seconds;
  final bool showColon;

  ClockPainter({
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.showColon,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (hours.length != 2 || minutes.length != 2 || seconds.length != 2) {
      return;
    }

    double digitWidth = 35;
    double colonWidth = 15;
    double spacing = 8;

    double totalWidth = (digitWidth * 6) + (colonWidth * 2) + (spacing * 4);
    double startX = (size.width - totalWidth) / 2;
    double centerY = size.height / 2;

    try {
      // Draw hours
      _drawDigit(canvas, hours[0], Offset(startX, centerY));
      _drawDigit(
        canvas,
        hours[1],
        Offset(startX + digitWidth + spacing, centerY),
      );

      // Draw first colon
      _drawColon(
        canvas,
        Offset(startX + (digitWidth + spacing) * 2, centerY),
        showColon,
      );

      // Draw minutes
      _drawDigit(
        canvas,
        minutes[0],
        Offset(
          startX + (digitWidth + spacing) * 2 + colonWidth + spacing,
          centerY,
        ),
      );
      _drawDigit(
        canvas,
        minutes[1],
        Offset(
          startX + (digitWidth + spacing) * 3 + colonWidth + spacing,
          centerY,
        ),
      );

      // Draw second colon
      _drawColon(
        canvas,
        Offset(
          startX + (digitWidth + spacing) * 4 + colonWidth + spacing,
          centerY,
        ),
        showColon,
      );

      // Draw seconds
      _drawDigit(
        canvas,
        seconds[0],
        Offset(
          startX + (digitWidth + spacing) * 4 + (colonWidth + spacing) * 2,
          centerY,
        ),
      );
      _drawDigit(
        canvas,
        seconds[1],
        Offset(
          startX + (digitWidth + spacing) * 5 + (colonWidth + spacing) * 2,
          centerY,
        ),
      );
    } catch (e) {
      // If have error, draw placeholder
      debugPrint('ClockPainter error: $e');
    }
  }

  void _drawDigit(Canvas canvas, String digit, Offset position) {
    _drawSevenSegment(canvas, '8', position, Color.fromRGBO(80, 80, 80, 0.3));
    _drawSevenSegment(canvas, digit, position, Color(0xFF00FF00));
  }

  void _drawSevenSegment(
    Canvas canvas,
    String digit,
    Offset position,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Map<String, List<bool>> segments = {
      '0': [true, true, true, true, true, true, false],
      '1': [false, true, true, false, false, false, false],
      '2': [true, true, false, true, true, false, true],
      '3': [true, true, true, true, false, false, true],
      '4': [false, true, true, false, false, true, true],
      '5': [true, false, true, true, false, true, true],
      '6': [true, false, true, true, true, true, true],
      '7': [true, true, true, false, false, false, false],
      '8': [true, true, true, true, true, true, true],
      '9': [true, true, true, true, false, true, true],
    };

    List<bool> activeSegments =
        segments[digit] ?? [false, false, false, false, false, false, false];

    double segmentLength = 18;
    double segmentThickness = 3;

    // Draw segments safely
    try {
      if (activeSegments[0]) {
        _drawHorizontalSegment(
          canvas,
          paint,
          Offset(position.dx + 4, position.dy - 22),
          segmentLength,
          segmentThickness,
        );
      }
      if (activeSegments[1]) {
        _drawVerticalSegment(
          canvas,
          paint,
          Offset(position.dx + 22, position.dy - 18),
          segmentLength,
          segmentThickness,
        );
      }
      if (activeSegments[2]) {
        _drawVerticalSegment(
          canvas,
          paint,
          Offset(position.dx + 22, position.dy + 4),
          segmentLength,
          segmentThickness,
        );
      }
      if (activeSegments[3]) {
        _drawHorizontalSegment(
          canvas,
          paint,
          Offset(position.dx + 4, position.dy + 22),
          segmentLength,
          segmentThickness,
        );
      }
      if (activeSegments[4]) {
        _drawVerticalSegment(
          canvas,
          paint,
          Offset(position.dx, position.dy + 4),
          segmentLength,
          segmentThickness,
        );
      }
      if (activeSegments[5]) {
        _drawVerticalSegment(
          canvas,
          paint,
          Offset(position.dx, position.dy - 18),
          segmentLength,
          segmentThickness,
        );
      }
      if (activeSegments[6]) {
        _drawHorizontalSegment(
          canvas,
          paint,
          Offset(position.dx + 4, position.dy),
          segmentLength,
          segmentThickness,
        );
      }

      // Add glow effect for active segments
      if (color == Color(0xFF00FF00)) {
        final glowPaint = Paint()
          ..color = Color(0xFF00FF00).withValues(alpha: 0.2)
          ..style = PaintingStyle.fill
          ..maskFilter = ui.MaskFilter.blur(BlurStyle.normal, 2);

        for (int i = 0; i < activeSegments.length; i++) {
          if (activeSegments[i]) {
            _drawSegmentWithGlow(
              canvas,
              glowPaint,
              position,
              i,
              segmentLength,
              segmentThickness,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Segment drawing error: $e');
    }
  }

  void _drawSegmentWithGlow(
    Canvas canvas,
    Paint glowPaint,
    Offset position,
    int segmentIndex,
    double segmentLength,
    double segmentThickness,
  ) {
    switch (segmentIndex) {
      case 0:
        _drawHorizontalSegment(
          canvas,
          glowPaint,
          Offset(position.dx + 4, position.dy - 22),
          segmentLength,
          segmentThickness,
        );
        break;
      case 1:
        _drawVerticalSegment(
          canvas,
          glowPaint,
          Offset(position.dx + 22, position.dy - 18),
          segmentLength,
          segmentThickness,
        );
        break;
      case 2:
        _drawVerticalSegment(
          canvas,
          glowPaint,
          Offset(position.dx + 22, position.dy + 4),
          segmentLength,
          segmentThickness,
        );
        break;
      case 3:
        _drawHorizontalSegment(
          canvas,
          glowPaint,
          Offset(position.dx + 4, position.dy + 22),
          segmentLength,
          segmentThickness,
        );
        break;
      case 4:
        _drawVerticalSegment(
          canvas,
          glowPaint,
          Offset(position.dx, position.dy + 4),
          segmentLength,
          segmentThickness,
        );
        break;
      case 5:
        _drawVerticalSegment(
          canvas,
          glowPaint,
          Offset(position.dx, position.dy - 18),
          segmentLength,
          segmentThickness,
        );
        break;
      case 6:
        _drawHorizontalSegment(
          canvas,
          glowPaint,
          Offset(position.dx + 4, position.dy),
          segmentLength,
          segmentThickness,
        );
        break;
    }
  }

  void _drawHorizontalSegment(
    Canvas canvas,
    Paint paint,
    Offset position,
    double length,
    double thickness,
  ) {
    Path path = Path();
    path.moveTo(position.dx, position.dy);
    path.lineTo(position.dx + thickness, position.dy - thickness);
    path.lineTo(position.dx + length - thickness, position.dy - thickness);
    path.lineTo(position.dx + length, position.dy);
    path.lineTo(position.dx + length - thickness, position.dy + thickness);
    path.lineTo(position.dx + thickness, position.dy + thickness);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawVerticalSegment(
    Canvas canvas,
    Paint paint,
    Offset position,
    double length,
    double thickness,
  ) {
    Path path = Path();
    path.moveTo(position.dx, position.dy);
    path.lineTo(position.dx + thickness, position.dy + thickness);
    path.lineTo(position.dx + thickness, position.dy + length - thickness);
    path.lineTo(position.dx, position.dy + length);
    path.lineTo(position.dx - thickness, position.dy + length - thickness);
    path.lineTo(position.dx - thickness, position.dy + thickness);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawColon(Canvas canvas, Offset position, bool isActive) {
    final backgroundPaint = Paint()
      ..color = Color.fromRGBO(80, 80, 80, 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(position.dx, position.dy - 8), 2, backgroundPaint);
    canvas.drawCircle(Offset(position.dx, position.dy + 8), 2, backgroundPaint);

    if (isActive) {
      final activePaint = Paint()
        ..color = Color(0xFF00FF00)
        ..style = PaintingStyle.fill;

      final glowPaint = Paint()
        ..color = Color(0xFF00FF00).withValues(alpha: 0.2)
        ..style = PaintingStyle.fill
        ..maskFilter = ui.MaskFilter.blur(BlurStyle.normal, 1.5);

      canvas.drawCircle(Offset(position.dx, position.dy - 8), 2, glowPaint);
      canvas.drawCircle(Offset(position.dx, position.dy + 8), 2, glowPaint);
      canvas.drawCircle(Offset(position.dx, position.dy - 8), 2, activePaint);
      canvas.drawCircle(Offset(position.dx, position.dy + 8), 2, activePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is ClockPainter) {
      return oldDelegate.hours != hours ||
          oldDelegate.minutes != minutes ||
          oldDelegate.seconds != seconds ||
          oldDelegate.showColon != showColon;
    }
    return true;
  }
}
