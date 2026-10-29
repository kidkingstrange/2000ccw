import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

class VictoryDialog extends StatelessWidget {
  final String title;
  final String network;
  final int coinsEarned;
  final int stars;
  final String? triviaFact;
  final List<String> sources;
  final VoidCallback onNextLevel;
  final VoidCallback? onViewTrophy;

  const VictoryDialog({
    super.key,
    required this.title,
    required this.network,
    required this.coinsEarned,
    this.stars = 3,
    this.triviaFact,
    this.sources = const [],
    required this.onNextLevel,
    this.onViewTrophy,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String network,
    required int coinsEarned,
    int stars = 3,
    String? triviaFact,
    List<String> sources = const [],
    required VoidCallback onNextLevel,
    VoidCallback? onViewTrophy,
  }) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => VictoryDialog(
        title: title,
        network: network,
        coinsEarned: coinsEarned,
        stars: stars,
        triviaFact: triviaFact,
        sources: sources,
        onNextLevel: onNextLevel,
        onViewTrophy: onViewTrophy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: ToonTheme.retroBox(
          background: ToonTheme.surfaceCard,
          borderColor: ToonTheme.slimeGreen,
          borderWidth: 3,
          radius: 24,
          shadowOffset: 6,
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fanfare badge
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 6),
            const Text(
              'PUZZLE SOLVED!',
              style: TextStyle(
                color: ToonTheme.slimeGreen,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Icon(
                  i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: Colors.amber,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: ToonTheme.cheerfulOrange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ToonTheme.cheerfulOrange, width: 1.5),
              ),
              child: Text(
                '+$coinsEarned COINS EARNED',
                style: const TextStyle(
                  color: ToonTheme.cheerfulOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Trivia Lore Card if unlocked
            if (triviaFact != null && triviaFact!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: ToonTheme.retroBox(
                  background: const Color(0xFF161628),
                  borderColor: ToonTheme.electricCyan,
                  borderWidth: 1.5,
                  radius: 14,
                  shadowOffset: 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'UNLOCKED TROPHY: $title',
                            style: const TextStyle(
                              color: ToonTheme.electricCyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"$triviaFact"',
                      style: const TextStyle(
                        color: ToonTheme.parchmentMilk,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        height: 1.3,
                      ),
                    ),
                    if (sources.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Verified Sources: ${sources.length} citations',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],

            // Action Buttons
            Row(
              children: [
                if (onViewTrophy != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ToonTheme.electricCyan, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onViewTrophy!();
                      },
                      child: const Text(
                        'Trophy Hall',
                        style: TextStyle(
                          color: ToonTheme.electricCyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ToonTheme.slimeGreen,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      onNextLevel();
                    },
                    child: const Text(
                      'NEXT LEVEL ➡️',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
