import 'package:flutter/material.dart';

final ValueNotifier<bool> vibrationState = ValueNotifier(true);
final ValueNotifier<bool> themeState = ValueNotifier(true);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: vibrationState,
            builder: (context, value, _) => SwitchListTile(
              title: const Text("Vibration"),
              value: value,
              onChanged: (newValue) => vibrationState.value = newValue,
            ),
          ),
        ],
      ),
    );
  }
}
