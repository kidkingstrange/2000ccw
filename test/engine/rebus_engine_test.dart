import 'package:flutter_test/flutter_test.dart';
import 'package:toon_crosswords/models/rebus_puzzle.dart';
import 'package:toon_crosswords/engine/rebus_engine.dart';

void main() {
  group('RebusEngine Unit Tests', () {
    late RebusPuzzle puzzle;
    late RebusEngine engine;

    setUp(() {
      // Create multi-word rebus with punctuation: "BEN 10: ALIEN"
      puzzle = RebusPuzzle.fromJson({
        'id': 'rebus-001',
        'levelNumber': 1,
        'titleId': 'ben-10-2005',
        'fullTitle': 'BEN 10: HERO',
        'network': 'Cartoon Network',
        'hintText': 'Hero who wears the Omnitrix',
        'emojis': ['👦', '⌚', '👽'],
        'triviaFact': 'The Omnitrix originally turned Ben into humans.',
        'sources': ['https://en.wikipedia.org/wiki/Ben_10', 'https://www.themoviedb.org/tv/4254'],
        'isSolved': false,
      });

      engine = RebusEngine(puzzle: puzzle);
    });

    test('Initial state: mystery title hidden, cursor on first letter', () {
      expect(engine.isCompleted, false);
      expect(puzzle.mysteryDisplayTitle, 'Level 1 • Rebus');
      expect(engine.selectedWordIndex, 0);
      expect(engine.selectedCharIndex, 0);
      expect(engine.activeSlot?.correctChar, 'B');
    });

    test('Dedicated word rows structure correctly preserves words & separators', () {
      expect(puzzle.wordRows.length, 3); // "BEN", "10:", "HERO"
      expect(puzzle.wordRows[0].word, 'BEN');
      expect(puzzle.wordRows[1].word, '10:');
      expect(puzzle.wordRows[2].word, 'HERO');

      // Check punctuation is marked as fixed separator and locked
      final colonSlot = puzzle.wordRows[1].slots[2];
      expect(colonSlot.correctChar, ':');
      expect(colonSlot.isFixedSeparator, true);
      expect(colonSlot.isLocked, true);
    });

    test('Inputting letters advances across words and solves puzzle', () {
      // Word 1: B, E, N
      engine.inputLetter('b');
      expect(puzzle.wordRows[0].slots[0].currentChar, 'B');

      engine.inputLetter('E');
      engine.inputLetter('N');
      expect(puzzle.wordRows[0].isSolved, true);

      // Word 2: 1, 0 (colon is fixed)
      engine.inputLetter('1');
      engine.inputLetter('0');

      // Word 3: H, E, R, O
      engine.inputLetter('H');
      engine.inputLetter('E');
      engine.inputLetter('R');
      final result = engine.inputLetter('O');

      expect(engine.isCompleted, true);
      expect(result, isNotNull);
      expect(result?.puzzleCompleted, true);
      expect(result?.coinsEarned, 100);
      expect(result?.unlockedTrivia, contains('Omnitrix'));
      expect(puzzle.mysteryDisplayTitle, 'BEN 10: HERO');
    });

    test('Delete letter clears current slot without affecting fixed punctuation', () {
      engine.inputLetter('B');
      expect(puzzle.wordRows[0].slots[0].currentChar, 'B');

      engine.selectSlot(0, 0);
      engine.deleteLetter();
      expect(puzzle.wordRows[0].slots[0].currentChar, '');
    });

    test('Hint 1 reveals first unsolved letter', () {
      final revealed = engine.revealFirstUnsolvedLetter();
      expect(revealed, true);
      expect(puzzle.wordRows[0].slots[0].currentChar, 'B');
      expect(puzzle.wordRows[0].slots[0].isRevealedByHint, true);
    });

    test('Hint 2 reveals random letter', () {
      final revealed = engine.revealRandomUnsolvedLetter();
      expect(revealed, true);
      final filledCount = puzzle.playableSlots.where((s) => s.currentChar.isNotEmpty).length;
      expect(filledCount, 1);
    });

    test('Hint 3 reveals entire puzzle and unlocks mystery title', () {
      final revealed = engine.revealEntirePuzzle();
      expect(revealed, true);
      expect(engine.isCompleted, true);
      expect(puzzle.mysteryDisplayTitle, 'BEN 10: HERO');
      expect(puzzle.playableSlots.every((s) => s.isLocked), true);
    });
  });
}
