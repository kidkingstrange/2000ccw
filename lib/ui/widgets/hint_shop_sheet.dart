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
      isScrollControlled: true,
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
            boxShadow: [
              BoxShadow(
                color: Color(0x140F172A),
                offset: Offset(0, -6),
                blurRadius: 20,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grab handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: ToonTheme.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ToonTheme.amberGold.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.lightbulb_rounded, color: ToonTheme.amberGold, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '3-Tier Hint Shop',
                        style: TextStyle(
                          color: ToonTheme.textMain,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: ToonTheme.pillDecoration(color: ToonTheme.amberGold),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on_rounded, color: ToonTheme.amberGold, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          '$coins',
                          style: const TextStyle(
                            color: ToonTheme.amberGold,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
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
                subtitle: 'Fills the first missing letter in this $modeName',
                cost: 50,
                currentCoins: coins,
                icon: Icons.looks_one_rounded,
                accentColor: ToonTheme.electricCyan,
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
                subtitle: 'Fills an arbitrary unsolved slot in this $modeName',
                cost: 100,
                currentCoins: coins,
                icon: Icons.shuffle_rounded,
                accentColor: ToonTheme.cheerfulOrange,
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
                subtitle: 'Completely reveals and confirms this $modeName',
                cost: 250,
                currentCoins: coins,
                icon: Icons.check_circle_rounded,
                accentColor: ToonTheme.slimeGreen,
                isPremium: true,
                onTap: () {
                  if (storage.spendCoins(250)) {
                    HapticFeedback.heavyImpact();
                    Navigator.pop(context);
                    onHint3();
                  }
                },
              ),
              const SizedBox(height: 16),
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
    required Color accentColor,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    final canAfford = currentCoins >= cost;

    return Opacity(
      opacity: canAfford ? 1.0 : 0.45,
      child: Material(
        color: ToonTheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isPremium ? accentColor.withValues(alpha: 0.35) : ToonTheme.cardBorder,
            width: 1.0,
          ),
        ),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: canAfford ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
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
                          color: ToonTheme.textMain,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: ToonTheme.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: canAfford
                        ? ToonTheme.amberGold.withValues(alpha: 0.12)
                        : ToonTheme.surfaceCardLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: canAfford
                          ? ToonTheme.amberGold.withValues(alpha: 0.3)
                          : ToonTheme.cardBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.monetization_on_rounded,
                        size: 14,
                        color: canAfford ? ToonTheme.amberGold : ToonTheme.textSubtle,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$cost',
                        style: TextStyle(
                          color: canAfford ? ToonTheme.amberGold : ToonTheme.textSubtle,
                          fontWeight: FontWeight.w800,
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
