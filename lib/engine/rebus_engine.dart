import 'dart:math';
import '../models/rebus_puzzle.dart';

class RebusSolveResult {
  final bool puzzleCompleted;
  final int coinsEarned;
  final String unlockedTrivia;
  final List<String> sources;

  RebusSolveResult({
    required this.puzzleCompleted,
    required this.coinsEarned,
    required this.unlockedTrivia,
    required this.sources,
  });
}

class RebusEngine {
  final RebusPuzzle puzzle;
  int selectedWordIndex = 0;
  int selectedCharIndex = 0;

  RebusEngine({required this.puzzle}) {
    _initializeCursor();
    _checkInitialSolvedState();
  }

  void _initializeCursor() {
    for (int w = 0; w < puzzle.wordRows.length; w++) {
      final row = puzzle.wordRows[w];
      for (int c = 0; c < row.slots.length; c++) {
        if (!row.slots[c].isFixedSeparator && !row.slots[c].isLocked) {
          selectedWordIndex = w;
          selectedCharIndex = c;
          return;
        }
      }
    }
  }

  void _checkInitialSolvedState() {
    if (isCompleted) {
      puzzle.isSolved = true;
      _lockAllSlots();
    }
  }

  bool get isCompleted =>
      puzzle.playableSlots.every((s) => s.isCorrect);

  RebusSlot? get activeSlot {
    if (selectedWordIndex < puzzle.wordRows.length) {
      final row = puzzle.wordRows[selectedWordIndex];
      if (selectedCharIndex < row.slots.length) {
        return row.slots[selectedCharIndex];
      }
    }
    return null;
  }

  void selectSlot(int wordIdx, int charIdx) {
    if (wordIdx < puzzle.wordRows.length) {
      final row = puzzle.wordRows[wordIdx];
      if (charIdx < row.slots.length) {
        final slot = row.slots[charIdx];
        if (!slot.isFixedSeparator) {
          selectedWordIndex = wordIdx;
          selectedCharIndex = charIdx;
        }
      }
    }
  }

  RebusSolveResult? inputLetter(String letter) {
    final slot = activeSlot;
    if (slot == null || slot.isFixedSeparator || slot.isLocked) {
      _advanceCursor();
      return null;
    }

    slot.currentChar = letter.toUpperCase();

    RebusSolveResult? result;
    if (isCompleted) {
      puzzle.isSolved = true;
      _lockAllSlots();
      result = RebusSolveResult(
        puzzleCompleted: true,
        coinsEarned: 100,
        unlockedTrivia: puzzle.triviaFact,
        sources: puzzle.sources,
      );
    }

    _advanceCursor();
    return result;
  }

  void deleteLetter() {
    final slot = activeSlot;
    if (slot != null && !slot.isFixedSeparator && !slot.isLocked) {
      slot.currentChar = '';
    }
    _retreatCursor();
  }

  void _advanceCursor() {
    final flatPlayable = puzzle.playableSlots;
    final current = activeSlot;
    if (current == null) return;

    int idx = flatPlayable.indexOf(current);
    if (idx != -1 && idx + 1 < flatPlayable.length) {
      final next = flatPlayable[idx + 1];
      selectedWordIndex = next.wordIndex;
      selectedCharIndex = next.charIndex;
    }
  }

  void _retreatCursor() {
    final flatPlayable = puzzle.playableSlots;
    final current = activeSlot;
    if (current == null) return;

    int idx = flatPlayable.indexOf(current);
    if (idx > 0) {
      final prev = flatPlayable[idx - 1];
      selectedWordIndex = prev.wordIndex;
      selectedCharIndex = prev.charIndex;
    }
  }

  void _lockAllSlots() {
    for (final slot in puzzle.allSlots) {
      slot.isLocked = true;
    }
  }

  // --- 3-TIER HINT SHOP ---
  // Hint 1: Reveal first unsolved letter (50 Coins)
  bool revealFirstUnsolvedLetter() {
    if (isCompleted) return false;
    for (final slot in puzzle.playableSlots) {
      if (!slot.isCorrect) {
        slot.currentChar = slot.correctChar;
        slot.isRevealedByHint = true;
        slot.isLocked = true;
        _checkIfFinished();
        return true;
      }
    }
    return false;
  }

  // Hint 2: Reveal random unsolved letter (100 Coins)
  bool revealRandomUnsolvedLetter() {
    if (isCompleted) return false;
    final unsolved = puzzle.playableSlots.where((s) => !s.isCorrect).toList();
    if (unsolved.isEmpty) return false;

    final target = unsolved[Random().nextInt(unsolved.length)];
    target.currentChar = target.correctChar;
    target.isRevealedByHint = true;
    target.isLocked = true;
    _checkIfFinished();
    return true;
  }

  // Hint 3: Reveal entire title / puzzle (250 Coins)
  bool revealEntirePuzzle() {
    if (isCompleted) return false;
    for (final slot in puzzle.playableSlots) {
      slot.currentChar = slot.correctChar;
      slot.isRevealedByHint = true;
      slot.isLocked = true;
    }
    puzzle.isSolved = true;
    _lockAllSlots();
    return true;
  }

  void _checkIfFinished() {
    if (isCompleted) {
      puzzle.isSolved = true;
      _lockAllSlots();
    }
  }
}
