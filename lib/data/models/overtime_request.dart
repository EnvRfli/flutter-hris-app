import 'package:flutter/material.dart';

enum OvertimeStatus {
  pending,
  approved,
  rejected,
  cancelled,
}

class OvertimeRequest {
  final String id;
  final String userId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String reason;
  final OvertimeStatus status;
  final DateTime requestDate;
  final String? approverNote;
  final DateTime? approvedDate;

  OvertimeRequest({
    required this.id,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reason,
    required this.status,
    required this.requestDate,
    this.approverNote,
    this.approvedDate,
  });

  // Calculate overtime duration
  Duration get duration {
    final start = Duration(hours: startTime.hour, minutes: startTime.minute);
    final end = Duration(hours: endTime.hour, minutes: endTime.minute);
    return end - start;
  }

  String get durationString {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  // Format time
  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get startTimeString => formatTime(startTime);
  String get endTimeString => formatTime(endTime);

  // Get status label in Indonesian
  String get statusLabel {
    switch (status) {
      case OvertimeStatus.pending:
        return 'Menunggu';
      case OvertimeStatus.approved:
        return 'Disetujui';
      case OvertimeStatus.rejected:
        return 'Ditolak';
      case OvertimeStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}
