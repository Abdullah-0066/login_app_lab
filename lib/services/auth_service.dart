// ===============================================================
// AUTH SERVICE — the "security guard" of our app
//
// AUTHENTICATION = "Who are you?"        -> login()
// AUTHORIZATION  = "What can you do?"    -> isAdmin / hasRole()
//
// NOTE: This is a FAKE service for learning.
// Real apps check passwords on a server (Firebase / your own API).
// ===============================================================

class User {
  final String name;
  final String email;
  final String role; // 'admin' or 'user'

  User({required this.name, required this.email, required this.role});
}

class AuthService {
  // The logged-in user. null means nobody is logged in.
  static User? currentUser;

  // Our fake "database" of users.
  static final Map<String, Map<String, String>> _users = {
    'admin@test.com': {'name': 'Abdullah (Admin)', 'password': '1234', 'role': 'admin'},
    'abdullah@test.com': {'name': 'Abdullah', 'password': '1234', 'role': 'user'},
  };

  // ---------------- AUTHENTICATION ----------------
  // Checks email + password. Returns true if correct.
  static Future<bool> login(String email, String password) async {
    // Pretend we are waiting for a server.
    await Future.delayed(const Duration(seconds: 1));

    final data = _users[email];
    if (data != null && data['password'] == password) {
      currentUser = User(name: data['name']!, email: email, role: data['role']!);
      return true;
    }
    return false;
  }

  static bool get isLoggedIn => currentUser != null;

  static void logout() {
    currentUser = null;
  }

  // ---------------- AUTHORIZATION ----------------
  // Checks what the logged-in user is allowed to do.
  static bool hasRole(String role) => currentUser?.role == role;

  static bool get isAdmin => hasRole('admin');
}
