import 'package:flutter/material.dart';
import '../models/work_schedule.dart';

class ScheduleRepository {
  // Fake schedule data generator
  Future<List<WorkSchedule>> getUserSchedule(String userId,
      {int days = 30}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final schedules = <WorkSchedule>[];
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = now.add(Duration(days: i));
      final isWeekend =
          date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

      schedules.add(
        WorkSchedule(
          id: 'schedule_${userId}_$i',
          userId: userId,
          date: date,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
          breakStart: const TimeOfDay(hour: 12, minute: 0),
          breakEnd: const TimeOfDay(hour: 13, minute: 0),
          location: 'Office - Jakarta',
          isWorkDay: !isWeekend,
        ),
      );
    }

    return schedules;
  }

  Future<WorkSchedule?> getTodaySchedule(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final today = DateTime.now();
    final isWeekend =
        today.weekday == DateTime.saturday || today.weekday == DateTime.sunday;

    if (isWeekend) {
      return null; // No schedule on weekend
    }

    return WorkSchedule(
      id: 'schedule_${userId}_today',
      userId: userId,
      date: today,
      startTime: const TimeOfDay(hour: 8, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 0),
      breakStart: const TimeOfDay(hour: 12, minute: 0),
      breakEnd: const TimeOfDay(hour: 13, minute: 0),
      location: 'Office - Jakarta',
      isWorkDay: true,
    );
  }

  Future<WorkSchedule?> getScheduleByDate(String userId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

    return WorkSchedule(
      id: 'schedule_${userId}_${date.toIso8601String()}',
      userId: userId,
      date: date,
      startTime: const TimeOfDay(hour: 8, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 0),
      breakStart: const TimeOfDay(hour: 12, minute: 0),
      breakEnd: const TimeOfDay(hour: 13, minute: 0),
      location: 'Office - Jakarta',
      isWorkDay: !isWeekend,
    );
  }
}
