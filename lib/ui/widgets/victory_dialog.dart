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
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: ToonTheme.cardDecoration(
          radius: 24,
          shadowOffset: 8,
          blurRadius: 24,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fanfare Emblem
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x30D97706),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              'PUZZLE SOLVED!',
              style: TextStyle(
                color: ToonTheme.textMain,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            // Stars Row
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
            const SizedBox(height: 12),

            // Coins Reward Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: ToonTheme.pillDecoration(color: ToonTheme.amberGold),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.monetization_on_rounded, color: ToonTheme.amberGold, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '+$coinsEarned COINS EARNED',
                    style: const TextStyle(
                      color: ToonTheme.amberGold,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Trivia Archive Lore Card
            if (triviaFact != null && triviaFact!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ToonTheme.surfaceCardLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ToonTheme.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome_rounded, color: ToonTheme.electricCyan, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'UNLOCKED ARCHIVE: $title',
                            style: const TextStyle(
                              color: ToonTheme.electricCyan,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"$triviaFact"',
                      style: const TextStyle(
                        color: ToonTheme.textSecondary,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        height: 1.35,
                      ),
                    ),
                    if (sources.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Verified Sources: ${sources.length} citations',
                        style: const TextStyle(
                          color: ToonTheme.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
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
                        side: const BorderSide(color: ToonTheme.cardBorder),
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
                          color: ToonTheme.textSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onNextLevel();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF059669), Color(0xFF10B981)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x30059669),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'NEXT LEVEL',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
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
