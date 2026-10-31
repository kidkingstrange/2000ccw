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
      final net = (p as dynamic).network as String;
      return net.toLowerCase() == _selectedNetwork.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: ToonTheme.canvasBackground,
      appBar: AppBar(
        title: Text(
          isCrossword ? 'CROSSWORD LEVELS' : 'REBUS LEVELS',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.5),
        ),
        actions: [
          ListenableBuilder(
            listenable: storage,
            builder: (context, _) => Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: ToonTheme.pillDecoration(color: ToonTheme.amberGold),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on_rounded, color: ToonTheme.amberGold, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    '${storage.coins}',
                    style: const TextStyle(
                      color: ToonTheme.amberGold,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
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
          // Segmented Mode Control (Crossword vs Rebus)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ToonTheme.surfaceCardLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ToonTheme.cardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _currentMode = 'crossword'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isCrossword ? ToonTheme.surfaceCard : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isCrossword
                            ? const [
                                BoxShadow(
                                  color: Color(0x0A0F172A),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.grid_view_rounded,
                            size: 16,
                            color: isCrossword ? ToonTheme.electricCyan : ToonTheme.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Crosswords (${loader.crosswords.length})',
                            style: TextStyle(
                              color: isCrossword ? ToonTheme.textMain : ToonTheme.textMuted,
                              fontWeight: isCrossword ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
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
                        color: !isCrossword ? ToonTheme.surfaceCard : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: !isCrossword
                            ? const [
                                BoxShadow(
                                  color: Color(0x0A0F172A),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.psychology_rounded,
                            size: 16,
                            color: !isCrossword ? ToonTheme.cheerfulOrange : ToonTheme.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Rebus (${loader.rebusPuzzles.length})',
                            style: TextStyle(
                              color: !isCrossword ? ToonTheme.textMain : ToonTheme.textMuted,
                              fontWeight: !isCrossword ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
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
          const SizedBox(height: 10),

          // Level Cards Grid
          Expanded(
            child: ListenableBuilder(
              listenable: storage,
              builder: (context, _) {
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? (isSolved ? ToonTheme.mintSolvedBg : ToonTheme.surfaceCard)
                              : ToonTheme.surfaceCardLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSolved
                                ? ToonTheme.mintSolved.withValues(alpha: 0.4)
                                : (isUnlocked ? ToonTheme.cardBorder : Colors.transparent),
                            width: 1.0,
                          ),
                          boxShadow: isUnlocked
                              ? const [
                                  BoxShadow(
                                    color: Color(0x080F172A),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!isUnlocked) ...[
                              const Icon(Icons.lock_outline_rounded, color: ToonTheme.textSubtle, size: 24),
                              const SizedBox(height: 6),
                              Text(
                                'Level $levelNum',
                                style: const TextStyle(
                                  color: ToonTheme.textSubtle,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ] else ...[
                              Text(
                                'LEVEL $levelNum',
                                style: TextStyle(
                                  color: isSolved ? ToonTheme.mintSolvedText : ToonTheme.textMain,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                network,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: netColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3,
                                  (i) => Icon(
                                    i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                                    size: 15,
                                    color: i < stars ? Colors.amber : ToonTheme.textSubtle.withValues(alpha: 0.5),
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
