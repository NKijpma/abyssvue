import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:video_player/video_player.dart';

class VideoItem {
  final String title;
  final String path;

  const VideoItem({required this.title, required this.path});
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late Future<List<VideoItem>> _videosFuture;
  VideoPlayerController? _controller;
  String? _currentPath;
  bool _isLoading = false;

  static const List<String> _videoExtensions = [
    '.mp4',
    '.mkv',
    '.avi',
    '.mov',
    '.webm',
    '.flv',
  ];

  @override
  void initState() {
    super.initState();
    _videosFuture = _loadVideosFromAssets();
  }

  Future<List<VideoItem>> _loadVideosFromAssets() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    return manifest
        .listAssets()
        .where(
          (path) =>
              path.startsWith('assets/videos/') &&
              _videoExtensions.any((ext) => path.toLowerCase().endsWith(ext)),
        )
        .map((path) {
          // Decode ONLY the title so it looks nice in the UI:
          final filename = Uri.decodeComponent(path.split('/').last);
          final title = filename.substring(0, filename.lastIndexOf('.'));

          // Keep path EXACTLY as Flutter bundled it in the APK!
          return VideoItem(title: title, path: path);
        })
        .toList();
  }

  Future<void> _playVideo(String path) async {
    // If tapping the current video, toggle play/pause
    if (_currentPath == path && _controller != null) {
      _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
      return;
    }

    setState(() {
      _isLoading = true;
      _currentPath = path;
    });

    try {
      // 1. Dispose old controller
      final oldController = _controller;
      _controller = null;
      await oldController?.dispose();

      // 2. Create new controller with decoded path
      final newController = VideoPlayerController.asset(path);
      await newController.initialize();

      // 3. Listen to playback updates so UI rebuilds on play/pause/progress
      newController.addListener(() {
        if (mounted) setState(() {});
      });

      await newController.play();

      if (mounted) {
        setState(() {
          _controller = newController;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error initializing video: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to play video: $e")));
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<List<VideoItem>>(
        future: _videosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final videos = snapshot.data ?? [];

          if (videos.isEmpty) {
            return const Center(
              child: Text("No videos found in assets/videos/"),
            );
          }

          return Column(
            children: [
              // 1. Video Player Area
              if (_isLoading)
                const SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_controller != null && _controller!.value.isInitialized)
                Container(
                  color: Colors.black,
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        VideoPlayer(_controller!),
                        VideoProgressIndicator(
                          _controller!,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: theme.colorScheme.primary,
                            bufferedColor: Colors.white24,
                            backgroundColor: Colors.white10,
                          ),
                        ),
                        Center(
                          child: IconButton(
                            iconSize: 56,
                            icon: Icon(
                              _controller!.value.isPlaying
                                  ? LucideIcons.pause
                                  : LucideIcons.play,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              _controller!.value.isPlaying
                                  ? _controller!.pause()
                                  : _controller!.play();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // 2. Video List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 90),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    final isCurrent = _currentPath == video.path;
                    final isPlaying =
                        isCurrent && (_controller?.value.isPlaying ?? false);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Material(
                        color: isCurrent
                            ? theme.colorScheme.primaryContainer.withValues(
                                alpha: 0.3,
                              )
                            : theme.colorScheme.surfaceContainer.withValues(
                                alpha: 0.3,
                              ),
                        borderRadius: BorderRadius.circular(16),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          leading: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            size: 36,
                            color: isCurrent
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          title: Text(
                            video.title,
                            style: TextStyle(
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          onTap: () => _playVideo(video.path),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
