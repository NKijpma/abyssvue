import 'package:flutter/material.dart';

class ReadPage extends StatelessWidget {
  const ReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Image.asset(
                "assets/images/placeholder.png",
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "bookie pookie",
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "bookie author",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
