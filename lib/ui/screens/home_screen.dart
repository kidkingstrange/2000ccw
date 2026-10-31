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

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Navigation Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Streak Flame Counter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: ToonTheme.retroBox(
                          background: ToonTheme.surfaceCard,
                          borderColor: ToonTheme.cheerfulOrange,
                          radius: 20,
                          shadowOffset: 2,
                        ),
                        child: Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text(
                              '${storage.dailyStreak} DAY STREAK',
                              style: const TextStyle(
                                color: ToonTheme.cheerfulOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Coins & Settings
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: ToonTheme.retroBox(
                              background: ToonTheme.surfaceCard,
                              borderColor: ToonTheme.slimeGreen,
                              radius: 20,
                              shadowOffset: 2,
                            ),
                            child: Row(
                              children: [
                                const Text('🪙', style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 4),
                                Text(
                                  '${storage.coins}',
                                  style: const TextStyle(
                                    color: ToonTheme.slimeGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.settings, color: ToonTheme.textMuted),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SettingsScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Brand Hero Header (CRT TV & Slime Motif)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: ToonTheme.retroBox(
                        background: ToonTheme.surfaceCard,
                        borderColor: ToonTheme.slimeGreen,
                        borderWidth: 2.5,
                        radius: 20,
                        shadowOffset: 4,
                      ),
                      child: Column(
                        children: [
                          // Vector CRT Television Motif
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('📡', style: TextStyle(fontSize: 24)),
                              SizedBox(width: 6),
                              Text('📺', style: TextStyle(fontSize: 48)),
                              SizedBox(width: 6),
                              Text('✨', style: TextStyle(fontSize: 24)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '2000s TOON CROSSWORDS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ToonTheme.slimeGreen,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Saturday Morning & Cable Cartoon Puzzles',
                            style: TextStyle(
                              color: ToonTheme.electricCyan,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Overall Game Progress Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: ToonTheme.retroBox(
                      background: ToonTheme.surfaceCard,
                      borderColor: ToonTheme.electricCyan,
                      radius: 16,
                      shadowOffset: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'OVERALL PROGRESS',
                              style: TextStyle(
                                color: ToonTheme.parchmentMilk,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '$completionPercent%',
                              style: const TextStyle(
                                color: ToonTheme.slimeGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: totalLevels > 0 ? (solvedCount / totalLevels) : 0,
                            minHeight: 12,
                            backgroundColor: const Color(0xFFE2E8F0),
                            color: ToonTheme.slimeGreen,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$solvedCount / $totalLevels Cleared',
                              style: const TextStyle(color: ToonTheme.textMuted, fontSize: 12),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  '$totalStars Stars',
                                  style: const TextStyle(color: ToonTheme.textMuted, fontSize: 12),
                                ),
                                const SizedBox(width: 8),
                                const Text('🏆', style: TextStyle(fontSize: 12)),
                                const SizedBox(width: 2),
                                Text(
                                  '$totalTrophies Trophies',
                                  style: const TextStyle(color: ToonTheme.textMuted, fontSize: 12),
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ToonTheme.slimeGreen,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    onPressed: () {
                      // Launch next unsolved crossword or rebus
                      int nextLevel = 1;
                      for (int i = 1; i <= 200; i++) {
                        final id = 'cw-${i.toString().padLeft(3, '0')}';
                        if (!storage.isLevelSolved(id)) {
                          nextLevel = i;
                          break;
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CrosswordScreen(levelNumber: nextLevel),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.play_arrow_rounded, size: 30),
                        SizedBox(width: 8),
                        Text(
                          'QUICK PLAY (NEXT PUZZLE)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Dual Mode Selectors Grid
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
                            decoration: ToonTheme.retroBox(
                              background: ToonTheme.surfaceCard,
                              borderColor: ToonTheme.electricCyan,
                              radius: 16,
                              shadowOffset: 3,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('🧩', style: TextStyle(fontSize: 32)),
                                SizedBox(height: 8),
                                Text(
                                  'CLASSIC\nCROSSWORDS',
                                  style: TextStyle(
                                    color: ToonTheme.electricCyan,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '200 Grids • 4 Tiers',
                                  style: TextStyle(color: ToonTheme.textMuted, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Emoji Rebus Puzzles
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
                            decoration: ToonTheme.retroBox(
                              background: ToonTheme.surfaceCard,
                              borderColor: ToonTheme.cheerfulOrange,
                              radius: 16,
                              shadowOffset: 3,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('🤔', style: TextStyle(fontSize: 32)),
                                SizedBox(height: 8),
                                Text(
                                  'EMOJI TITLE\nREBUS RIDDLES',
                                  style: TextStyle(
                                    color: ToonTheme.cheerfulOrange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '200 Riddles • Visuals',
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
                      // Daily challenge chooses daily deterministic level based on date
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
                      decoration: ToonTheme.retroBox(
                        background: ToonTheme.surfaceCard,
                        borderColor: ToonTheme.cheerfulOrange,
                        borderWidth: 2,
                        radius: 16,
                        shadowOffset: 3,
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: ToonTheme.cheerfulOrange,
                            child: Text('🔥', style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      'DAILY CHALLENGE',
                                      style: TextStyle(
                                        color: ToonTheme.parchmentMilk,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text('⭐ +250 Coins', style: TextStyle(color: Colors.amber, fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Rotating daily special puzzle to keep your flame streak alive!',
                                  style: TextStyle(color: ToonTheme.textMuted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: ToonTheme.textMuted),
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
                      decoration: ToonTheme.retroBox(
                        background: ToonTheme.surfaceCard,
                        borderColor: ToonTheme.slimeGreen,
                        radius: 16,
                        shadowOffset: 3,
                      ),
                      child: Row(
                        children: const [
                          Text('🏆', style: TextStyle(fontSize: 32)),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TROPHY HALL / DEX',
                                  style: TextStyle(
                                    color: ToonTheme.slimeGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Unlock verified behind-the-scenes facts across 157 cartoons',
                                  style: TextStyle(color: ToonTheme.textMuted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: ToonTheme.textMuted),
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
}
