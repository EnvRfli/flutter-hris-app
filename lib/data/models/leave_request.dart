enum LeaveType {
  annual, // Cuti Tahunan
  sick, // Cuti Sakit
  permission, // Izin
  unpaid, // Cuti Tanpa Gaji
  maternity, // Cuti Melahirkan
  paternity, // Cuti Ayah
  marriage, // Cuti Menikah
  bereavement, // Cuti Duka
}

enum LeaveStatus {
  pending, // Menunggu Persetujuan
  approved, // Disetujui
  rejected, // Ditolak
  cancelled, // Dibatalkan
}

class LeaveRequest {
  final String id;
  final String userId;
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final LeaveStatus status;
  final DateTime requestDate;
  final String? approverNote;
  final DateTime? approvedDate;
  final List<String>? attachments; // For sick leave documents

  LeaveRequest({
    required this.id,
    required this.userId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.requestDate,
    this.approverNote,
    this.approvedDate,
    this.attachments,
  });

  // Calculate duration in days
  int get durationDays {
    return endDate.difference(startDate).inDays + 1;
  }

  // Get leave type label in Indonesian
  String get typeLabel {
    switch (type) {
      case LeaveType.annual:
        return 'Cuti Tahunan';
      case LeaveType.sick:
        return 'Cuti Sakit';
      case LeaveType.permission:
        return 'Izin';
      case LeaveType.unpaid:
        return 'Cuti Tanpa Gaji';
      case LeaveType.maternity:
        return 'Cuti Melahirkan';
      case LeaveType.paternity:
        return 'Cuti Ayah';
      case LeaveType.marriage:
        return 'Cuti Menikah';
      case LeaveType.bereavement:
        return 'Cuti Duka';
    }
  }

  // Get status label in Indonesian
  String get statusLabel {
    switch (status) {
      case LeaveStatus.pending:
        return 'Menunggu';
      case LeaveStatus.approved:
        return 'Disetujui';
      case LeaveStatus.rejected:
        return 'Ditolak';
      case LeaveStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  // Get status color code
  String get statusColorCode {
    switch (status) {
      case LeaveStatus.pending:
        return 'warning';
      case LeaveStatus.approved:
        return 'success';
      case LeaveStatus.rejected:
        return 'error';
      case LeaveStatus.cancelled:
        return 'neutral';
    }
  }
}
