import 'dart:async';
import '../models/clock_data.dart';
import '../services/time_service.dart';
import 'base_view_model.dart';

class FontClockViewModel extends BaseViewModel {
  final TimeService _timeService = TimeService();
  StreamSubscription<ClockData>? _timeSubscription;

  ClockData _clockData = ClockData.fromDateTime(DateTime.now());
  ClockData get clockData => _clockData;

  void initialize() {
    if (isDisposed) return;

    _timeService.startTimer();
    _timeSubscription = _timeService.timeStream.listen((clockData) {
      if (isDisposed) return;
      _clockData = clockData;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timeSubscription?.cancel();
    _timeSubscription = null;
    super.dispose();
  }
}
