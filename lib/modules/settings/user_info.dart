// user_info.dart
class UserInfo {
  static final String currentUser = 'VoThanhHa28';
  static String getCurrentUTCTime() {
    final now = DateTime.now().toUtc();
    return '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';
  }

  static String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}