import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons_200.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemes {
  nineAnime("9 Anime"),
  grayscale("Grayscale"),
  vampiric("Vampiric"),
  dynamic("Dynamic");

  final String displayName;

  const AppThemes(this.displayName);
}

final ValueNotifier<bool> hapticToggle = ValueNotifier(true);
final ValueNotifier<bool> themeToggle = ValueNotifier(true);
final ValueNotifier<AppThemes> themeState = ValueNotifier(AppThemes.nineAnime);

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
          icon: const Icon(LucideIcons200.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text("Settings"),
      ),

      body: ListView(
        children: [
          // Toggle for haptic feedback
          ValueListenableBuilder<bool>(
            valueListenable: hapticToggle,
            builder: (context, haptic, _) => SwitchListTile(
              title: Text(haptic ? "Haptics On" : "Haptics Off"),
              secondary: Icon(
                haptic ? LucideIcons200.vibrate : LucideIcons200.vibrateOff,
              ),
              value: haptic,
              onChanged: (newValue) {
                _saveSettings('vibration', hapticToggle, newValue);
                HapticFeedback.vibrate();
              },
            ),
          ),

          // Toggle for dark and light mode
          ValueListenableBuilder<bool>(
            valueListenable: themeToggle,
            builder: (context, isDark, _) => SwitchListTile(
              title: Text(isDark ? "Dark Mode" : "Light Mode"),
              secondary: Icon(
                isDark ? LucideIcons200.moon : LucideIcons200.sun,
              ),
              value: isDark,
              onChanged: (newValue) {
                _saveSettings('theme', themeToggle, newValue);
                if (hapticToggle.value) {
                  HapticFeedback.vibrate();
                }
              },
            ),
          ),

          // List of themes
          ValueListenableBuilder<AppThemes>(
            valueListenable: themeState,
            builder: (context, currentTheme, _) {
              return ListTile(
                leading: const Icon(LucideIcons200.palette),
                title: const Text("App Theme"),
                trailing: DropdownButton<AppThemes>(
                  value: currentTheme,
                  underline: const SizedBox(),
                  onChanged: (newTheme) {
                    if (newTheme != null) {
                      if (hapticToggle.value) {
                        HapticFeedback.vibrate();
                      }
                      saveTheme(newTheme);
                    }
                  },
                  items: AppThemes.values.map((theme) {
                    return DropdownMenuItem(
                      value: theme,
                      child: Text(theme.displayName),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          // custom link for downloading / scrapping files
          // jellyfin / plex link / api

          // donate link to kofi idk
        ],
      ),
    );
  }
}
