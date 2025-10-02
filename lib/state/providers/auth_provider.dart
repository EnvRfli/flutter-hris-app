import 'package:flutter/foundation.dart';
import '../../data/models/user.dart';
import '../../data/repos/auth_repository.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;

  AuthProvider(this._authRepository) {
    _checkAuthStatus();
  }

  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;

  void _checkAuthStatus() {
    if (_authRepository.isLoggedIn()) {
      _user = _authRepository.getCurrentUser();
      _state = AuthState.authenticated;
    } else {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _state = AuthState.loading;
      _errorMessage = null;
      notifyListeners();

      _user = await _authRepository.login(email, password);
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      _user = null;
      _state = AuthState.unauthenticated;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
