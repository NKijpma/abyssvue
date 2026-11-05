import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<bool> vibrationState = ValueNotifier(true);
final ValueNotifier<bool> themeState = ValueNotifier(true);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _saveSettings(
    String key,
    ValueNotifier<bool> notifier,
    bool value,
  ) async {
    notifier.value = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: vibrationState,
            builder: (context, vibration, _) => SwitchListTile(
              title: const Text("Vibration"),
              secondary: Icon(Icons.vibration),
              value: vibration,
              onChanged: (newValue) =>
                  _saveSettings('vibration', vibrationState, newValue),
            ),
          ),

          ValueListenableBuilder<bool>(
            valueListenable: themeState,
            builder: (context, darkMode, _) => SwitchListTile(
              title: const Text("Dark Theme"),
              secondary: Icon(
                darkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              ),
              value: darkMode,
              onChanged: (newValue) =>
                  _saveSettings('dark_theme', themeState, newValue),
            ),
          ),
        ],
      ),
    );
  }
}
