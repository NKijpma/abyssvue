import 'package:flutter/material.dart';

// pages
import '../pages/settings.dart';
import '../shell.dart';

ThemeData buildTheme(
  Brightness brightness,
  Color seedColor, {
  DynamicSchemeVariant variant = DynamicSchemeVariant.tonalSpot,
}) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
    dynamicSchemeVariant: variant,
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
      backgroundColor: colorScheme.surfaceContainer.withValues(alpha: 0.98),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      dividerColor: colorScheme.onSurfaceVariant,
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
class ThemeConfig {
  final Color seedColor;
  final DynamicSchemeVariant variant;

  const ThemeConfig(
    this.seedColor, {
    this.variant = DynamicSchemeVariant.tonalSpot,
  });
}

const Map<AppThemes, ThemeConfig> themeConfigs = {
  AppThemes.nineAnime: ThemeConfig(Color(0xFF5a2e98)),

  AppThemes.grayscale: ThemeConfig(
    Color(0xFF333333),
    variant: DynamicSchemeVariant.neutral,
  ),

  AppThemes.vampiric: ThemeConfig(
    Color(0xFFd53c6a),
    variant: DynamicSchemeVariant.vibrant,
  ),

  // grabs color from users wallpaper to style the app(still needs to be made)
  AppThemes.dynamic: ThemeConfig(Color(0xFFd53c6a)),
};

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeToggle,
      builder: (context, isDark, _) {
        return ValueListenableBuilder<AppThemes>(
          valueListenable: themeState,
          builder: (context, currentTheme, _) {
            final theme =
                themeConfigs[currentTheme] ??
                const ThemeConfig(Color(0xFF5a2e98));
            final brightness = isDark ? Brightness.dark : Brightness.light;

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: buildTheme(
                brightness,
                theme.seedColor,
                variant: theme.variant,
              ),
              home: const MainShell(),
            );
          },
        );
      },
    );
  }
}
