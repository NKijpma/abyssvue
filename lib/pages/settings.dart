import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<bool> vibrationState = ValueNotifier(true);

enum AppThemes { light, dark, grayscale, vampire, dynamic }

final ValueNotifier<AppThemes> themeState = ValueNotifier(AppThemes.dark);

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

  Future<void> saveTheme(AppThemes theme) async {
    themeState.value = theme;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('app_theme', theme.name);
  }

  Future<void> loadSavedTheme() async {
    final preferences = await SharedPreferences.getInstance();
    final savedTheme = preferences.getString('app_theme');
    if (savedTheme != null) {
      themeState.value = AppThemes.values.byName(savedTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text("Settings"),
      ),

      body: ListView(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: vibrationState,
            builder: (context, vibration, _) => SwitchListTile(
              title: const Text("Vibration"),
              secondary: Icon(
                vibration ? LucideIcons.vibrate : LucideIcons.vibrateOff,
              ),
              value: vibration,
              onChanged: (newValue) =>
                  _saveSettings('vibration', vibrationState, newValue),
            ),
          ),

          ValueListenableBuilder<AppThemes>(
            valueListenable: themeState,
            builder: (context, currentTheme, _) {
              return ListTile(
                leading: const Icon(LucideIcons.palette),
                title: const Text("App Theme"),
                trailing: DropdownButton<AppThemes>(
                  value: currentTheme,
                  underline: const SizedBox(),
                  onChanged: (newTheme) {
                    if (newTheme != null) {
                      saveTheme(newTheme);
                    }
                  },
                  items: AppThemes.values.map((theme) {
                    return DropdownMenuItem(
                      value: theme,
                      child: Text(
                        theme.name[0].toUpperCase() + theme.name.substring(1),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
