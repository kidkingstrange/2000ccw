import 'package:flutter_test/flutter_test.dart';
import 'package:toon_crosswords/models/crossword_puzzle.dart';
import 'package:toon_crosswords/engine/crossword_engine.dart';

void main() {
  group('CrosswordEngine Unit Tests', () {
    late CrosswordPuzzle puzzle;
    late CrosswordEngine engine;

    setUp(() {
      // Create a 5x5 mini crossword with 2 intersecting words:
      // Word 1 (Across): "BEN" at (0, 0)
      // Word 2 (Down): "BOB" at (0, 0)
      final w1 = CrosswordWord(
        id: 'w1',
        number: 1,
        clue: 'Hero with the Omnitrix',
        answer: 'BEN',
        direction: WordDirection.across,
        startRow: 0,
        startCol: 0,
        titleId: 'ben-10',
        network: 'Cartoon Network',
      );
      final w2 = CrosswordWord(
        id: 'w2',
        number: 2,
        clue: 'Can we fix it? Yes we can!',
        answer: 'BOB',
        direction: WordDirection.down,
        startRow: 0,
        startCol: 0,
        titleId: 'bob-builder',
        network: 'JimJam',
      );

      final grid = <String, CrosswordCell>{
        '0,0': CrosswordCell(row: 0, col: 0, correctLetter: 'B', clueNumber: 1),
        '0,1': CrosswordCell(row: 0, col: 1, correctLetter: 'E'),
        '0,2': CrosswordCell(row: 0, col: 2, correctLetter: 'N'),
        '1,0': CrosswordCell(row: 1, col: 0, correctLetter: 'O'),
        '2,0': CrosswordCell(row: 2, col: 0, correctLetter: 'B'),
      };

      puzzle = CrosswordPuzzle(
        id: 'test-puzzle-1',
        levelNumber: 1,
        title: 'Test Level',
        network: 'Cartoon Network',
        difficulty: 'Easy',
        rows: 3,
        cols: 3,
        words: [w1, w2],
        grid: grid,
      );

      engine = CrosswordEngine(puzzle: puzzle);
    });

    test('Initial state is correct', () {
      expect(engine.selectedRow, 0);
      expect(engine.selectedCol, 0);
      expect(engine.selectedDirection, WordDirection.across);
      expect(engine.isPuzzleComplete, false);
      expect(engine.activeWord?.id, 'w1');
    });

    test('Inputting letters advances cursor and locks word upon completion', () {
      // Type B, E, N for word 1
      engine.inputLetter('b');
      expect(puzzle.getCell(0, 0)?.currentLetter, 'B');
      expect(engine.selectedCol, 1);

      engine.inputLetter('E');
      expect(puzzle.getCell(0, 1)?.currentLetter, 'E');
      expect(engine.selectedCol, 2);

      final result = engine.inputLetter('N');
      expect(puzzle.getCell(0, 2)?.currentLetter, 'N');
      expect(result, isNotNull);
      expect(result?.word.id, 'w1');
      expect(result?.coinsEarned, 50);
      expect(result?.puzzleCompleted, false);

      // Verify cells are locked
      expect(puzzle.getCell(0, 0)?.isLocked, true);
      expect(puzzle.getCell(0, 1)?.isLocked, true);
      expect(puzzle.getCell(0, 2)?.isLocked, true);
    });

    test('Tapping same cell toggles direction if shared', () {
      // Cursor starts at (0, 0) with across
      expect(engine.selectedRow, 0);
      expect(engine.selectedCol, 0);
      expect(engine.selectedDirection, WordDirection.across);

      // Tap cell (0, 0) while already selected -> toggles to down
      engine.selectCell(0, 0);
      expect(engine.selectedDirection, WordDirection.down);
      expect(engine.activeWord?.id, 'w2');

      // Tap again -> toggles back to across
      engine.selectCell(0, 0);
      expect(engine.selectedDirection, WordDirection.across);
      expect(engine.activeWord?.id, 'w1');
    });

    test('Delete letter clears current cell if not locked', () {
      engine.selectCell(0, 1);
      engine.inputLetter('Z');
      expect(puzzle.getCell(0, 1)?.currentLetter, 'Z');

      engine.selectCell(0, 1);
      engine.deleteLetter();
      expect(puzzle.getCell(0, 1)?.currentLetter, '');
    });

    test('Hint 1 reveals first letter of word', () {
      final revealed = engine.revealFirstLetterOfActiveWord();
      expect(revealed, true);
      expect(puzzle.getCell(0, 0)?.currentLetter, 'B');
      expect(puzzle.getCell(0, 0)?.isRevealedByHint, true);
    });

    test('Hint 2 reveals random letter in active word', () {
      final revealed = engine.revealRandomLetterOfActiveWord();
      expect(revealed, true);
      final filledCount = ['0,0', '0,1', '0,2']
          .map((k) => puzzle.grid[k]!)
          .where((c) => c.isFilled)
          .length;
      expect(filledCount, 1);
    });

    test('Hint 3 reveals entire active word and locks it', () {
      final active = engine.activeWord;
      expect(active?.id, 'w1');
      final revealed = engine.revealActiveWord();
      expect(revealed, true);
      expect(active?.isSolved, true);
      expect(puzzle.getCell(0, 0)?.isLocked, true);
      expect(puzzle.getCell(0, 1)?.isLocked, true);
      expect(puzzle.getCell(0, 2)?.isLocked, true);
    });

    test('Solving both words completes the puzzle', () {
      // Solve across word
      engine.revealActiveWord();

      // Switch to down word
      engine.selectCell(0, 0);
      engine.selectedDirection = WordDirection.down;

      // Solve down word
      engine.revealActiveWord();

      expect(engine.isPuzzleComplete, true);
    });

    test('Next clue and prev clue cycle correctly', () {
      expect(engine.activeWord?.id, 'w1');
      engine.nextClue();
      expect(engine.activeWord?.id, 'w2');
      engine.nextClue();
      expect(engine.activeWord?.id, 'w1');
      engine.prevClue();
      expect(engine.activeWord?.id, 'w2');
    });
  });
}
