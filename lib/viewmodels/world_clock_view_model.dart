import 'dart:async';
import '../models/world_clock.dart';
import '../models/clock_data.dart';
import '../services/time_service.dart';
import 'base_view_model.dart';

class WorldClockViewModel extends BaseViewModel {
  final TimeService _timeService = TimeService();
  StreamSubscription<ClockData>? _timeSubscription;

  List<WorldClock> _worldClocks = [];
  List<WorldClock> get worldClocks => _worldClocks;

  final List<Map<String, dynamic>> _clockConfigs = [
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

  void initialize() {
    if (isDisposed) return;

    _initializeWorldClocks();
    _timeService.startTimer();
    _timeSubscription = _timeService.timeStream.listen((_) {
      if (isDisposed) return;
      _updateWorldClocks();
    });
  }

  void _initializeWorldClocks() {
    if (isDisposed) return;

    _worldClocks = _clockConfigs.map((config) {
      final clockData = _timeService.getTimeForOffset(config['offset']);
      return WorldClock(
        city: config['city'],
        country: config['country'],
        flag: config['flag'],
        offsetHours: config['offset'],
        clockData: clockData,
      );
    }).toList();
    notifyListeners();
  }

  void _updateWorldClocks() {
    if (isDisposed) return;

    _worldClocks = _worldClocks.map((worldClock) {
      final clockData = _timeService.getTimeForOffset(worldClock.offsetHours);
      return worldClock.copyWith(clockData: clockData);
    }).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    _timeSubscription?.cancel();
    _timeSubscription = null;
    super.dispose();
  }
}
