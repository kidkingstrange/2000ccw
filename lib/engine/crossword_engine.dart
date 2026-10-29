import 'dart:math';
import '../models/crossword_puzzle.dart';

class WordSolvedResult {
  final CrosswordWord word;
  final int coinsEarned;
  final bool puzzleCompleted;

  WordSolvedResult({
    required this.word,
    required this.coinsEarned,
    required this.puzzleCompleted,
  });
}

class CrosswordEngine {
  final CrosswordPuzzle puzzle;
  int selectedRow = 0;
  int selectedCol = 0;
  WordDirection selectedDirection = WordDirection.across;
  final Set<String> solvedWordIds = {};

  CrosswordEngine({required this.puzzle}) {
    _initializeCursor();
    _checkInitialSolvedState();
  }

  void _initializeCursor() {
    if (puzzle.words.isNotEmpty) {
      final first = puzzle.words.first;
      selectedRow = first.startRow;
      selectedCol = first.startCol;
      selectedDirection = first.direction;
    }
  }

  void _checkInitialSolvedState() {
    for (final word in puzzle.words) {
      if (_isWordCorrectlyFilled(word)) {
        word.isSolved = true;
        solvedWordIds.add(word.id);
        _lockWordCells(word);
      }
    }
  }

  bool get isPuzzleComplete =>
      puzzle.words.isNotEmpty && puzzle.words.every((w) => w.isSolved);

  CrosswordWord? get activeWord {
    // Find word matching current direction containing (selectedRow, selectedCol)
    for (final w in puzzle.words) {
      if (w.direction == selectedDirection) {
        if (_wordContains(w, selectedRow, selectedCol)) return w;
      }
    }
    // Fallback to other direction if current cell is in it
    for (final w in puzzle.words) {
      if (_wordContains(w, selectedRow, selectedCol)) {
        selectedDirection = w.direction;
        return w;
      }
    }
    return puzzle.words.isNotEmpty ? puzzle.words.first : null;
  }

  bool _wordContains(CrosswordWord w, int r, int c) {
    if (w.direction == WordDirection.across) {
      return r == w.startRow && c >= w.startCol && c < w.startCol + w.length;
    } else {
      return c == w.startCol && r >= w.startRow && r < w.startRow + w.length;
    }
  }

  void selectCell(int r, int c) {
    final cell = puzzle.getCell(r, c);
    if (cell == null || cell.isBlocked) return;

    if (selectedRow == r && selectedCol == c) {
      // Toggle direction if cell participates in both directions
      final hasAcross = puzzle.words.any(
        (w) => w.direction == WordDirection.across && _wordContains(w, r, c),
      );
      final hasDown = puzzle.words.any(
        (w) => w.direction == WordDirection.down && _wordContains(w, r, c),
      );

      if (hasAcross && hasDown) {
        selectedDirection = (selectedDirection == WordDirection.across)
            ? WordDirection.down
            : WordDirection.across;
      }
    } else {
      selectedRow = r;
      selectedCol = c;
      // If current direction has no word here, switch to the other
      final hasCurrentDirWord = puzzle.words.any(
        (w) => w.direction == selectedDirection && _wordContains(w, r, c),
      );
      if (!hasCurrentDirWord) {
        final otherDir = (selectedDirection == WordDirection.across)
            ? WordDirection.down
            : WordDirection.across;
        final hasOther = puzzle.words.any(
          (w) => w.direction == otherDir && _wordContains(w, r, c),
        );
        if (hasOther) selectedDirection = otherDir;
      }
    }
  }

  WordSolvedResult? inputLetter(String letter) {
    final cell = puzzle.getCell(selectedRow, selectedCol);
    if (cell == null || cell.isBlocked || cell.isLocked) {
      _advanceCursor();
      return null;
    }

    final char = letter.toUpperCase();
    cell.currentLetter = char;

    // Check words affected by this cell
    WordSolvedResult? result;
    for (final w in puzzle.words) {
      if (!w.isSolved && _wordContains(w, selectedRow, selectedCol)) {
        if (_isWordCorrectlyFilled(w)) {
          w.isSolved = true;
          solvedWordIds.add(w.id);
          _lockWordCells(w);
          result = WordSolvedResult(
            word: w,
            coinsEarned: 50,
            puzzleCompleted: isPuzzleComplete,
          );
        }
      }
    }

    _advanceCursor();
    return result;
  }

