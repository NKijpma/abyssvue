import 'package:flutter/material.dart';

// pages
import '../pages/settings.dart';
import '../shell.dart';

ThemeData buildTheme(Brightness brightness, Color seedColor) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Jetbrains',
    colorScheme: colorScheme,
    // maybe change splash idk yet look at wiki for splashfac types
    splashFactory: InkRipple.splashFactory,
    splashColor: colorScheme.onSecondary.withValues(alpha: 0.5),
    highlightColor: colorScheme.onSecondary.withValues(alpha: 0.1),

    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.surfaceContainer.withValues(alpha: 0.8),
      foregroundColor: colorScheme.onPrimaryContainer,
    ),

    searchViewTheme: SearchViewThemeData(
      constraints: const BoxConstraints(
        minWidth: 0,
        minHeight: 0,
        maxHeight: 400,
      ),
      backgroundColor: colorScheme.surfaceContainer.withValues(alpha: 0.9),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      dividerColor: colorScheme.onPrimaryContainer,
    ),

    navigationBarTheme: NavigationBarThemeData(
      height: 58,
      backgroundColor: colorScheme.surfaceContainer.withValues(alpha: 0.8),
      indicatorColor: colorScheme.primaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(23),
      ),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      overlayColor: WidgetStatePropertyAll(
        colorScheme.primary.withValues(alpha: 0.12),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
        ),
      ),
    ),
  );
}

// Theming
final ThemeData light = buildTheme(Brightness.light, Color(0xFFa5d167));
final ThemeData dark = buildTheme(Brightness.dark, Color(0xFF5a2e98));
final ThemeData grayScale = buildTheme(Brightness.dark, Color(0xFF555555));
final ThemeData vampire = buildTheme(Brightness.dark, Color(0xFFd53c6a));
final ThemeData dynamic = buildTheme(Brightness.dark, Color(0xFFd53c6a));

final Map<AppThemes, ThemeData> themeMap = {
  AppThemes.light: light,
  AppThemes.dark: dark,
  AppThemes.grayscale: grayScale,
  AppThemes.vampire: vampire,
  AppThemes.dynamic: dynamic,
};

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemes>(
      valueListenable: themeState,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeMap[currentTheme] ?? dark,
          home: const MainShell(),
        );
      },
    );
  }
}
