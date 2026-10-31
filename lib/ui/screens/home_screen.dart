import 'package:flutter/material.dart';
import '../../services/game_storage.dart';
import '../../services/puzzle_loader.dart';
import '../theme.dart';
import 'crossword_screen.dart';
import 'level_select_screen.dart';
import 'settings_screen.dart';
import 'trophy_dex_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GameStorage();
    final loader = PuzzleLoader();

    return Scaffold(
      backgroundColor: ToonTheme.canvasBackground,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: storage,
          builder: (context, _) {
            final totalLevels = loader.manifest?.totalLevels ?? 400;
            final solvedCount = storage.solvedLevelIds.length;
            final completionPercent = totalLevels > 0 ? (solvedCount / totalLevels * 100).toInt() : 0;
            final totalStars = storage.totalStarsEarned;
            final totalTrophies = storage.unlockedDexCardIds.length;

            // Find next unsolved level for Quick Play
            int nextLevel = 1;
            for (int i = 1; i <= 200; i++) {
              final id = 'cw-${i.toString().padLeft(3, '0')}';
              if (!storage.isLevelSolved(id)) {
                nextLevel = i;
                break;
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Status Header (Streak, Coins, Settings)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Daily Streak Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: ToonTheme.pillDecoration(color: ToonTheme.cheerfulOrange),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department_rounded,
                              color: ToonTheme.cheerfulOrange,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${storage.dailyStreak} DAY STREAK',
                              style: const TextStyle(
                                color: ToonTheme.cheerfulOrange,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Coins & Settings
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: ToonTheme.pillDecoration(color: ToonTheme.amberGold),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.monetization_on_rounded,
                                  color: ToonTheme.amberGold,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${storage.coins}',
                                  style: const TextStyle(
                                    color: ToonTheme.amberGold,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: ToonTheme.surfaceCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: ToonTheme.cardBorder),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x060F172A),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.settings_outlined, color: ToonTheme.textSecondary, size: 20),
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Brand Hero Showcase Card
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: ToonTheme.cardDecoration(
                      radius: 20,
                      shadowOffset: 4,
                      blurRadius: 16,
                    ),
                    child: Column(
                      children: [
                        // Luxury Brand Emblem
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x200F172A),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.tv_rounded,
                              color: Color(0xFF38BDF8),
                              size: 34,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          '2000s TOON CROSSWORDS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ToonTheme.textMain,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'The Golden Era of Animated Television',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ToonTheme.textMuted,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Channel Badges Row
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildNetworkTag('Cartoon Network', const Color(0xFF0284C7)),
                            _buildNetworkTag('Nickelodeon', const Color(0xFFEA580C)),
                            _buildNetworkTag('Disney & Jetix', const Color(0xFFE11D48)),
                            _buildNetworkTag("Kids' WB", const Color(0xFFD97706)),
                            _buildNetworkTag('Teletoon', const Color(0xFF7C3AED)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Overall Game Progress Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: ToonTheme.cardDecoration(radius: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'COLLECTION PROGRESS',
                              style: TextStyle(
                                color: ToonTheme.textMuted,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              '$completionPercent%',
                              style: const TextStyle(
                                color: ToonTheme.slimeGreen,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: totalLevels > 0 ? (solvedCount / totalLevels) : 0,
                            minHeight: 8,
                            backgroundColor: ToonTheme.surfaceCardLight,
                            color: ToonTheme.slimeGreen,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$solvedCount of $totalLevels Completed',
                              style: const TextStyle(
                                color: ToonTheme.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                const SizedBox(width: 3),
                                Text(
                                  '$totalStars',
                                  style: const TextStyle(
                                    color: ToonTheme.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.emoji_events_rounded, color: ToonTheme.electricCyan, size: 16),
                                const SizedBox(width: 3),
                                Text(
                                  '$totalTrophies',
                                  style: const TextStyle(
                                    color: ToonTheme.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Play Primary Action Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CrosswordScreen(levelNumber: nextLevel),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF059669), Color(0xFF10B981)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x30059669),
                            blurRadius: 14,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.20),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'CONTINUE PUZZLE (LEVEL $nextLevel)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dual Game Mode Selectors (Classic Crosswords & Emoji Rebus)
                  Row(
                    children: [
                      // Classic Crosswords
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LevelSelectScreen(initialMode: 'crossword'),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: ToonTheme.cardDecoration(radius: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: ToonTheme.electricCyan.withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.grid_view_rounded,
                                    color: ToonTheme.electricCyan,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Classic\nCrosswords',
                                  style: TextStyle(
                                    color: ToonTheme.textMain,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '200 Handcrafted Grids',
                                  style: TextStyle(color: ToonTheme.textMuted, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Emoji Title Rebus
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LevelSelectScreen(initialMode: 'rebus'),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: ToonTheme.cardDecoration(radius: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: ToonTheme.cheerfulOrange.withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.psychology_rounded,
                                    color: ToonTheme.cheerfulOrange,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Emoji Title\nRebus Riddles',
                                  style: TextStyle(
                                    color: ToonTheme.textMain,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '200 Visual Enigmas',
                                  style: TextStyle(color: ToonTheme.textMuted, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Daily Challenge Banner Card
                  GestureDetector(
                    onTap: () {
                      final dayOfYear = DateTime.now().difference(DateTime(2026, 1, 1)).inDays;
                      final dailyLevel = (dayOfYear % 200) + 1;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CrosswordScreen(levelNumber: dailyLevel),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: ToonTheme.cardDecoration(radius: 18),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x25EA580C),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Daily Challenge',
                                      style: TextStyle(
                                        color: ToonTheme.textMain,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        '+250 Coins',
                                        style: TextStyle(
                                          color: ToonTheme.amberGold,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Rotating daily puzzle to maintain your streak',
                                  style: TextStyle(color: ToonTheme.textMuted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: ToonTheme.textSubtle),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Trophy Hall & Lore Dex Link
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TrophyDexScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: ToonTheme.cardDecoration(radius: 18),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x250284C7),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Trophy Hall & Lore Dex',
                                  style: TextStyle(
                                    color: ToonTheme.textMain,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '157 Verified behind-the-scenes archive cards',
                                  style: TextStyle(color: ToonTheme.textMuted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: ToonTheme.textSubtle),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _buildNetworkTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
