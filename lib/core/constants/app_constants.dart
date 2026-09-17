import 'dart:math';

/// Global application-level configuration constants.
class AppConstants {
  AppConstants._();

  /// Primary administrator and portfolio owner email address.
  /// Used for Cloud Firestore write authentication and admin portal authorization.
  static const String adminEmail = 'suhail7.dev@gmail.com';

  static String? _imagePath;

  static String get profilePic {
    if (_imagePath != null) return _imagePath!;

    final random = Random();
    int number = random.nextInt(3) + 1;
    String imagePath = 'assets/images/profile_$number.jpeg';
    _imagePath = imagePath;
    return imagePath;
  }

  static void resetProfilePic() {
    _imagePath = null;
  }
}
