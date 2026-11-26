import 'package:flutter/material.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:shared_preferences/shared_preferences.dart';

// pages
import 'pages/settings.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  fvp.registerWith(
    options: const {
      'platforms': ['windows', 'linux', 'macos'],
    },
  );

  final preferences = await SharedPreferences.getInstance();

  final savedThemeName = preferences.getString('app_theme');

  if (savedThemeName != null) {
    try {
      themeState.value = AppThemes.values.byName(savedThemeName);
    } catch (_) {
      themeState.value = AppThemes.nineAnime;
    }
  }

  hapticToggle.value = preferences.getBool('vibration') ?? true;
  themeToggle.value = preferences.getBool('theme') ?? true;

  runApp(const Home());
}
