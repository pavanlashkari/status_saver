import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/permission_service.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_page.dart';

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
                      OnboardingPage(
                        icon: Icons.download_rounded,
                        title: 'Welcome',
                        subtitle: 'Save WhatsApp statuses before they disappear. Images and videos, all in one place.',
                        buttonText: 'Get Started',
                        onPressed: () => context.read<OnboardingBloc>().add(OnboardingNextPressed()),
                      ),
                      OnboardingPage(
                        icon: Icons.folder_open_rounded,
                        title: 'Permission Required',
                        subtitle: 'We need storage access to find and save WhatsApp statuses on your device.',
                        buttonText: 'Allow Access',
                        onPressed: () => context.read<OnboardingBloc>().add(OnboardingPermissionRequested()),
                      ),
                      OnboardingPage(
                        icon: Icons.check_circle_outline_rounded,
                        title: 'All Set!',
                        subtitle: 'You\'re ready to start saving statuses. Enjoy!',
                        buttonText: 'Start Saving',
                        onPressed: () => context.read<OnboardingBloc>().add(OnboardingCompleted()),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
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
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline.withAlpha(76),
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
}
