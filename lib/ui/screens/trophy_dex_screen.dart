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
        title: const Text(
          'TROPHY HALL & LORE DEX',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.5),
        ),
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
                padding: const EdgeInsets.all(18),
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
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x200284C7),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$unlockedCount OF ${allTitles.length} ARCHIVES UNLOCKED',
                            style: const TextStyle(
                              color: ToonTheme.textMain,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: allTitles.isNotEmpty ? unlockedCount / allTitles.length : 0,
                              backgroundColor: ToonTheme.surfaceCardLight,
                              color: ToonTheme.slimeGreen,
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$percent% Verified Historical Animation Lore',
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

          // Categorized Channel Filter Pills
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

                return FilterChip(
                  label: Text(net),
                  selected: isSelected,
                  selectedColor: netColor.withValues(alpha: 0.12),
                  backgroundColor: ToonTheme.surfaceCard,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: isSelected ? netColor : ToonTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? netColor.withValues(alpha: 0.4) : ToonTheme.cardBorder,
                    ),
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedNetwork = net);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Trophy Cards List
          Expanded(
            child: ListenableBuilder(
              listenable: storage,
              builder: (context, _) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
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
                        decoration: BoxDecoration(
                          color: ToonTheme.surfaceCardLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: ToonTheme.cardBorder),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ToonTheme.cardBorder,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.lock_outline_rounded, color: ToonTheme.textSubtle, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Locked Lore Card • $network',
                                    style: const TextStyle(
                                      color: ToonTheme.textSecondary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Solve this cartoon\'s puzzles to unlock verified trivia facts.',
                                    style: TextStyle(color: ToonTheme.textMuted, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Unlocked Full Lore Card
                    final factObj = (item['facts'] as List?)?.firstOrNull;
                    final factText = factObj?['text'] ?? 'Verified classic series.';
                    final sources = List<String>.from(factObj?['sources'] ?? []);
                    final emojis = List<String>.from(item['emojiCandidates'] ?? ['📺']);

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: ToonTheme.cardDecoration(radius: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: ToonTheme.surfaceCardLight,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: ToonTheme.cardBorder),
                                ),
                                child: Text(emojis.first, style: const TextStyle(fontSize: 22)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item['title']} (${item['year']})',
                                      style: const TextStyle(
                                        color: ToonTheme.textMain,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '$network • ${item['creatorOrStudio'] ?? ''}',
                                      style: TextStyle(
                                        color: netColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.verified_rounded, color: ToonTheme.slimeGreen, size: 22),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ToonTheme.surfaceCardLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: ToonTheme.cardBorder),
                            ),
                            child: Text(
                              '"$factText"',
                              style: const TextStyle(
                                color: ToonTheme.textSecondary,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                height: 1.35,
                              ),
                            ),
                          ),
                          if (sources.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Verified Sources: ${sources.join(', ')}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: ToonTheme.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
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
