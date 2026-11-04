import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// pages
import 'pages/settings.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  themeState.value = preferences.getBool('dark_theme') ?? true;
  vibrationState.value = preferences.getBool('vibration') ?? true;

  runApp(const Home());
}