  void deleteLetter() {
    final cell = puzzle.getCell(selectedRow, selectedCol);
    if (cell != null && !cell.isLocked) {
      cell.currentLetter = '';
    }
    _retreatCursor();
  }

  void _advanceCursor() {
    final word = activeWord;
    if (word == null) return;

    if (word.direction == WordDirection.across) {
      final nextCol = selectedCol + 1;
      if (nextCol < word.startCol + word.length) {
        selectedCol = nextCol;
      }
    } else {
      final nextRow = selectedRow + 1;
      if (nextRow < word.startRow + word.length) {
        selectedRow = nextRow;
      }
    }
  }

  void _retreatCursor() {
    final word = activeWord;
    if (word == null) return;

    if (word.direction == WordDirection.across) {
      final prevCol = selectedCol - 1;
      if (prevCol >= word.startCol) {
        selectedCol = prevCol;
      }
    } else {
      final prevRow = selectedRow - 1;
      if (prevRow >= word.startRow) {
        selectedRow = prevRow;
      }
    }
  }

  void nextClue() {
    if (puzzle.words.isEmpty) return;
    final current = activeWord;
    int idx = puzzle.words.indexOf(current ?? puzzle.words.first);
    idx = (idx + 1) % puzzle.words.length;
    final nextW = puzzle.words[idx];
    selectedRow = nextW.startRow;
    selectedCol = nextW.startCol;
    selectedDirection = nextW.direction;
  }

  void prevClue() {
    if (puzzle.words.isEmpty) return;
    final current = activeWord;
    int idx = puzzle.words.indexOf(current ?? puzzle.words.first);
    idx = (idx - 1 + puzzle.words.length) % puzzle.words.length;
    final prevW = puzzle.words[idx];
    selectedRow = prevW.startRow;
    selectedCol = prevW.startCol;
    selectedDirection = prevW.direction;
  }

  bool _isWordCorrectlyFilled(CrosswordWord word) {
    for (final coord in word.cellCoordinates) {
      final cell = puzzle.getCell(coord['row']!, coord['col']!);
      if (cell == null || !cell.isCorrect) return false;
    }
    return true;
  }

  void _lockWordCells(CrosswordWord word) {
    for (final coord in word.cellCoordinates) {
      final cell = puzzle.getCell(coord['row']!, coord['col']!);
      if (cell != null) {
        cell.isLocked = true;
      }
    }
  }

  // --- 3-TIER HINT SHOP ---
  // Hint 1: Reveal first unsolved letter (50 Coins)
  bool revealFirstLetterOfActiveWord() {
    final word = activeWord;
    if (word == null || word.isSolved) return false;

    for (final coord in word.cellCoordinates) {
      final cell = puzzle.getCell(coord['row']!, coord['col']!);
      if (cell != null && !cell.isCorrect) {
        cell.currentLetter = cell.correctLetter;
        cell.isRevealedByHint = true;
        _checkAndLockWord(word);
        return true;
      }
    }
    return false;
  }

  // Hint 2: Reveal random unsolved letter in active word (100 Coins)
  bool revealRandomLetterOfActiveWord() {
    final word = activeWord;
    if (word == null || word.isSolved) return false;

    final unsolved = <CrosswordCell>[];
    for (final coord in word.cellCoordinates) {
      final cell = puzzle.getCell(coord['row']!, coord['col']!);
      if (cell != null && !cell.isCorrect) {
        unsolved.add(cell);
      }
    }

    if (unsolved.isEmpty) return false;
    final target = unsolved[Random().nextInt(unsolved.length)];
    target.currentLetter = target.correctLetter;
    target.isRevealedByHint = true;
    _checkAndLockWord(word);
    return true;
  }

  // Hint 3: Reveal entire active word (250 Coins)
  bool revealActiveWord() {
    final word = activeWord;
    if (word == null || word.isSolved) return false;

    for (final coord in word.cellCoordinates) {
      final cell = puzzle.getCell(coord['row']!, coord['col']!);
      if (cell != null) {
        cell.currentLetter = cell.correctLetter;
        cell.isRevealedByHint = true;
      }
    }
    word.isSolved = true;
    solvedWordIds.add(word.id);
    _lockWordCells(word);
    return true;
  }

  void _checkAndLockWord(CrosswordWord word) {
    if (_isWordCorrectlyFilled(word)) {
      word.isSolved = true;
      solvedWordIds.add(word.id);
      _lockWordCells(word);
    }
  }
}
