import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../engine/rebus_engine.dart';
import '../../models/rebus_puzzle.dart';
import '../../services/game_storage.dart';
import '../../services/puzzle_loader.dart';
import '../theme.dart';
import '../widgets/hint_shop_sheet.dart';
import '../widgets/native_keyboard_wrapper.dart';
import '../widgets/victory_dialog.dart';

class RebusScreen extends StatefulWidget {
  final int levelNumber;

  const RebusScreen({super.key, required this.levelNumber});

  @override
  State<RebusScreen> createState() => _RebusScreenState();
}

class _RebusScreenState extends State<RebusScreen> {
  RebusPuzzle? _puzzle;
  RebusEngine? _engine;
  late int _currentLevel;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.levelNumber;
    _loadLevel(_currentLevel);
  }

  void _loadLevel(int level) {
    final puzzle = PuzzleLoader().getRebusByLevel(level);
    if (puzzle != null) {
      setState(() {
        _puzzle = puzzle;
        _engine = RebusEngine(puzzle: puzzle);
      });
    }
  }

  void _onLetter(String char) {
    if (_engine == null) return;
    final result = _engine!.inputLetter(char);
    setState(() {});

    if (result != null && result.puzzleCompleted) {
      _onPuzzleCompleted(result);
    }
  }

  void _onDelete() {
    if (_engine == null) return;
    setState(() {
      _engine!.deleteLetter();
    });
  }

  void _onPuzzleCompleted(RebusSolveResult result) {
    if (_puzzle == null) return;
    final storage = GameStorage();
    storage.completeLevel(
      _puzzle!.id,
      3,
      bonusCoins: result.coinsEarned,
      titleId: _puzzle!.titleId,
    );

    VictoryDialog.show(
      context,
      title: _puzzle!.fullTitle,
      network: _puzzle!.network,
      coinsEarned: result.coinsEarned,
      stars: 3,
      triviaFact: result.unlockedTrivia,
      sources: result.sources,
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
    final networkColor = ToonTheme.getNetworkColor(_puzzle!.network);

    return NativeKeyboardWrapper(
      onLetter: _onLetter,
      onDelete: _onDelete,
      child: Scaffold(
        backgroundColor: ToonTheme.canvasBackground,
        appBar: AppBar(
          title: Text(
            _puzzle!.mysteryDisplayTitle,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.5),
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
            // Network Category Banner
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
                  const Text(
                    'EMOJI TITLE REBUS',
                    style: TextStyle(
                      color: ToonTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),

            // Emoji Riddle Stage Area
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: ToonTheme.cardDecoration(
                radius: 20,
                shadowOffset: 4,
                blurRadius: 16,
              ),
              child: Column(
                children: [
                  // Emoji Sequence with elegant presentation
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: _puzzle!.emojis.map((emoji) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: ToonTheme.surfaceCardLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: ToonTheme.cardBorder),
                        ),
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 38),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Hint Subtitle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: ToonTheme.surfaceCardLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '"${_puzzle!.hintText}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ToonTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dedicated Word Rows Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  itemCount: _puzzle!.wordRows.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, wIdx) {
                    final row = _puzzle!.wordRows[wIdx];
                    return _buildWordRow(row, wIdx);
                  },
                ),
              ),
            ),

            // Quick Hint Shop Bottom Ribbon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: ToonTheme.surfaceCard,
                border: Border(
                  top: BorderSide(color: ToonTheme.cardBorder, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x060F172A),
                    offset: Offset(0, -3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _puzzle!.isSolved ? 'PUZZLE SOLVED!' : 'Tap any slot to enter letters',
                    style: TextStyle(
                      color: _puzzle!.isSolved ? ToonTheme.slimeGreen : ToonTheme.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      HintShopSheet.show(
                        context,
                        modeName: 'Title',
                        onHint1: () => setState(() => _engine!.revealFirstUnsolvedLetter()),
                        onHint2: () => setState(() => _engine!.revealRandomUnsolvedLetter()),
                        onHint3: () => setState(() {
                          _engine!.revealEntirePuzzle();
                          _onPuzzleCompleted(RebusSolveResult(
                            puzzleCompleted: true,
                            coinsEarned: 100,
                            unlockedTrivia: _puzzle!.triviaFact,
                            sources: _puzzle!.sources,
                          ));
                        }),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x25EA580C),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.lightbulb_rounded, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'HINTS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildWordRow(RebusWordRow row, int wordIdx) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(row.slots.length, (charIdx) {
          final slot = row.slots[charIdx];
          final isSelected = _engine!.selectedWordIndex == wordIdx &&
              _engine!.selectedCharIndex == charIdx;

          if (slot.isFixedSeparator) {
            // Non-alphanumeric punctuation (hyphen, colon, apostrophe)
            return Container(
              width: 24,
              height: 48,
              alignment: Alignment.center,
              child: Text(
                slot.correctChar,
                style: const TextStyle(
                  color: ToonTheme.textSecondary,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            );
          }

          Color bgColor = ToonTheme.surfaceCard;
          Color borderColor = ToonTheme.cardBorder;
          Color letterColor = ToonTheme.textMain;

          if (_puzzle!.isSolved || slot.isLocked) {
            bgColor = ToonTheme.mintSolvedBg;
            borderColor = ToonTheme.mintSolved.withValues(alpha: 0.4);
            letterColor = ToonTheme.mintSolvedText;
          } else if (isSelected) {
            bgColor = ToonTheme.activeCellBg;
            borderColor = ToonTheme.activeCell;
          }

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              NativeKeyboardWrapper.of(context)?.requestFocus();
              setState(() {
                _engine!.selectSlot(wordIdx, charIdx);
              });
            },
            child: Container(
              width: 44,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
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
                    : const [
                        BoxShadow(
                          color: Color(0x060F172A),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
              ),
              alignment: Alignment.center,
              child: Text(
                slot.currentChar,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: letterColor,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
