import 'package:flutter/material.dart';

class FontClockWidget extends StatelessWidget {
  final String hours;
  final String minutes;
  final String seconds;

  const FontClockWidget({
    Key? key,
    required this.hours,
    required this.minutes,
    required this.seconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDigitWithBackground(hours),
          _buildColonWithBackground(),
          _buildDigitWithBackground(minutes),
          _buildColonWithBackground(),
          _buildDigitWithBackground(seconds),
        ],
      ),
    );
  }

  Widget _buildDigitWithBackground(String text) {
    return Stack(
      children: [
        const Text(
          '88',
          style: TextStyle(
            fontFamily: 'e1234',
            fontSize: 50,
            color: Color.fromRGBO(220, 219, 219, 0.2),
            fontWeight: FontWeight.normal,
            letterSpacing: 0,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'e1234',
            fontSize: 50,
            color: Color(0xFF00FF00),
            fontWeight: FontWeight.normal,
            letterSpacing: 0,
            shadows: [
              Shadow(
                color: Color(0x4D00FF00),
                blurRadius: 4,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColonWithBackground() {
    return Stack(
      children: [
        const Text(
          ':',
          style: TextStyle(
            fontFamily: 'e1234',
            fontSize: 50,
            color: Color.fromRGBO(80, 80, 80, 0.3),
            fontWeight: FontWeight.normal,
          ),
        ),
        const Text(
          ':',
          style: TextStyle(
            fontFamily: 'e1234',
            fontSize: 50,
            color: Color(0xFF00FF00),
            fontWeight: FontWeight.normal,
            shadows: [
              Shadow(
                color: Color(0xFF00FF00),
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
