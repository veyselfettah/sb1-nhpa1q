class Dhikr {
  final int id;
  final String title;
  final String arabicText;
  final String meaning;
  final int target;
  final int startValue;
  final bool countUp;
  final bool vibrateNearEnd;
  final bool soundOnComplete;
  final String resetPeriod;
  final int vibrateThreshold;
  final bool vibrateOnInterval;
  final int vibrateInterval;
  final String? lastReset;
  int currentCount;

  Dhikr({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.meaning,
    required this.target,
    this.startValue = 0,
    this.countUp = true,
    this.vibrateNearEnd = true,
    this.soundOnComplete = true,
    this.resetPeriod = 'daily',
    this.vibrateThreshold = 3,
    this.vibrateOnInterval = false,
    this.vibrateInterval = 10,
    this.lastReset,
    int? currentCount,
  }) : currentCount = currentCount ?? startValue;

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    return Dhikr(
      id: json['id'],
      title: json['title'],
      arabicText: json['arabicText'],
      meaning: json['meaning'],
      target: json['target'],
      startValue: json['startValue'] ?? 0,
      countUp: json['countUp'] ?? true,
      vibrateNearEnd: json['vibrateNearEnd'] ?? true,
      soundOnComplete: json['soundOnComplete'] ?? true,
      resetPeriod: json['resetPeriod'] ?? 'daily',
      vibrateThreshold: json['vibrateThreshold'] ?? 3,
      vibrateOnInterval: json['vibrateOnInterval'] ?? false,
      vibrateInterval: json['vibrateInterval'] ?? 10,
      lastReset: json['lastReset'],
      currentCount: json['currentCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabicText': arabicText,
      'meaning': meaning,
      'target': target,
      'startValue': startValue,
      'countUp': countUp,
      'vibrateNearEnd': vibrateNearEnd,
      'soundOnComplete': soundOnComplete,
      'resetPeriod': resetPeriod,
      'vibrateThreshold': vibrateThreshold,
      'vibrateOnInterval': vibrateOnInterval,
      'vibrateInterval': vibrateInterval,
      'lastReset': lastReset,
      'currentCount': currentCount,
    };
  }

  Dhikr copyWith({
    String? title,
    String? arabicText,
    String? meaning,
    int? target,
    int? startValue,
    bool? countUp,
    bool? vibrateNearEnd,
    bool? soundOnComplete,
    String? resetPeriod,
    int? vibrateThreshold,
    bool? vibrateOnInterval,
    int? vibrateInterval,
    String? lastReset,
    int? currentCount,
  }) {
    return Dhikr(
      id: id,
      title: title ?? this.title,
      arabicText: arabicText ?? this.arabicText,
      meaning: meaning ?? this.meaning,
      target: target ?? this.target,
      startValue: startValue ?? this.startValue,
      countUp: countUp ?? this.countUp,
      vibrateNearEnd: vibrateNearEnd ?? this.vibrateNearEnd,
      soundOnComplete: soundOnComplete ?? this.soundOnComplete,
      resetPeriod: resetPeriod ?? this.resetPeriod,
      vibrateThreshold: vibrateThreshold ?? this.vibrateThreshold,
      vibrateOnInterval: vibrateOnInterval ?? this.vibrateOnInterval,
      vibrateInterval: vibrateInterval ?? this.vibrateInterval,
      lastReset: lastReset ?? this.lastReset,
      currentCount: currentCount ?? this.currentCount,
    );
  }
}