library;

/// Pure-Dart models for Emoji & Icon Title Rebus Puzzles
/// Completely decoupled from Flutter UI.

class RebusSlot {
  final int wordIndex;
  final int charIndex;
  final String correctChar;
  String currentChar;
  final bool isFixedSeparator; // e.g. '-', ''', ':', '!'
  bool isLocked;
  bool isRevealedByHint;

  RebusSlot({
    required this.wordIndex,
    required this.charIndex,
    required this.correctChar,
    this.currentChar = '',
    this.isFixedSeparator = false,
    this.isLocked = false,
    this.isRevealedByHint = false,
  });

  bool get isFilled => isFixedSeparator || currentChar.isNotEmpty;
  bool get isCorrect =>
      isFixedSeparator || currentChar.toUpperCase() == correctChar.toUpperCase();

  Map<String, dynamic> toJson() => {
    'wordIndex': wordIndex,
    'charIndex': charIndex,
    'correctChar': correctChar,
    'currentChar': currentChar,
    'isFixedSeparator': isFixedSeparator,
    'isLocked': isLocked,
    'isRevealedByHint': isRevealedByHint,
  };

  factory RebusSlot.fromJson(Map<String, dynamic> json) => RebusSlot(
    wordIndex: json['wordIndex'] as int,
    charIndex: json['charIndex'] as int,
    correctChar: json['correctChar'] as String,
    currentChar: (json['currentChar'] as String?) ?? '',
    isFixedSeparator: (json['isFixedSeparator'] as bool?) ?? false,
    isLocked: (json['isLocked'] as bool?) ?? false,
    isRevealedByHint: (json['isRevealedByHint'] as bool?) ?? false,
  );
}

class RebusWordRow {
  final int index;
  final String word;
  final List<RebusSlot> slots;

  RebusWordRow({
    required this.index,
    required this.word,
    required this.slots,
  });

  bool get isSolved => slots.every((s) => s.isCorrect);

  Map<String, dynamic> toJson() => {
    'index': index,
    'word': word,
    'slots': slots.map((s) => s.toJson()).toList(),
  };

  factory RebusWordRow.fromJson(Map<String, dynamic> json) => RebusWordRow(
    index: json['index'] as int,
    word: json['word'] as String,
    slots: (json['slots'] as List)
        .map((s) => RebusSlot.fromJson(s as Map<String, dynamic>))
        .toList(),
  );
}

class RebusPuzzle {
  final String id;
  final int levelNumber;
  final String titleId;
  final String fullTitle;
  final String network;
  final String hintText;
  final List<String> emojis;
  final List<RebusWordRow> wordRows;
  final String triviaFact;
  final List<String> sources;
  bool isSolved;

  RebusPuzzle({
    required this.id,
    required this.levelNumber,
    required this.titleId,
    required this.fullTitle,
    required this.network,
    required this.hintText,
    required this.emojis,
    required this.wordRows,
    required this.triviaFact,
    required this.sources,
    this.isSolved = false,
  });

  String get mysteryDisplayTitle => isSolved ? fullTitle : 'Level $levelNumber • Rebus';

  List<RebusSlot> get allSlots =>
      wordRows.expand((row) => row.slots).toList();

  List<RebusSlot> get playableSlots =>
      allSlots.where((s) => !s.isFixedSeparator).toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'levelNumber': levelNumber,
    'titleId': titleId,
    'fullTitle': fullTitle,
    'network': network,
    'hintText': hintText,
    'emojis': emojis,
    'wordRows': wordRows.map((r) => r.toJson()).toList(),
    'triviaFact': triviaFact,
    'sources': sources,
    'isSolved': isSolved,
  };

  factory RebusPuzzle.fromJson(Map<String, dynamic> json) {
    List<RebusWordRow> parsedRows = [];
    if (json['wordRows'] != null) {
      parsedRows = (json['wordRows'] as List)
          .map((r) => RebusWordRow.fromJson(r as Map<String, dynamic>))
          .toList();
    } else {
      // Build word rows dynamically from fullTitle if not explicitly in JSON
      final title = json['fullTitle'] as String;
      final words = title.split(' ');
      for (int w = 0; w < words.length; w++) {
        final wordStr = words[w];
        final slots = <RebusSlot>[];
        for (int c = 0; c < wordStr.length; c++) {
          final ch = wordStr[c];
          final isPunct = !RegExp(r'[A-Za-z0-9]').hasMatch(ch);
          slots.add(RebusSlot(
            wordIndex: w,
            charIndex: c,
            correctChar: ch.toUpperCase(),
            currentChar: isPunct ? ch : '',
            isFixedSeparator: isPunct,
            isLocked: isPunct,
          ));
        }
        parsedRows.add(RebusWordRow(index: w, word: wordStr, slots: slots));
      }
    }

    return RebusPuzzle(
      id: json['id'] as String,
      levelNumber: json['levelNumber'] as int,
      titleId: json['titleId'] as String,
      fullTitle: json['fullTitle'] as String,
      network: (json['network'] as String?) ?? 'Cartoon Network',
      hintText: (json['hintText'] as String?) ?? '',
      emojis: List<String>.from(json['emojis'] as List),
      wordRows: parsedRows,
      triviaFact: (json['triviaFact'] as String?) ?? '',
      sources: List<String>.from((json['sources'] as List?) ?? []),
      isSolved: (json['isSolved'] as bool?) ?? false,
    );
  }
}
