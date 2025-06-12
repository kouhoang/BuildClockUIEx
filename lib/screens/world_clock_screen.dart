import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/world_clock_item.dart';
import '../widgets/background_wrapper.dart';

class WorldClockScreen extends StatefulWidget {
  const WorldClockScreen({Key? key}) : super(key: key);

  @override
  _WorldClockScreenState createState() => _WorldClockScreenState();
}

class _WorldClockScreenState extends State<WorldClockScreen>
    with AutomaticKeepAliveClientMixin<WorldClockScreen> {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();

  final List<Map<String, dynamic>> _worldClocks = [
    {'city': 'Washington D.C.', 'country': 'USA', 'flag': '🇺🇸', 'offset': -5},
    {
      'city': 'London',
      'country': 'United Kingdom',
      'flag': '🇬🇧',
      'offset': 0,
    },
    {'city': 'Moscow', 'country': 'Russia', 'flag': '🇷🇺', 'offset': 3},
    {'city': 'Hanoi', 'country': 'Vietnam', 'flag': '🇻🇳', 'offset': 7},
    {'city': 'Sydney', 'country': 'Australia', 'flag': '🇦🇺', 'offset': 11},
  ];

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

    setState(() {
      _currentTime = DateTime.now();
    });
  }

  DateTime _getTimeForOffset(int offsetHours) {
    final utcTime = _currentTime.toUtc();
    return utcTime.add(Duration(hours: offsetHours));
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
          children: [
            // Header
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.green.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'World Clock',
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
                    'Capital Cities Around The World',
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

            // List clock
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _worldClocks.length,
                itemBuilder: (context, index) {
                  final clockData = _worldClocks[index];
                  final localTime = _getTimeForOffset(clockData['offset']);

                  return WorldClockItem(
                    city: clockData['city'],
                    country: clockData['country'],
                    flag: clockData['flag'],
                    time: localTime,
                    offset: clockData['offset'],
                  );
                },
              ),
            ),

            // Footer info with background
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.green.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
