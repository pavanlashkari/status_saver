import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart' show Share;
import 'package:url_launcher/url_launcher.dart';
import '../bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle dark theme'),
                value: state.darkMode,
                onChanged: (_) {
                  context.read<SettingsBloc>().add(SettingsDarkModeToggled());
                },
              ),
              SwitchListTile(
                title: const Text('Status Alerts'),
                subtitle: const Text('Get notified of new statuses'),
                value: state.statusAlerts,
                onChanged: (_) {
                  context.read<SettingsBloc>().add(SettingsAlertsToggled());
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Rate App'),
                onTap: () {
                  // TODO: Replace with actual Play Store URL
                  launchUrl(Uri.parse('https://play.google.com/store'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share App'),
                onTap: () {
                  Share.share('Check out Status Saver! Download it from the Play Store.');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
