import 'package:flutter/material.dart';

import '../pages/settings.dart';
import '../shell.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF5a2e98),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Agave',
        colorScheme: darkScheme,
        splashFactory: InkSparkle.splashFactory,
        splashColor: darkScheme.onSecondary.withValues(alpha: 0.5),
        highlightColor: darkScheme.onSecondary.withValues(alpha: 0.1),

        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: darkScheme.surfaceContainer.withValues(alpha: 0.3),
          foregroundColor: darkScheme.onPrimaryContainer,
        ),

        searchViewTheme: SearchViewThemeData(
          constraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxHeight: 400,
          ),
          backgroundColor: darkScheme.surfaceContainer.withValues(alpha: 0.8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23),
          ),
          dividerColor: darkScheme.onPrimaryContainer,
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          enableFeedback: vibrationState.value,
          backgroundColor: darkScheme.surfaceContainer,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: darkScheme.primary,
          unselectedItemColor: darkScheme.onSurface,
        ),
      ),
      home: const MainShell(),
    );
  }
}
