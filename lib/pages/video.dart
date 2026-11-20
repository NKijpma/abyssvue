import 'package:flutter/material.dart';

// import 'package:flutter/services.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';
// import 'package:video_player/video_player.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 16,
        ),

        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                "assets/images/placeholder.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "vidoe",
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            "market pliers",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
