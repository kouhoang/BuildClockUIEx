import 'package:build_clock/models/clock_data.dart';

class WorldClock {
  final String city;
  final String country;
  final String flag;
  final int offsetHours;
  final ClockData clockData;

  WorldClock({
    required this.city,
    required this.country,
    required this.flag,
    required this.offsetHours,
    required this.clockData,
  });

  WorldClock copyWith({
    String? city,
    String? country,
    String? flag,
    int? offsetHours,
    ClockData? clockData,
  }) {
    return WorldClock(
      city: city ?? this.city,
      country: country ?? this.country,
      flag: flag ?? this.flag,
      offsetHours: offsetHours ?? this.offsetHours,
      clockData: clockData ?? this.clockData,
    );
  }

  String get offsetString {
    if (offsetHours == 0) return 'UTC';
    final sign = offsetHours > 0 ? '+' : '';
    return 'UTC$sign$offsetHours';
  }
}
