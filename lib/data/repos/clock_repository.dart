import '../models/clock_record.dart';

class ClockRepository {
  final List<ClockRecord> _records = [
    // Dummy data for testing
    ClockRecord(
      id: '1',
      userId: '1',
      clockInTime: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      clockOutTime: DateTime.now().subtract(const Duration(days: 1, hours: 0)),
      clockInLocation: 'Office - Jakarta',
      clockOutLocation: 'Office - Jakarta',
      status: 'completed',
    ),
    ClockRecord(
      id: '2',
      userId: '1',
      clockInTime: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
      clockOutTime: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      clockInLocation: 'Office - Jakarta',
      clockOutLocation: 'Office - Jakarta',
      status: 'completed',
    ),
    ClockRecord(
      id: '3',
      userId: '1',
      clockInTime: DateTime.now().subtract(const Duration(days: 3, hours: 8)),
      clockOutTime: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
      clockInLocation: 'Office - Jakarta',
      clockOutLocation: 'Office - Jakarta',
      status: 'completed',
    ),
  ];

  ClockRecord? _todayRecord;

  Future<List<ClockRecord>> getClockHistory(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return _records.where((record) => record.userId == userId).toList()
      ..sort((a, b) => b.clockInTime.compareTo(a.clockInTime));
  }

  Future<ClockRecord?> getTodayRecord(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (_todayRecord != null &&
        _isSameDay(_todayRecord!.clockInTime, DateTime.now())) {
      return _todayRecord;
    }

    return null;
  }

  Future<ClockRecord> clockIn(String userId, String location) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final record = ClockRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      clockInTime: DateTime.now(),
      clockInLocation: location,
      status: 'pending',
    );

    _todayRecord = record;
    _records.insert(0, record);

    return record;
  }

  Future<ClockRecord> clockOut(String recordId, String location) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (_todayRecord == null) {
      throw Exception('No active clock-in record found');
    }

    final updatedRecord = _todayRecord!.copyWith(
      clockOutTime: DateTime.now(),
      clockOutLocation: location,
      status: 'completed',
    );

    _todayRecord = updatedRecord;

    // Update in list
    final index = _records.indexWhere((r) => r.id == recordId);
    if (index != -1) {
      _records[index] = updatedRecord;
    }

    return updatedRecord;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
