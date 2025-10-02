import 'package:flutter/foundation.dart';
import '../../data/models/clock_record.dart';
import '../../data/repos/clock_repository.dart';

enum ClockState { initial, loading, loaded, error }

class ClockProvider extends ChangeNotifier {
  final ClockRepository _clockRepository;

  ClockState _state = ClockState.initial;
  ClockRecord? _todayRecord;
  List<ClockRecord> _history = [];
  String? _errorMessage;

  ClockProvider(this._clockRepository);

  ClockState get state => _state;
  ClockRecord? get todayRecord => _todayRecord;
  List<ClockRecord> get history => _history;
  String? get errorMessage => _errorMessage;

  bool get hasClockedInToday => _todayRecord != null;
  bool get hasClockedOutToday =>
      _todayRecord != null && _todayRecord!.clockOutTime != null;

  Future<void> loadTodayRecord(String userId) async {
    try {
      _state = ClockState.loading;
      notifyListeners();

      _todayRecord = await _clockRepository.getTodayRecord(userId);
      _state = ClockState.loaded;
      notifyListeners();
    } catch (e) {
      _state = ClockState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadHistory(String userId) async {
    try {
      _state = ClockState.loading;
      notifyListeners();

      _history = await _clockRepository.getClockHistory(userId);
      _state = ClockState.loaded;
      notifyListeners();
    } catch (e) {
      _state = ClockState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> clockIn(String userId, String location) async {
    try {
      _state = ClockState.loading;
      _errorMessage = null;
      notifyListeners();

      _todayRecord = await _clockRepository.clockIn(userId, location);
      _state = ClockState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ClockState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> clockOut(String recordId, String location) async {
    try {
      _state = ClockState.loading;
      _errorMessage = null;
      notifyListeners();

      _todayRecord = await _clockRepository.clockOut(recordId, location);
      _state = ClockState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ClockState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
