class ClockRecord {
  final String id;
  final String userId;
  final DateTime clockInTime;
  final DateTime? clockOutTime;
  final String? clockInLocation;
  final String? clockOutLocation;
  final String status; // 'pending', 'completed'

  ClockRecord({
    required this.id,
    required this.userId,
    required this.clockInTime,
    this.clockOutTime,
    this.clockInLocation,
    this.clockOutLocation,
    required this.status,
  });

  factory ClockRecord.fromJson(Map<String, dynamic> json) {
    return ClockRecord(
      id: json['id'] as String,
      userId: json['userId'] as String,
      clockInTime: DateTime.parse(json['clockInTime'] as String),
      clockOutTime: json['clockOutTime'] != null
          ? DateTime.parse(json['clockOutTime'] as String)
          : null,
      clockInLocation: json['clockInLocation'] as String?,
      clockOutLocation: json['clockOutLocation'] as String?,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'clockInTime': clockInTime.toIso8601String(),
      'clockOutTime': clockOutTime?.toIso8601String(),
      'clockInLocation': clockInLocation,
      'clockOutLocation': clockOutLocation,
      'status': status,
    };
  }

  ClockRecord copyWith({
    String? id,
    String? userId,
    DateTime? clockInTime,
    DateTime? clockOutTime,
    String? clockInLocation,
    String? clockOutLocation,
    String? status,
  }) {
    return ClockRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clockInTime: clockInTime ?? this.clockInTime,
      clockOutTime: clockOutTime ?? this.clockOutTime,
      clockInLocation: clockInLocation ?? this.clockInLocation,
      clockOutLocation: clockOutLocation ?? this.clockOutLocation,
      status: status ?? this.status,
    );
  }

  Duration? get workDuration {
    if (clockOutTime == null) return null;
    return clockOutTime!.difference(clockInTime);
  }

  String get workDurationString {
    final duration = workDuration;
    if (duration == null) return '-';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
