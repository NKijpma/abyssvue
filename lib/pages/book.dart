import 'package:flutter/material.dart';

class ReadPage extends StatelessWidget {
  const ReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            childAspectRatio: 0.48,
          ),

          children: [
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,

              child: Padding(
                padding: const EdgeInsets.all(5),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: Image.asset(
                          "assets/images/placeholder.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Text(
                      "bookie pookie",
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "booki write",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
