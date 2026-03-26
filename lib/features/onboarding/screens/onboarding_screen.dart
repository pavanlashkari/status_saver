import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/onboarding_bloc.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(permissionService: PermissionService()),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mint = theme.primaryColor;

    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingDone) {
            context.go('/home');
            return;
          }
          _animateToPage(state.page);
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Page 1: How to use
                      _buildHowToUsePage(context, theme, isDark, mint),
                      // Page 2: Permission
                      _buildPermissionPage(context, theme, isDark, mint),
                      // Page 3: Done
                      _buildDonePage(context, theme, isDark, mint),
                    ],
                  ),
                ),
                // Dots
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: state.page == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: state.page == index
                              ? mint
                              : (isDark ? AppColors.textMuted : Colors.grey[300]),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHowToUsePage(BuildContext context, ThemeData theme, bool isDark, Color mint) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: mint.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.download_rounded, size: 42, color: mint),
          ),
          const SizedBox(height: 20),
          Text(
            'How to use',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Follow these simple steps',
            style: TextStyle(fontSize: 13, color: theme.colorScheme.outline),
          ),
          const SizedBox(height: 28),
          _StepCard(
            number: '1',
            title: 'Open WhatsApp',
            desc: 'View the statuses you want to save',
            icon: Icons.message_rounded,
            color: const Color(0xFF25D366),
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _StepCard(
            number: '2',
            title: 'View Statuses',
            desc: 'Watch or view the photos and videos',
            icon: Icons.visibility_rounded,
            color: const Color(0xFF4A9BF5),
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _StepCard(
            number: '3',
            title: 'Come Back Here',
            desc: 'Open Status Saver to find viewed statuses',
            icon: Icons.refresh_rounded,
            color: const Color(0xFFF5A623),
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _StepCard(
            number: '4',
            title: 'Save & Share',
            desc: 'Tap on any status to save or share it',
            icon: Icons.save_alt_rounded,
            color: mint,
            isDark: isDark,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: mint,
                foregroundColor: isDark ? AppColors.background : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                context.read<OnboardingBloc>().add(OnboardingNextPressed());
              },
              child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPermissionPage(BuildContext context, ThemeData theme, bool isDark, Color mint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: mint.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.folder_open_rounded, size: 50, color: mint),
          ),
          const SizedBox(height: 28),
          Text(
            'Access Required',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'We need storage access to find and save\nWhatsApp statuses on your device.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.outline,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 36),
          // Grant Permission button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: mint,
                foregroundColor: isDark ? AppColors.background : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                context.read<OnboardingBloc>().add(OnboardingPermissionRequested());
              },
              icon: const Icon(Icons.folder_open_rounded, size: 20),
              label: const Text('Grant Permission', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 12),
          // Maybe Later
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.outline,
                side: BorderSide(
                  color: isDark ? AppColors.cardBorder : Colors.grey.shade300,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {},
              child: const Text('Maybe Later', style: TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded, size: 14, color: theme.colorScheme.outline),
              const SizedBox(width: 6),
              Text(
                'Your data stays on your device',
                style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonePage(BuildContext context, ThemeData theme, bool isDark, Color mint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: mint.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_rounded, size: 50, color: mint),
          ),
          const SizedBox(height: 28),
          Text(
            'All Set!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You\'re ready to start saving statuses.\nEnjoy using Status Saver!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.outline,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: mint,
                foregroundColor: isDark ? AppColors.background : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                context.read<OnboardingBloc>().add(OnboardingCompleted());
              },
              child: const Text('Start Saving', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StepCard({
    required this.number,
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.cardBorder : Colors.grey.shade200,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step $number: $title',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
