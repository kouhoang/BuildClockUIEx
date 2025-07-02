import 'dart:async';
import '../models/clock_data.dart';
import '../services/time_service.dart';
import 'base_view_model.dart';

class CanvasClockViewModel extends BaseViewModel {
  final TimeService _timeService = TimeService();
  StreamSubscription<ClockData>? _timeSubscription;
  Timer? _blinkTimer;

  ClockData _clockData = ClockData.fromDateTime(DateTime.now());
  bool _showColon = true;

  ClockData get clockData => _clockData;
  bool get showColon => _showColon;

  void initialize() {
    _timeService.startTimer();
    _timeSubscription = _timeService.timeStream.listen((clockData) {
      _clockData = clockData;
      notifyListeners();
    });

    _startBlinkTimer();
  }

  void _startBlinkTimer() {
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _showColon = !_showColon;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timeSubscription?.cancel();
    _blinkTimer?.cancel();
    super.dispose();
  }
}
