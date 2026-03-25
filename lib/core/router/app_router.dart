import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/viewer/screens/viewer_screen.dart';
import '../../features/saved/screens/saved_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../core/models/status_file.dart';

class AppRouter {
  static GoRouter router(bool onboardingComplete) => GoRouter(
        initialLocation: onboardingComplete ? '/home' : '/onboarding',
        routes: [
          GoRoute(
            path: '/onboarding',
            builder: (context, state) => const OnboardingScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/viewer',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return ViewerScreen(
                statuses: extra['statuses'] as List<StatusFile>,
                initialIndex: extra['index'] as int,
              );
            },
          ),
          GoRoute(
            path: '/saved',
            builder: (context, state) => const SavedScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      );
}
