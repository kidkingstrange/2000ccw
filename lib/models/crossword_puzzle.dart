library;

/// Pure-Dart models for Crossword Puzzles
/// Completely decoupled from Flutter UI.

class CrosswordCell {
  final int row;
  final int col;
  final String correctLetter;
  String currentLetter;
  final int? clueNumber;
  bool isBlocked;
  bool isLocked;
  bool isRevealedByHint;

  CrosswordCell({
    required this.row,
    required this.col,
    required this.correctLetter,
    this.currentLetter = '',
    this.clueNumber,
    this.isBlocked = false,
    this.isLocked = false,
    this.isRevealedByHint = false,
  });

  bool get isFilled => currentLetter.isNotEmpty;
  bool get isCorrect => currentLetter.toUpperCase() == correctLetter.toUpperCase();

  Map<String, dynamic> toJson() => {
    'row': row,
    'col': col,
    'correctLetter': correctLetter,
    'currentLetter': currentLetter,
    'clueNumber': clueNumber,
    'isBlocked': isBlocked,
    'isLocked': isLocked,
    'isRevealedByHint': isRevealedByHint,
  };

  factory CrosswordCell.fromJson(Map<String, dynamic> json) => CrosswordCell(
    row: json['row'] as int,
    col: json['col'] as int,
    correctLetter: json['correctLetter'] as String,
    currentLetter: (json['currentLetter'] as String?) ?? '',
    clueNumber: json['clueNumber'] as int?,
    isBlocked: (json['isBlocked'] as bool?) ?? false,
    isLocked: (json['isLocked'] as bool?) ?? false,
    isRevealedByHint: (json['isRevealedByHint'] as bool?) ?? false,
  );
}

enum WordDirection { across, down }

class CrosswordWord {
  final String id;
  final int number;
  final String clue;
  final String answer;
  final WordDirection direction;
  final int startRow;
  final int startCol;
  final String titleId;
  final String network;
  bool isSolved;

  CrosswordWord({
    required this.id,
    required this.number,
    required this.clue,
    required this.answer,
    required this.direction,
    required this.startRow,
    required this.startCol,
    required this.titleId,
    required this.network,
    this.isSolved = false,
  });

  int get length => answer.length;

  List<Map<String, int>> get cellCoordinates {
    final coords = <Map<String, int>>[];
    for (int i = 0; i < length; i++) {
      if (direction == WordDirection.across) {
        coords.add({'row': startRow, 'col': startCol + i});
      } else {
        coords.add({'row': startRow + i, 'col': startCol});
      }
    }
    return coords;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'clue': clue,
    'answer': answer,
    'direction': direction.name,
    'startRow': startRow,
    'startCol': startCol,
    'titleId': titleId,
    'network': network,
    'isSolved': isSolved,
  };

  factory CrosswordWord.fromJson(Map<String, dynamic> json) => CrosswordWord(
    id: json['id'] as String,
    number: json['number'] as int,
    clue: json['clue'] as String,
    answer: json['answer'] as String,
    direction: json['direction'] == 'across' ? WordDirection.across : WordDirection.down,
    startRow: json['startRow'] as int,
    startCol: json['startCol'] as int,
    titleId: json['titleId'] as String,
    network: (json['network'] as String?) ?? 'Cartoon Network',
    isSolved: (json['isSolved'] as bool?) ?? false,
  );
}

class CrosswordPuzzle {
  final String id;
  final int levelNumber;
  final String title;
  final String network;
  final String difficulty; // Easy, Medium, Hard, Expert
  final int rows;
  final int cols;
  final List<CrosswordWord> words;
  final Map<String, CrosswordCell> grid; // key: "row,col"

  CrosswordPuzzle({
    required this.id,
    required this.levelNumber,
    required this.title,
    required this.network,
    required this.difficulty,
    required this.rows,
    required this.cols,
    required this.words,
    required this.grid,
  });

  CrosswordCell? getCell(int row, int col) => grid['$row,$col'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'levelNumber': levelNumber,
    'title': title,
    'network': network,
    'difficulty': difficulty,
    'rows': rows,
    'cols': cols,
    'words': words.map((w) => w.toJson()).toList(),
    'cells': grid.values.map((c) => c.toJson()).toList(),
  };

  factory CrosswordPuzzle.fromJson(Map<String, dynamic> json) {
    final wordsList = (json['words'] as List)
        .map((w) => CrosswordWord.fromJson(w as Map<String, dynamic>))
        .toList();

    final gridMap = <String, CrosswordCell>{};
    if (json['cells'] != null) {
      for (final cellJson in (json['cells'] as List)) {
        final cell = CrosswordCell.fromJson(cellJson as Map<String, dynamic>);
        gridMap['${cell.row},${cell.col}'] = cell;
      }
    }

    return CrosswordPuzzle(
      id: json['id'] as String,
      levelNumber: json['levelNumber'] as int,
      title: json['title'] as String,
      network: (json['network'] as String?) ?? 'Cartoon Network',
      difficulty: (json['difficulty'] as String?) ?? 'Easy',
      rows: json['rows'] as int,
      cols: json['cols'] as int,
      words: wordsList,
      grid: gridMap,
    );
  }
}
