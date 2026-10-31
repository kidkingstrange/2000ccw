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
      // Word Solved celebration
      HapticFeedback.mediumImpact();
      GameStorage().addCoins(result.coinsEarned);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: ToonTheme.mintSolved,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 6,
          duration: const Duration(milliseconds: 1400),
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                'WORD SOLVED! +${result.coinsEarned} COINS',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
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
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_puzzle == null || _engine == null) {
      return const Scaffold(
        backgroundColor: ToonTheme.canvasBackground,
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
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
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
                    const Icon(
                      Icons.monetization_on_rounded,
                      color: ToonTheme.amberGold,
                      size: 16,
                    ),
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
            // Channel Banner & Difficulty Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: networkColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: networkColor.withValues(alpha: 0.20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: networkColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _puzzle!.network,
                        style: TextStyle(
                          color: networkColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Difficulty: ${_puzzle!.difficulty.toUpperCase()}',
                    style: const TextStyle(
                      color: ToonTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Crossword Grid Area (Scales automatically)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AspectRatio(
                    aspectRatio: _puzzle!.cols / _puzzle!.rows,
                    child: Container(
                      decoration: ToonTheme.cardDecoration(
                        radius: 16,
                        shadowOffset: 4,
                        blurRadius: 16,
                      ),
                      padding: const EdgeInsets.all(8),
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
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          }

                          final isSelected = _engine!.selectedRow == r && _engine!.selectedCol == c;
                          final isInActiveWord = activeWord != null && _wordContainsCoord(activeWord, r, c);
                          final isWordSolved = cell.isLocked;

                          Color bgColor = ToonTheme.surfaceCard;
                          Color borderColor = ToonTheme.cardBorder;
                          Color letterColor = ToonTheme.textMain;

                          if (isWordSolved) {
                            bgColor = ToonTheme.mintSolvedBg;
                            borderColor = ToonTheme.mintSolved.withValues(alpha: 0.4);
                            letterColor = ToonTheme.mintSolvedText;
                          } else if (isSelected) {
                            bgColor = ToonTheme.activeCellBg;
                            borderColor = ToonTheme.activeCell;
                          } else if (isInActiveWord) {
                            bgColor = ToonTheme.activeWordHighlight;
                            borderColor = ToonTheme.activeWordBorder;
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
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: borderColor,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: ToonTheme.activeCell.withValues(alpha: 0.25),
                                          blurRadius: 6,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Stack(
                                children: [
                                  if (cell.clueNumber != null)
                                    Positioned(
                                      top: 2,
                                      left: 3,
                                      child: Text(
                                        '${cell.clueNumber}',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: isWordSolved
                                              ? ToonTheme.mintSolvedText.withValues(alpha: 0.7)
                                              : ToonTheme.textMuted,
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
                                          fontWeight: FontWeight.w800,
                                          color: letterColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isWordSolved && cell.clueNumber != null)
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Icon(
                                        Icons.check_rounded,
                                        size: 10,
                                        color: ToonTheme.mintSolvedText,
                                      ),
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

            // Active Clue Floating Ribbon (Editorial White Paper Aesthetic)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: ToonTheme.surfaceCard,
                border: Border(
                  top: BorderSide(color: ToonTheme.cardBorder, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x080F172A),
                    offset: Offset(0, -4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, color: ToonTheme.textSecondary, size: 28),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() => _engine!.prevClue());
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeWord != null
                              ? '${activeWord.number} ${activeWord.direction.name.toUpperCase()} • ${activeWord.length} LETTERS'
                              : 'CLUE',
                          style: const TextStyle(
                            color: ToonTheme.electricCyan,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          activeWord?.clue ?? 'Select a cell on the grid',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: ToonTheme.textMain,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded, color: ToonTheme.textSecondary, size: 28),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() => _engine!.nextClue());
                    },
                  ),
                  const SizedBox(width: 8),
                  // Hint Shop Trigger Button
                  Container(
                    decoration: BoxDecoration(
                      color: ToonTheme.amberGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.lightbulb_rounded, color: ToonTheme.amberGold, size: 22),
                      tooltip: 'Hint Shop',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
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
                  ),
                ],
              ),
            ),

            // Native Keyboard Anchor Padding
            const SafeArea(
              top: false,
              child: SizedBox(height: 4),
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
