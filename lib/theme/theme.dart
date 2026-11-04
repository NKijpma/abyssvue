import 'package:flutter/material.dart';

import '../pages/settings.dart';
import '../shell.dart';

ThemeData buildTheme(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF5a2e98),
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Agave',
    colorScheme: colorScheme,
    splashFactory: InkSparkle.splashFactory,
    splashColor: colorScheme.onSecondary.withValues(alpha: 0.5),
    highlightColor: colorScheme.onSecondary.withValues(alpha: 0.1),

    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.surfaceContainer.withValues(alpha: 0.3),
      foregroundColor: colorScheme.onPrimaryContainer,
    ),

    searchViewTheme: SearchViewThemeData(
      constraints: const BoxConstraints(
        minWidth: 0,
        minHeight: 0,
        maxHeight: 400,
      ),
      backgroundColor: colorScheme.surfaceContainer.withValues(alpha: 0.8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      dividerColor: colorScheme.onPrimaryContainer,
    ),

    navigationBarTheme: NavigationBarThemeData(
      height: 58,
      backgroundColor: colorScheme.surfaceContainer,
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

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeState,
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const MainShell(),
        );
      },
    );
  }
}
