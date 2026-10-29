import 'package:flutter/material.dart';
import '../../services/game_storage.dart';
import '../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GameStorage();

    return Scaffold(
      backgroundColor: ToonTheme.deepSpaceBlack,
      appBar: AppBar(
        title: const Text('SETTINGS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListenableBuilder(
        listenable: storage,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Audio & Feedback section
              Container(
                decoration: ToonTheme.retroBox(
                  background: ToonTheme.surfaceCard,
                  borderColor: ToonTheme.deepSpaceBlack,
                  radius: 16,
                  shadowOffset: 3,
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      thumbColor: WidgetStateProperty.all(ToonTheme.slimeGreen),
                      title: const Text(
                        'Sound Effects',
                        style: TextStyle(color: ToonTheme.parchmentMilk, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'Chimes and celebration sounds on solves',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      value: storage.soundEnabled,
                      onChanged: (_) => storage.toggleSound(),
                    ),
                    const Divider(height: 1, color: Colors.white12),
                    SwitchListTile(
                      thumbColor: WidgetStateProperty.all(ToonTheme.slimeGreen),
                      title: const Text(
                        'Tactile Haptics',
                        style: TextStyle(color: ToonTheme.parchmentMilk, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'Vibration feedback on typing and word locks',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      value: storage.hapticsEnabled,
                      onChanged: (_) => storage.toggleHaptics(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Privacy & Offline Shield Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: ToonTheme.retroBox(
                  background: ToonTheme.surfaceCard,
                  borderColor: ToonTheme.slimeGreen,
                  borderWidth: 1.5,
                  radius: 16,
                  shadowOffset: 3,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.shield_rounded, color: ToonTheme.slimeGreen, size: 24),
                        SizedBox(width: 8),
                        Text(
                          '100% OFFLINE & ZERO DATA',
                          style: TextStyle(
                            color: ToonTheme.slimeGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This app requests ZERO network permissions in AndroidManifest.xml. No ads, no tracking SDKs, no external analytics, no user accounts, no telemetry. Your game state and coins never leave this device.',
                      style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Legal Fan Trivia Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: ToonTheme.retroBox(
                  background: ToonTheme.surfaceCard,
                  borderColor: Colors.black45,
                  radius: 16,
                  shadowOffset: 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'LEGAL DISCLAIMER',
                      style: TextStyle(
                        color: ToonTheme.electricCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Unofficial fan trivia game. Not affiliated with or endorsed by Cartoon Network, Nickelodeon, Disney, Warner Bros., KidsCo, JimJam, or any rights holder. All titles, character names, and registered trademarks belong to their respective owners.',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Reset Progress Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF4757),
                  side: const BorderSide(color: Color(0xFFFF4757), width: 1.8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.delete_forever_rounded),
                label: const Text('Reset All Progress & Coins', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: ToonTheme.surfaceCard,
                      title: const Text('Reset Game Progress?', style: TextStyle(color: Colors.white)),
                      content: const Text(
                        'This will permanently reset all solved levels, unlocked trophies, and restore starter coin balance to 100.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4757)),
                          child: const Text('Reset Everything', style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            storage.resetProgress();
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Game progress reset to default.')),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
