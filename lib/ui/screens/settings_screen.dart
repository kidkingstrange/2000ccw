import 'package:flutter/material.dart';
import '../../services/game_storage.dart';
import '../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GameStorage();

    return Scaffold(
      backgroundColor: ToonTheme.canvasBackground,
      appBar: AppBar(
        title: const Text(
          'SETTINGS',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.5),
        ),
      ),
      body: ListenableBuilder(
        listenable: storage,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Audio & Feedback section
              Container(
                decoration: ToonTheme.cardDecoration(radius: 18),
                child: Column(
                  children: [
                    SwitchListTile(
                      thumbColor: WidgetStateProperty.all(ToonTheme.slimeGreen),
                      activeTrackColor: ToonTheme.mintSolvedBg,
                      title: const Text(
                        'Sound Effects',
                        style: TextStyle(color: ToonTheme.textMain, fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      subtitle: const Text(
                        'Chimes and celebrations on solved words',
                        style: TextStyle(color: ToonTheme.textMuted, fontSize: 12),
                      ),
                      value: storage.soundEnabled,
                      onChanged: (_) => storage.toggleSound(),
                    ),
                    const Divider(height: 1, color: ToonTheme.cardBorder),
                    SwitchListTile(
                      thumbColor: WidgetStateProperty.all(ToonTheme.slimeGreen),
                      activeTrackColor: ToonTheme.mintSolvedBg,
                      title: const Text(
                        'Tactile Haptics',
                        style: TextStyle(color: ToonTheme.textMain, fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      subtitle: const Text(
                        'Vibration feedback on typing and word locks',
                        style: TextStyle(color: ToonTheme.textMuted, fontSize: 12),
                      ),
                      value: storage.hapticsEnabled,
                      onChanged: (_) => storage.toggleHaptics(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Privacy & Offline Shield Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: ToonTheme.cardDecoration(radius: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ToonTheme.slimeGreen.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.shield_rounded, color: ToonTheme.slimeGreen, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '100% OFFLINE & ZERO DATA',
                          style: TextStyle(
                            color: ToonTheme.slimeGreen,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'This app requests ZERO network permissions in AndroidManifest.xml. No ads, no tracking SDKs, no external analytics, no user accounts, no telemetry. Your game state and coins never leave this device.',
                      style: TextStyle(color: ToonTheme.textSecondary, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Legal Fan Trivia Disclaimer
              Container(
                padding: const EdgeInsets.all(18),
                decoration: ToonTheme.cardDecoration(radius: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'LEGAL DISCLAIMER',
                      style: TextStyle(
                        color: ToonTheme.electricCyan,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Unofficial fan trivia game. Not affiliated with or endorsed by Cartoon Network, Nickelodeon, Disney, Warner Bros., KidsCo, JimJam, or any rights holder. All titles, character names, and registered trademarks belong to their respective owners.',
                      style: TextStyle(
                        color: ToonTheme.textMuted,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Reset Progress Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: ToonTheme.errorRed,
                  side: BorderSide(color: ToonTheme.errorRed.withValues(alpha: 0.4), width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text(
                  'Reset All Progress & Coins',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: ToonTheme.surfaceCard,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: const Text(
                        'Reset Game Progress?',
                        style: TextStyle(color: ToonTheme.textMain, fontWeight: FontWeight.w800),
                      ),
                      content: const Text(
                        'This will permanently reset all solved levels, unlocked trophies, and restore starter coin balance to 100.',
                        style: TextStyle(color: ToonTheme.textSecondary, fontSize: 14, height: 1.35),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancel', style: TextStyle(color: ToonTheme.textMuted)),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ToonTheme.errorRed,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Reset Everything', style: TextStyle(fontWeight: FontWeight.w700)),
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
