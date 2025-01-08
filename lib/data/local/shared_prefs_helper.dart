import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const _userId = 'loggedInUserId';

  // Save the user ID
  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userId, userId);
  }

  // Retrieve the user ID
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userId);
  }

  // Clear the user ID
  Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userId);
  }
}
