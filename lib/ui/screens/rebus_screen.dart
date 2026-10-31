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
        body: Center(child: CircularProgressIndicator(color: ToonTheme.slimeGreen)),
      );
    }

    final storage = GameStorage();
    final networkColor = ToonTheme.getNetworkColor(_puzzle!.network);

    return NativeKeyboardWrapper(
      onLetter: _onLetter,
      onDelete: _onDelete,
      child: Scaffold(
        backgroundColor: ToonTheme.deepSpaceBlack,
        appBar: AppBar(
          title: Text(
            _puzzle!.mysteryDisplayTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            // Network Category Banner
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
                  const Text('EMOJI TITLE REBUS', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),

            // Emoji Riddle Stage Area
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: ToonTheme.retroBox(
                background: ToonTheme.surfaceCard,
                borderColor: ToonTheme.electricCyan,
                borderWidth: 2,
                radius: 16,
                shadowOffset: 4,
              ),
              child: Column(
                children: [
                  // Emoji Sequence
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _puzzle!.emojis.map((emoji) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 44),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  // Hint Subtitle
                  Text(
                    '"${_puzzle!.hintText}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ToonTheme.parchmentMilk,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
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

            // Quick Hint Shop Drawer trigger
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF161628),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _puzzle!.isSolved ? 'SOLVED!' : 'Tap a slot to type letter',
                    style: TextStyle(
                      color: _puzzle!.isSolved ? ToonTheme.slimeGreen : Colors.white60,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ToonTheme.cheerfulOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.lightbulb, size: 18),
                    label: const Text('HINTS', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
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
                  color: ToonTheme.parchmentMilk,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          Color bgColor = ToonTheme.surfaceCardLight;
          Color borderColor = Colors.black;

          if (_puzzle!.isSolved || slot.isLocked) {
            bgColor = ToonTheme.mintSolved;
          } else if (isSelected) {
            bgColor = ToonTheme.electricCyan;
            borderColor = Colors.white;
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
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.white : borderColor,
                  width: isSelected ? 2.5 : 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                slot.currentChar,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: (_puzzle!.isSolved || slot.isLocked)
                      ? Colors.black
                      : (isSelected ? Colors.black : Colors.white),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
