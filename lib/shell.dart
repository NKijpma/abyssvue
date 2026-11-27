import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons_200.dart';
import 'package:lucide_icons_flutter/lucide_icons_300.dart';

// Pages
import 'pages/book.dart';
import 'pages/music.dart';
import 'pages/settings.dart';
import 'pages/video.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 1;
  bool _isNavigatingFromTap = false;
  bool _isNavigating = false;

  // gear animations
  double _turns = 0.0;

  // extra features
  int _logoTapCount = 0;
  bool _developerMode = false;

  bool bars = true;

  List<Widget> get _pages => [
    MusicPage(onHideBars: _hideBars, onShowBars: _showBars),
    const ReadPage(),
    const VideoPage(),
  ];
  final PageController _controller = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (!_isNavigatingFromTap) {
      setState(() => _selectedIndex = index);
    }
  }

  Future<void> _onTapped(int index) async {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
      _isNavigatingFromTap = true;
    });
    await _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
    if (!mounted) return;
    _isNavigatingFromTap = false;
  }

  void _hideBars() {
    if (_isNavigatingFromTap) return;
    setState(() {
      bars = false;
    });
  }

  void _showBars() {
    setState(() {
      bars = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 4),
        child: AnimatedSlide(
          offset: bars ? Offset.zero : const Offset(0, -1.3),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(13, 3, 13, 3),

            child: ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(23)),

              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 13, sigmaY: 9),

                child: AppBar(
                  // add easter egg if player click logo x amount of times
                  leading: InkWell(
                    borderRadius: BorderRadius.circular(46),
                    onTap: () {
                      if (hapticToggle.value) {
                        HapticFeedback.vibrate();
                      }
                      _logoTapCount++;

                      if (_logoTapCount >= 5) {
                        _logoTapCount = 0;
                        _developerMode = !_developerMode;

                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                _developerMode
                                    ? "Developer mode on"
                                    : "Developer mode off",
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                      }
                    },

                    child: Center(
                      child: SizedBox(
                        width: 36,
                        child: SvgPicture.asset(
                          "assets/logo/logo.svg",
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onPrimaryContainer,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),

                  title: SearchAnchor.bar(
                    isFullScreen: false,
                    barLeading: const Icon(LucideIcons200.textSearch),
                    barHintText: "Search..",
                    barElevation: const WidgetStatePropertyAll(0),
                    constraints: const BoxConstraints(
                      minWidth: 0,
                      maxHeight: 40,
                      minHeight: 40,
                    ),

                    barShape: const WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(23)),
                      ),
                    ),
                    suggestionsBuilder: (context, controller) => const [],
                  ),

                  actions: [
                    AnimatedRotation(
                      turns: _turns,
                      duration: const Duration(milliseconds: 188),
                      curve: Curves.easeOutBack,
                      child: IconButton(
                        icon: const Icon(LucideIcons200.settings),
                        onPressed: () async {
                          if (hapticToggle.value) {
                            HapticFeedback.vibrate();
                          }

                          if (_isNavigating) return;
                          _isNavigating = true;
                          setState(() => _turns += 0.5);

                          await Future.delayed(
                            const Duration(milliseconds: 190),
                          );

                          if (!context.mounted) {
                            _isNavigating = false;
                            return;
                          }
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                          _isNavigating = false;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: AnimatedSlide(
        offset: bars ? Offset.zero : const Offset(0, 1.3),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            13,
            3,
            13,
            3 + MediaQuery.viewPaddingOf(context).bottom,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 13, sigmaY: 9),

              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: NavigationBar(
                  animationDuration: const Duration(milliseconds: 333),
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onTapped,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(LucideIcons200.headphones),
                      selectedIcon: Icon(LucideIcons300.headphones),
                      label: "Listen",
                    ),

                    NavigationDestination(
                      icon: Icon(LucideIcons200.bookBookmark),
                      selectedIcon: Icon(LucideIcons300.bookBookmark),
                      label: "Read",
                    ),

                    NavigationDestination(
                      icon: Icon(LucideIcons200.video),
                      selectedIcon: Icon(LucideIcons300.video),
                      label: "Watch",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0 &&
              notification.direction != ScrollDirection.idle) {
            _showBars();
          }
          return false;
        },

        child: PageView(
          controller: _controller,
          onPageChanged: _onPageChanged,
          children: _pages,
        ),
      ),
    );
  }
}
