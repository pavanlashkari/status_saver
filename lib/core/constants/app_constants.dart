class AppConstants {
  static const String appName = 'Status Saver';

  // WhatsApp status directories
  static const List<String> whatsappStatusPaths = [
    '/storage/emulated/0/WhatsApp/Media/.Statuses',
    '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses',
    '/storage/emulated/0/WhatsApp Business/Media/.Statuses',
    '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses',
  ];

  // Save directory
  static const String saveDirectory = 'StatusSaver';
  static const String savePath = '/storage/emulated/0/Pictures/StatusSaver';

  // Supported extensions
  static const List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> videoExtensions = ['mp4', 'mkv', 'avi', '3gp'];

  // UI
  static const int gridCrossAxisCount = 3;
  static const double gridSpacing = 2.0;

  // SharedPreferences keys
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyDarkMode = 'dark_mode';
  static const String keyStatusAlerts = 'status_alerts';
}
