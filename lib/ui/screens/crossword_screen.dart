import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../engine/crossword_engine.dart';
import '../../models/crossword_puzzle.dart';
import '../../services/game_storage.dart';
import '../../services/puzzle_loader.dart';
import '../theme.dart';
import '../widgets/hint_shop_sheet.dart';
import '../widgets/native_keyboard_wrapper.dart';
import '../widgets/victory_dialog.dart';

class CrosswordScreen extends StatefulWidget {
  final int levelNumber;

  const CrosswordScreen({super.key, required this.levelNumber});

  @override
  State<CrosswordScreen> createState() => _CrosswordScreenState();
}

class _CrosswordScreenState extends State<CrosswordScreen> {
  CrosswordPuzzle? _puzzle;
  CrosswordEngine? _engine;
  late int _currentLevel;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.levelNumber;
    _loadLevel(_currentLevel);
  }

  void _loadLevel(int level) {
    final puzzle = PuzzleLoader().getCrosswordByLevel(level);
    if (puzzle != null) {
      setState(() {
        _puzzle = puzzle;
        _engine = CrosswordEngine(puzzle: puzzle);
      });
    }
  }

  void _onLetter(String char) {
    if (_engine == null) return;
    final result = _engine!.inputLetter(char);
    setState(() {});

    if (result != null) {
      // Word Solved celebration!
      HapticFeedback.mediumImpact();
      GameStorage().addCoins(result.coinsEarned);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ToonTheme.mintSolved,
          duration: const Duration(seconds: 1),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                'WORD SOLVED! +${result.coinsEarned} COINS',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );

      if (result.puzzleCompleted) {
        _onPuzzleCompleted();
      }
    }
  }

  void _onDelete() {
    if (_engine == null) return;
    setState(() {
      _engine!.deleteLetter();
    });
  }

  void _onPuzzleCompleted() {
    if (_puzzle == null) return;
    final storage = GameStorage();
    storage.completeLevel(_puzzle!.id, 3, bonusCoins: 200, titleId: _puzzle!.words.first.titleId);

    final titleObj = PuzzleLoader().getTitleById(_puzzle!.words.first.titleId);
    final fact = titleObj?['facts']?[0]?['text'] as String?;
    final sources = List<String>.from(titleObj?['facts']?[0]?['sources'] ?? []);

    VictoryDialog.show(
      context,
      title: _puzzle!.title,
      network: _puzzle!.network,
      coinsEarned: 200,
      stars: 3,
      triviaFact: fact,
      sources: sources,
      onNextLevel: () {
        setState(() {
          _currentLevel += 1;
          _loadLevel(_currentLevel);
        });
      },
      onViewTrophy: () {
        Navigator.pop(context); // exit to level menu / dex
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_puzzle == null || _engine == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: ToonTheme.slimeGreen)),
      );
    }

    final storage = GameStorage();
    final activeWord = _engine!.activeWord;
    final networkColor = ToonTheme.getNetworkColor(_puzzle!.network);

    return NativeKeyboardWrapper(
      onLetter: _onLetter,
      onDelete: _onDelete,
      child: Scaffold(
        backgroundColor: ToonTheme.canvasBackground,
        appBar: AppBar(
          title: Text(
            'LEVEL $_currentLevel • ${_puzzle!.network.toUpperCase()}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
            // Channel Banner Tag & Difficulty
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: networkColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: networkColor.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _puzzle!.network,
                    style: TextStyle(
                      color: networkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Difficulty: ${_puzzle!.difficulty}',
                    style: TextStyle(color: ToonTheme.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Crossword Grid Area (Scales automatically)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: _puzzle!.cols / _puzzle!.rows,
                    child: Container(
                      decoration: ToonTheme.retroBox(
                        background: ToonTheme.surfaceCard,
                        borderColor: ToonTheme.deepSpaceBlack,
                        radius: 12,
                        shadowOffset: 4,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _puzzle!.cols,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                        ),
                        itemCount: _puzzle!.rows * _puzzle!.cols,
                        itemBuilder: (context, idx) {
                          final r = idx ~/ _puzzle!.cols;
                          final c = idx % _puzzle!.cols;
                          final cell = _puzzle!.getCell(r, c);

                          if (cell == null || cell.isBlocked) {
                            return Container(
                              decoration: BoxDecoration(
                                color: ToonTheme.blockedCell,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }

                          final isSelected = _engine!.selectedRow == r && _engine!.selectedCol == c;
                          final isInActiveWord = activeWord != null && _wordContainsCoord(activeWord, r, c);
                          final isWordSolved = cell.isLocked;

                          Color bgColor = ToonTheme.surfaceCardLight;
                          Color borderColor = const Color(0xFFCBD5E1);

                          if (isWordSolved) {
                            bgColor = ToonTheme.mintSolved;
                          } else if (isSelected) {
                            bgColor = ToonTheme.activeCell;
                            borderColor = ToonTheme.cardBorder;
                          } else if (isInActiveWord) {
                            bgColor = ToonTheme.activeWordHighlight;
                          }

                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              NativeKeyboardWrapper.of(context)?.requestFocus();
                              setState(() {
                                _engine!.selectCell(r, c);
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: isSelected ? Colors.white : borderColor,
                                  width: isSelected ? 2.5 : 1.2,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  if (cell.clueNumber != null)
                                    Positioned(
                                      top: 2,
                                      left: 2,
                                      child: Text(
                                        '${cell.clueNumber}',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: isWordSolved ? Colors.white : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                  Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        cell.currentLetter,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isWordSolved ? Colors.white : ToonTheme.textMain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isWordSolved && cell.clueNumber != null)
                                    const Positioned(
                                      bottom: 1,
                                      right: 1,
                                      child: Icon(Icons.check, size: 10, color: ToonTheme.textMain),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Active Clue Ribbon above Keyboard
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A2E),
                border: Border(top: BorderSide(color: ToonTheme.electricCyan, width: 2)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: ToonTheme.textMain),
                    onPressed: () {
                      setState(() => _engine!.prevClue());
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeWord != null
                              ? '${activeWord.number} ${activeWord.direction.name.toUpperCase()} (${activeWord.length} Letters)'
                              : 'CLUE',
                          style: const TextStyle(
                            color: ToonTheme.electricCyan,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activeWord?.clue ?? 'Select a clue on the grid',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: ToonTheme.parchmentMilk,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: ToonTheme.textMain),
                    onPressed: () {
                      setState(() => _engine!.nextClue());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.lightbulb, color: Colors.amber),
                    tooltip: 'Hint Shop',
                    onPressed: () {
                      HintShopSheet.show(
                        context,
                        modeName: 'Word',
                        onHint1: () => setState(() => _engine!.revealFirstLetterOfActiveWord()),
                        onHint2: () => setState(() => _engine!.revealRandomLetterOfActiveWord()),
                        onHint3: () => setState(() {
                          _engine!.revealActiveWord();
                          if (_engine!.isPuzzleComplete) _onPuzzleCompleted();
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Native Keyboard Anchor Padding
            const SafeArea(
              top: false,
              child: SizedBox(height: 8),
            ),
          ],
        ),
      ),
    );
  }

  bool _wordContainsCoord(CrosswordWord w, int r, int c) {
    if (w.direction == WordDirection.across) {
      return r == w.startRow && c >= w.startCol && c < w.startCol + w.length;
    } else {
      return c == w.startCol && r >= w.startRow && r < w.startRow + w.length;
    }
  }
}
