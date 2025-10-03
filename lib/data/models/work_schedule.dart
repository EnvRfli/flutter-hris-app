import 'package:flutter/material.dart';

class WorkSchedule {
  final String id;
  final String userId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TimeOfDay? breakStart;
  final TimeOfDay? breakEnd;
  final String location;
  final bool isWorkDay; // false for weekend/holiday

  WorkSchedule({
    required this.id,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.breakStart,
    this.breakEnd,
    required this.location,
    this.isWorkDay = true,
  });

  // Helper to get formatted time
  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get startTimeString => formatTime(startTime);
  String get endTimeString => formatTime(endTime);
  String get breakStartString =>
      breakStart != null ? formatTime(breakStart!) : '-';
  String get breakEndString => breakEnd != null ? formatTime(breakEnd!) : '-';

  // Calculate work duration (excluding break)
  Duration get workDuration {
    final start = Duration(hours: startTime.hour, minutes: startTime.minute);
    final end = Duration(hours: endTime.hour, minutes: endTime.minute);
    final totalDuration = end - start;

    if (breakStart != null && breakEnd != null) {
      final breakStartDuration =
          Duration(hours: breakStart!.hour, minutes: breakStart!.minute);
      final breakEndDuration =
          Duration(hours: breakEnd!.hour, minutes: breakEnd!.minute);
      final breakDuration = breakEndDuration - breakStartDuration;
      return totalDuration - breakDuration;
    }

    return totalDuration;
  }

  String get workDurationString {
    final hours = workDuration.inHours;
    final minutes = workDuration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}

// Extension to create TimeOfDay from hours and minutes
extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay fromHourMinute(int hour, int minute) {
    return TimeOfDay(hour: hour, minute: minute);
  }
}
