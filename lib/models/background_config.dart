class BackgroundConfig {
  final String? imagePath;
  final bool hasBackground;

  BackgroundConfig({this.imagePath}) : hasBackground = imagePath != null;

  BackgroundConfig copyWith({String? imagePath, bool clearBackground = false}) {
    return BackgroundConfig(
      imagePath: clearBackground ? null : (imagePath ?? this.imagePath),
    );
  }
}
