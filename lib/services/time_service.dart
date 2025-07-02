import 'dart:async';
import '../models/clock_data.dart';

class TimeService {
  static final TimeService _instance = TimeService._internal();
  factory TimeService() => _instance;
  TimeService._internal();

  Timer? _timer;
  final StreamController<ClockData> _timeController =
      StreamController<ClockData>.broadcast();
  bool _isDisposed = false;

  Stream<ClockData> get timeStream => _timeController.stream;

  void startTimer() {
    if (_isDisposed) return;

    _timer?.cancel();
    _updateTime(); // Update immediately
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isDisposed) {
        _updateTime();
      }
    });
  }

  void _updateTime() {
    if (_isDisposed || _timeController.isClosed) return;

    final now = DateTime.now();
    final clockData = ClockData.fromDateTime(now);
    _timeController.add(clockData);
  }

  ClockData getCurrentTime() {
    return ClockData.fromDateTime(DateTime.now());
  }

  ClockData getTimeForOffset(int offsetHours) {
    final utcTime = DateTime.now().toUtc();
    final adjustedTime = utcTime.add(Duration(hours: offsetHours));
    return ClockData.fromDateTime(adjustedTime);
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    if (!_timeController.isClosed) {
      _timeController.close();
    }
  }
}
