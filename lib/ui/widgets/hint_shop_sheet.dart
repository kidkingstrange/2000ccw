import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/game_storage.dart';
import '../theme.dart';

class HintShopSheet extends StatelessWidget {
  final VoidCallback onHint1;
  final VoidCallback onHint2;
  final VoidCallback onHint3;
  final String modeName;

  const HintShopSheet({
    super.key,
    required this.onHint1,
    required this.onHint2,
    required this.onHint3,
    this.modeName = 'Word',
  });

  static void show(
    BuildContext context, {
    required VoidCallback onHint1,
    required VoidCallback onHint2,
    required VoidCallback onHint3,
    String modeName = 'Word',
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => HintShopSheet(
        onHint1: onHint1,
        onHint2: onHint2,
        onHint3: onHint3,
        modeName: modeName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = GameStorage();

    return ListenableBuilder(
      listenable: storage,
      builder: (context, _) {
        final coins = storage.coins;

        return Container(
          decoration: const BoxDecoration(
            color: ToonTheme.surfaceCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: ToonTheme.slimeGreen, width: 3),
              left: BorderSide(color: ToonTheme.deepSpaceBlack, width: 2),
              right: BorderSide(color: ToonTheme.deepSpaceBlack, width: 2),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lightbulb, color: ToonTheme.electricCyan, size: 28),
                      SizedBox(width: 8),
                      Text(
                        '3-TIER HINT SHOP',
                        style: TextStyle(
                          color: ToonTheme.parchmentMilk,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: ToonTheme.retroBox(
                      background: ToonTheme.surfaceCardLight,
                      radius: 20,
                      shadowOffset: 2,
                    ),
                    child: Row(
                      children: [
                        const Text('🪙', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          '$coins',
                          style: const TextStyle(
                            color: ToonTheme.slimeGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Tier 1: 50 Coins
              _buildHintTile(
                context,
                title: 'Reveal Starting Letter',
                subtitle: 'Fills the first unsolved letter in this $modeName',
                cost: 50,
                currentCoins: coins,
                icon: Icons.looks_one_rounded,
                onTap: () {
                  if (storage.spendCoins(50)) {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context);
                    onHint1();
                  }
                },
              ),
              const SizedBox(height: 12),

              // Tier 2: 100 Coins
              _buildHintTile(
                context,
                title: 'Reveal Random Letter',
                subtitle: 'Fills an arbitrary missing letter in this $modeName',
                cost: 100,
                currentCoins: coins,
                icon: Icons.shuffle_rounded,
                onTap: () {
                  if (storage.spendCoins(100)) {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context);
                    onHint2();
                  }
                },
              ),
              const SizedBox(height: 12),

              // Tier 3: 250 Coins
              _buildHintTile(
                context,
                title: 'Solve Entire $modeName',
                subtitle: 'Completely reveals and locks this $modeName',
                cost: 250,
                currentCoins: coins,
                icon: Icons.check_circle_rounded,
                isPremium: true,
                onTap: () {
                  if (storage.spendCoins(250)) {
                    HapticFeedback.heavyImpact();
                    Navigator.pop(context);
                    onHint3();
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHintTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required int cost,
    required int currentCoins,
    required IconData icon,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    final canAfford = currentCoins >= cost;

    return Opacity(
      opacity: canAfford ? 1.0 : 0.5,
      child: Material(
        color: isPremium ? const Color(0xFF2E2648) : ToonTheme.surfaceCardLight,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: canAfford ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isPremium
                      ? ToonTheme.cheerfulOrange.withValues(alpha: 0.2)
                      : ToonTheme.electricCyan.withValues(alpha: 0.15),
                  child: Icon(
                    icon,
                    color: isPremium ? ToonTheme.cheerfulOrange : ToonTheme.electricCyan,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: ToonTheme.parchmentMilk,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: canAfford ? ToonTheme.cheerfulOrange : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '$cost',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
