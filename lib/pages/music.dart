import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

final AudioPlayer player = AudioPlayer();

class Song {
  final String title;
  final String path;

  const Song({required this.title, required this.path});
}

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Song>> _songsFuture;
  String? _currentPath;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _songsFuture = _loadSongsFromAssets();
  }

  Future<List<Song>> _loadSongsFromAssets() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    return manifest
        .listAssets()
        .where(
          (path) => path.startsWith('assets/audio/') && path.endsWith('.mp3'),
        )
        .map((path) {
          final filename = Uri.decodeComponent(path.split('/').last);
          final title = filename.substring(0, filename.lastIndexOf('.'));
          return Song(title: title, path: path);
        })
        .toList();
  }

  Future<void> _playSong(String path) async {
    if (_currentPath == path) {
      player.playing ? await player.pause() : await player.play();
      return;
    }

    setState(() => _currentPath = path);
    await player.setAsset(path);
    await player.play();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder<List<Song>>(
        future: _songsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final songs = snapshot.data ?? [];

          if (songs.isEmpty) {
            return const Center(
              child: Text("No audio files found in assets/audio/"),
            );
          }

          return StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, playerSnapshot) {
              final isPlaying = playerSnapshot.data?.playing ?? false;

              return ListView.builder(
                padding: const EdgeInsets.only(top: 12, bottom: 90),
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final isCurrent = _currentPath == song.path;

                  return ListTile(
                    leading: Icon(
                      isCurrent && isPlaying
                          ? LucideIcons.pause
                          : LucideIcons.play,
                      size: 36,
                    ),
                    title: Text(song.title),
                    onTap: () => _playSong(song.path),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
