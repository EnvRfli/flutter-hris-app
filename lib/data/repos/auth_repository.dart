import '../models/user.dart';

class AuthRepository {
  // Fake user database
  final Map<String, Map<String, String>> _users = {
    'user@example.com': {
      'password': 'password123',
      'id': '1',
      'name': 'John Doe',
      'position': 'Software Engineer',
      'department': 'Engineering',
    },
  };

  User? _currentUser;

  Future<User> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final userData = _users[email];
    if (userData == null || userData['password'] != password) {
      throw Exception('Invalid email or password');
    }

    _currentUser = User(
      id: userData['id']!,
      name: userData['name']!,
      email: email,
      position: userData['position']!,
      department: userData['department']!,
    );

    return _currentUser!;
  }

  Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
  }

  User? getCurrentUser() {
    return _currentUser;
  }

  bool isLoggedIn() {
    return _currentUser != null;
  }
}
