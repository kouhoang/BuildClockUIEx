class ClockData {
  final String hours;
  final String minutes;
  final String seconds;
  final DateTime dateTime;

  ClockData({
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.dateTime,
  });

  factory ClockData.fromDateTime(DateTime dateTime) {
    return ClockData(
      hours: dateTime.hour.toString().padLeft(2, '0'),
      minutes: dateTime.minute.toString().padLeft(2, '0'),
      seconds: dateTime.second.toString().padLeft(2, '0'),
      dateTime: dateTime,
    );
  }

  ClockData copyWith({
    String? hours,
    String? minutes,
    String? seconds,
    DateTime? dateTime,
  }) {
    return ClockData(
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
