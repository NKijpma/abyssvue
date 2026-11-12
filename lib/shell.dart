import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

  final List<Widget> _pages = const [MusicPage(), ReadPage(), VideoPage()];
  final PageController _controller = PageController(initialPage: 1);

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

  Future<void> _onTabTapped(int index) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 4),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 2, 18, 2),
          child: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(23),
              ),
            ),

            // add easter egg if player click logo x amount of times
            leading: Center(
              child: Image.asset(
                "assets/logo/logo_transparent.png",
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),

            title: SearchAnchor.bar(
              isFullScreen: false,
              barLeading: const Icon(LucideIcons.textSearch),
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
              IconButton(
                icon: const Icon(LucideIcons.settings),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          4 + MediaQuery.viewPaddingOf(context).bottom,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: NavigationBar(
              animationDuration: const Duration(milliseconds: 300),
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onTabTapped,
              destinations: const [
                NavigationDestination(
                  icon: Icon(LucideIcons.headphones),
                  label: "Listen",
                ),
                NavigationDestination(
                  icon: Icon(LucideIcons.bookBookmark),
                  label: "Read",
                ),
                NavigationDestination(
                  icon: Icon(LucideIcons.video),
                  label: "Watch",
                ),
              ],
            ),
          ),
        ),
      ),

      body: PageView(
        controller: _controller,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
    );
  }
}
