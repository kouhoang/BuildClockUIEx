import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SimpleClock(), debugShowCheckedModeBanner: false);
  }
}

class SimpleClock extends StatefulWidget {
  @override
  _SimpleClockState createState() => _SimpleClockState();
}

class _SimpleClockState extends State<SimpleClock> {
  String _hours = '';
  String _minutes = '';
  String _seconds = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _hours = now.hour.toString().padLeft(2, '0');
      _minutes = now.minute.toString().padLeft(2, '0');
      _seconds = now.second.toString().padLeft(2, '0');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDigitWithBackground(_hours),
            _buildColonWithBackground(),
            _buildDigitWithBackground(_minutes),
            _buildColonWithBackground(),
            _buildDigitWithBackground(_seconds),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitWithBackground(String text) {
    return Stack(
      children: [
        Text(
          '88',
          style: TextStyle(
            fontFamily: 'e1234',
            fontSize: 40,
            color: Color.fromRGBO(220, 219, 219, 0.2),
            fontWeight: FontWeight.normal,
            letterSpacing: 0,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'e1234',
            fontSize: 40,
            color: Color(0xFF00FF00),
            fontWeight: FontWeight.normal,
            letterSpacing: 0,
            shadows: [
              Shadow(
                color: Color(0xFF00FF00).withOpacity(0.3),
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
        Text(
          ':',
          style: TextStyle(
            fontFamily: 'e1234',
            fontSize: 40,
            color: Color.fromRGBO(0, 0, 0, 0.2),
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            fontFamily: 'e1234',
            fontSize: 40,
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
