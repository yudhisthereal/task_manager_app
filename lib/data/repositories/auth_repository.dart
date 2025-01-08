

import '../local/database_helper.dart';

class AuthRepository {
  final dbHelper = DatabaseHelper();

  // Register a new user
  Future<int> registerUser(String email, String password) async {
    final db = await dbHelper.database;
    return await db.insert('users', {
      'email': email,
      'password': password,
    });
  }

  // Login an existing user
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await dbHelper.database;
    final result = await db.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    return result.isNotEmpty ? result.first : null;
  }

  // Reset user password
  Future<bool> resetPassword(String email, String newPassword) async {
    final db = await dbHelper.database;
    int count = await db.update('users', {'password': newPassword},
        where: 'email = ?', whereArgs: [email]);
    return count > 0;
  }
}
