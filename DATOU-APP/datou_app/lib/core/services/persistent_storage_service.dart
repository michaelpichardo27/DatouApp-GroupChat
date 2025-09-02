import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorageService {
  static const String _rememberMeKey = 'remember_me';
  static const String _guestModeKey = 'guest_mode';
  static const String _userRoleKey = 'user_role';
  static const String _hasSkippedRoleSelectionKey = 'has_skipped_role_selection';

  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  static Future<void> setGuestMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestModeKey, value);
  }

  static Future<bool> getGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_guestModeKey) ?? false;
  }

  static Future<void> setUserRole(String? role) async {
    final prefs = await SharedPreferences.getInstance();
    if (role != null) {
      await prefs.setString(_userRoleKey, role);
    } else {
      await prefs.remove(_userRoleKey);
    }
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  static Future<void> setHasSkippedRoleSelection(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSkippedRoleSelectionKey, value);
  }

  static Future<bool> getHasSkippedRoleSelection() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSkippedRoleSelectionKey) ?? false;
  }

  static Future<void> clearAllAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_guestModeKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_hasSkippedRoleSelectionKey);
  }

  static Future<void> clearAuthDataExceptRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_guestModeKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_hasSkippedRoleSelectionKey);
  }
}
