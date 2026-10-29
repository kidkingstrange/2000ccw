import 'package:flutter/material.dart';
import '../../services/game_storage.dart';
import '../../services/puzzle_loader.dart';
import '../theme.dart';
import 'crossword_screen.dart';
import 'rebus_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  final String initialMode; // 'crossword' or 'rebus'
  final String? initialNetwork;

  const LevelSelectScreen({
    super.key,
    this.initialMode = 'crossword',
    this.initialNetwork,
  });

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  late String _currentMode;
  late String _selectedNetwork;

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
  void initState() {
    super.initState();
    _currentMode = widget.initialMode;
    _selectedNetwork = widget.initialNetwork ?? 'All';
  }

  @override
  Widget build(BuildContext context) {
    final storage = GameStorage();
    final loader = PuzzleLoader();

    final isCrossword = _currentMode == 'crossword';
    final items = isCrossword ? loader.crosswords : loader.rebusPuzzles;

    final filtered = items.where((p) {
      if (_selectedNetwork == 'All') return true;
      final net = isCrossword ? (p as dynamic).network : (p as dynamic).network;
      return net.toLowerCase() == _selectedNetwork.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: ToonTheme.deepSpaceBlack,
      appBar: AppBar(
        title: Text(
          isCrossword ? 'CROSSWORD LEVELS' : 'REBUS LEVELS',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          ListenableBuilder(
            listenable: storage,
            builder: (context, _) => Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: ToonTheme.retroBox(
                background: ToonTheme.surfaceCard,
                radius: 16,
                shadowOffset: 2,
              ),
              child: Row(
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '${storage.coins}',
                    style: const TextStyle(
                      color: ToonTheme.slimeGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Mode Toggle Tabs (Crossword vs Rebus)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ToonTheme.surfaceCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _currentMode = 'crossword'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isCrossword ? ToonTheme.electricCyan : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '🧩 Crosswords (${loader.crosswords.length})',
                        style: TextStyle(
                          color: isCrossword ? Colors.black : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _currentMode = 'rebus'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !isCrossword ? ToonTheme.cheerfulOrange : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '🤔 Rebus (${loader.rebusPuzzles.length})',
                        style: TextStyle(
                          color: !isCrossword ? Colors.black : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                  side: BorderSide(
                    color: isSelected ? Colors.white : Colors.white24,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedNetwork = net);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Level Cards Grid
          Expanded(
            child: ListenableBuilder(
              listenable: storage,
              builder: (context, _) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.88,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, idx) {
                    final puzzle = filtered[idx];
                    final levelNum = (puzzle as dynamic).levelNumber as int;
                    final puzzleId = (puzzle as dynamic).id as String;
                    final network = (puzzle as dynamic).network as String;

                    final isSolved = storage.isLevelSolved(puzzleId);
                    final isUnlocked = storage.isLevelUnlocked(levelNum, isCrossword ? 'cw' : 'rebus');
                    final stars = storage.getStars(puzzleId);
                    final netColor = ToonTheme.getNetworkColor(network);

                    return GestureDetector(
                      onTap: isUnlocked
                          ? () {
                              if (isCrossword) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CrosswordScreen(levelNumber: levelNum),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RebusScreen(levelNumber: levelNum),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Container(
                        decoration: ToonTheme.retroBox(
                          background: isUnlocked
                              ? (isSolved ? const Color(0xFF1D2E2B) : ToonTheme.surfaceCard)
                              : ToonTheme.lockedGrey,
                          borderColor: isSolved
                              ? ToonTheme.mintSolved
                              : (isUnlocked ? netColor.withOpacity(0.6) : Colors.black45),
                          radius: 14,
                          shadowOffset: isUnlocked ? 3 : 1,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!isUnlocked) ...[
                              const Icon(Icons.lock, color: Colors.white38, size: 28),
                              const SizedBox(height: 6),
                              Text(
                                'Level $levelNum',
                                style: const TextStyle(color: Colors.white38, fontSize: 13),
                              ),
                            ] else ...[
                              Text(
                                'LEVEL $levelNum',
                                style: TextStyle(
                                  color: isSolved ? ToonTheme.mintSolved : Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                network,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: netColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3,
                                  (i) => Icon(
                                    i < stars ? Icons.star : Icons.star_border,
                                    size: 16,
                                    color: i < stars ? Colors.amber : Colors.white24,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
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
