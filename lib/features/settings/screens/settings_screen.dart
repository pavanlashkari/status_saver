import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart' show Share;
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mint = theme.primaryColor;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                // Header
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),

                // Dark Mode
                _SettingsCard(
                  isDark: isDark,
                  children: [
                    _SettingsTile(
                      icon: Icons.dark_mode_rounded,
                      iconColor: const Color(0xFF7C6FEE),
                      iconBg: const Color(0xFF7C6FEE).withAlpha(25),
                      title: 'Dark Mode',
                      subtitle: state.darkMode ? 'On' : 'Off',
                      trailing: Switch(
                        value: state.darkMode,
                        activeColor: mint,
                        activeTrackColor: mint.withAlpha(80),
                        inactiveThumbColor: isDark ? AppColors.textMuted : Colors.grey[400],
                        inactiveTrackColor: isDark ? AppColors.surface : Colors.grey[300],
                        onChanged: (_) {
                          context.read<SettingsBloc>().add(SettingsDarkModeToggled());
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Notifications
                _SettingsCard(
                  isDark: isDark,
                  children: [
                    _SettingsTile(
                      icon: Icons.notifications_rounded,
                      iconColor: const Color(0xFFF5A623),
                      iconBg: const Color(0xFFF5A623).withAlpha(25),
                      title: 'Notifications',
                      subtitle: state.statusAlerts ? 'Enabled' : 'Disabled',
                      trailing: Switch(
                        value: state.statusAlerts,
                        activeColor: mint,
                        activeTrackColor: mint.withAlpha(80),
                        inactiveThumbColor: isDark ? AppColors.textMuted : Colors.grey[400],
                        inactiveTrackColor: isDark ? AppColors.surface : Colors.grey[300],
                        onChanged: (_) {
                          context.read<SettingsBloc>().add(SettingsAlertsToggled());
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Rate & Share
                _SettingsCard(
                  isDark: isDark,
                  children: [
                    _SettingsTile(
                      icon: Icons.star_rounded,
                      iconColor: const Color(0xFFFFB800),
                      iconBg: const Color(0xFFFFB800).withAlpha(25),
                      title: 'Rate App',
                      subtitle: 'Love it? Rate us on Play Store',
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: isDark ? AppColors.textMuted : AppColors.lightTextSecondary,
                      ),
                      onTap: () {
                        launchUrl(Uri.parse('https://play.google.com/store'));
                      },
                    ),
                    Divider(
                      height: 1,
                      indent: 60,
                      color: isDark ? AppColors.cardBorder : Colors.grey.shade200,
                    ),
                    _SettingsTile(
                      icon: Icons.share_rounded,
                      iconColor: const Color(0xFF4A9BF5),
                      iconBg: const Color(0xFF4A9BF5).withAlpha(25),
                      title: 'Share App',
                      subtitle: 'Tell your friends about us',
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: isDark ? AppColors.textMuted : AppColors.lightTextSecondary,
                      ),
                      onTap: () {
                        Share.share('Check out Status Saver! Download from Play Store.');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Version
                Center(
                  child: Text(
                    'Status Saver v${AppConstants.appVersion}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _SettingsCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.cardBorder : Colors.grey.shade200,
          width: 0.5,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
