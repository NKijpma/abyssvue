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
final ThemeData lightTheme = buildTheme(Brightness.light, Color(0xFFa5d167));
final ThemeData darkTheme = buildTheme(Brightness.dark, Color(0xFF5a2e98));
final ThemeData grayScale = buildTheme(Brightness.dark, Color(0xFF555555));
final ThemeData vampireTheme = buildTheme(Brightness.dark, Color(0xFFd53c6a));
final ThemeData dynamicTheme = buildTheme(Brightness.dark, Color(0xFFd53c6a));

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeState,
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const MainShell(),
        );
      },
    );
  }
}
