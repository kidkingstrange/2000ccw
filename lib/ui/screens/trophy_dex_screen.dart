import 'package:flutter/material.dart';
import '../../services/game_storage.dart';
import '../../services/puzzle_loader.dart';
import '../theme.dart';

class TrophyDexScreen extends StatefulWidget {
  const TrophyDexScreen({super.key});

  @override
  State<TrophyDexScreen> createState() => _TrophyDexScreenState();
}

class _TrophyDexScreenState extends State<TrophyDexScreen> {
  String _selectedNetwork = 'All';

  final List<String> _networks = [
    'All',
    'Cartoon Network',
    'Nickelodeon',
    'Disney Channel & Jetix',
    "Kids' WB & 4Kids",
    'KidsCo',
    'JimJam',
    'Teletoon & International',
  ];

  @override
  Widget build(BuildContext context) {
    final storage = GameStorage();
    final loader = PuzzleLoader();
    final allTitles = loader.titles;

    final filtered = allTitles.where((t) {
      if (_selectedNetwork == 'All') return true;
      final net = (t['network'] as String?) ?? '';
      return net.toLowerCase() == _selectedNetwork.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: ToonTheme.canvasBackground,
      appBar: AppBar(
        title: const Text('TROPHY HALL & LORE DEX', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          // Header Stats Card
          ListenableBuilder(
            listenable: storage,
            builder: (context, _) {
              final unlockedCount = allTitles.where((t) => storage.isDexCardUnlocked(t['id'])).length;
              final percent = allTitles.isNotEmpty ? (unlockedCount / allTitles.length * 100).toInt() : 0;

              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: ToonTheme.retroBox(
                  background: ToonTheme.surfaceCard,
                  borderColor: ToonTheme.electricCyan,
                  radius: 16,
                  shadowOffset: 4,
                ),
                child: Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 40)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$unlockedCount OF ${allTitles.length} TROPHIES COLLECTED',
                            style: const TextStyle(
                              color: ToonTheme.electricCyan,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: allTitles.isNotEmpty ? unlockedCount / allTitles.length : 0,
                              backgroundColor: Colors.white12,
                              color: ToonTheme.slimeGreen,
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$percent% Verified Cartoon Lore Restored',
                            style: const TextStyle(color: ToonTheme.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Categorized Channel Filter
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _networks.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final net = _networks[idx];
                final isSelected = net == _selectedNetwork;
                final netColor = ToonTheme.getNetworkColor(net);

                return ChoiceChip(
                  label: Text(net),
                  selected: isSelected,
                  selectedColor: netColor,
                  backgroundColor: ToonTheme.surfaceCard,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedNetwork = net);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Trophy Cards Grid
          Expanded(
            child: ListenableBuilder(
              listenable: storage,
              builder: (context, _) {
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, idx) {
                    final item = filtered[idx];
                    final tid = item['id'] as String;
                    final isUnlocked = storage.isDexCardUnlocked(tid);
                    final network = (item['network'] as String?) ?? 'Cartoon Network';
                    final netColor = ToonTheme.getNetworkColor(network);

                    if (!isUnlocked) {
                      // Locked Card Silhouette
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: ToonTheme.retroBox(
                          background: ToonTheme.lockedGrey,
                          borderColor: Colors.black45,
                          radius: 14,
                          shadowOffset: 2,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white12,
                              child: const Icon(Icons.lock, color: Colors.white38),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Locked Lore Card • $network',
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Complete this cartoon\'s levels to unlock behind-the-scenes trivia.',
                                    style: TextStyle(color: Colors.white24, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Unlocked Full Card
                    final factObj = (item['facts'] as List?)?.firstOrNull;
                    final factText = factObj?['text'] ?? 'Verified classic series.';
                    final sources = List<String>.from(factObj?['sources'] ?? []);
                    final emojis = List<String>.from(item['emojiCandidates'] ?? ['📺']);

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: ToonTheme.retroBox(
                        background: ToonTheme.surfaceCard,
                        borderColor: netColor,
                        borderWidth: 2,
                        radius: 16,
                        shadowOffset: 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(emojis.first, style: const TextStyle(fontSize: 28)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item['title']} (${item['year']})',
                                      style: const TextStyle(
                                        color: ToonTheme.parchmentMilk,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '$network • ${item['creatorOrStudio'] ?? ''}',
                                      style: TextStyle(
                                        color: netColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.verified, color: ToonTheme.slimeGreen, size: 22),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161626),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '"$factText"',
                              style: const TextStyle(
                                color: ToonTheme.parchmentMilk,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                height: 1.35,
                              ),
                            ),
                          ),
                          if (sources.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Verified Dual Sources: ${sources.join(', ')}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
