import 'package:flutter_test/flutter_test.dart';
import 'package:toon_crosswords/main.dart';
import 'package:toon_crosswords/services/game_storage.dart';
import 'package:toon_crosswords/services/puzzle_loader.dart';
import 'package:toon_crosswords/models/crossword_puzzle.dart';
import 'package:toon_crosswords/models/rebus_puzzle.dart';

void main() {
  setUp(() async {
    // Populate mock in-memory data for test harness
    final w1 = CrosswordWord(
      id: 'w1',
      number: 1,
      clue: 'Hero with Omnitrix',
      answer: 'BEN',
      direction: WordDirection.across,
      startRow: 0,
      startCol: 0,
      titleId: 'ben-10',
      network: 'Cartoon Network',
    );
    final cw = CrosswordPuzzle(
      id: 'cw-001',
      levelNumber: 1,
      title: 'Level 1 • Cartoon Network',
      network: 'Cartoon Network',
      difficulty: 'Easy',
      rows: 3,
      cols: 3,
      words: [w1],
      grid: {
        '0,0': CrosswordCell(row: 0, col: 0, correctLetter: 'B'),
        '0,1': CrosswordCell(row: 0, col: 1, correctLetter: 'E'),
        '0,2': CrosswordCell(row: 0, col: 2, correctLetter: 'N'),
      },
    );

    final rebus = RebusPuzzle.fromJson({
      'id': 'rebus-001',
      'levelNumber': 1,
      'titleId': 'ben-10',
      'fullTitle': 'BEN 10',
      'network': 'Cartoon Network',
      'hintText': 'Hero with watch',
      'emojis': ['👦', '⌚'],
      'triviaFact': 'Original omnitrix trivia',
      'sources': ['https://wiki.org'],
      'isSolved': false,
    });

    PuzzleLoader().loadFromRaw(
      crosswords: [cw],
      rebusPuzzles: [rebus],
      titles: [
        {
          'id': 'ben-10',
          'title': 'Ben 10',
          'network': 'Cartoon Network',
          'year': 2005,
          'facts': [
            {'text': 'Original omnitrix trivia', 'sources': ['https://wiki.org', 'https://tmdb.org']}
          ],
          'emojiCandidates': ['👦', '⌚']
        }
      ],
    );

    await GameStorage().init();
  });

  testWidgets('Home Screen Smoke & Navigation Test', (WidgetTester tester) async {
    await tester.pumpWidget(const ToonCrosswordsApp());
    await tester.pumpAndSettle();

    // Verify Title and elements
    expect(find.text('2000s TOON CROSSWORDS'), findsOneWidget);
    expect(find.text('QUICK PLAY (NEXT PUZZLE)'), findsOneWidget);
    expect(find.text('TROPHY HALL / DEX'), findsOneWidget);

    // Verify Coin display
    expect(find.text('100'), findsOneWidget); // starter coins
  });
}
