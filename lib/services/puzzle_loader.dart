import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/crossword_puzzle.dart';
import '../models/rebus_puzzle.dart';

class PuzzleManifest {
  final int crosswordCount;
  final int rebusCount;
  final int totalLevels;

  PuzzleManifest({
    required this.crosswordCount,
    required this.rebusCount,
    required this.totalLevels,
  });

  factory PuzzleManifest.fromJson(Map<String, dynamic> json) => PuzzleManifest(
    crosswordCount: (json['crosswordCount'] as int?) ?? 0,
    rebusCount: (json['rebusCount'] as int?) ?? 0,
    totalLevels: (json['totalLevels'] as int?) ?? 0,
  );
}

class PuzzleLoader {
  static final PuzzleLoader _instance = PuzzleLoader._internal();
  factory PuzzleLoader() => _instance;
  PuzzleLoader._internal();

  List<CrosswordPuzzle> _crosswords = [];
  List<RebusPuzzle> _rebusPuzzles = [];
  List<Map<String, dynamic>> _titles = [];
  PuzzleManifest? _manifest;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  List<CrosswordPuzzle> get crosswords => _crosswords;
  List<RebusPuzzle> get rebusPuzzles => _rebusPuzzles;
  List<Map<String, dynamic>> get titles => _titles;
  PuzzleManifest? get manifest => _manifest;

  Future<void> loadAll() async {
    if (_isLoaded) return;

    try {
      // 1. Load Manifest
      final manifestStr = await rootBundle.loadString('assets/puzzles/manifest.json');
      _manifest = PuzzleManifest.fromJson(json.decode(manifestStr));

      // 2. Load Crosswords
      final cwStr = await rootBundle.loadString('assets/puzzles/crossword_puzzles.json');
      final cwList = json.decode(cwStr) as List;
      _crosswords = cwList.map((j) => CrosswordPuzzle.fromJson(j as Map<String, dynamic>)).toList();

      // 3. Load Rebus
      final rebusStr = await rootBundle.loadString('assets/puzzles/rebus_puzzles.json');
      final rebusList = json.decode(rebusStr) as List;
      _rebusPuzzles = rebusList.map((j) => RebusPuzzle.fromJson(j as Map<String, dynamic>)).toList();

      // 4. Load Titles for Trophy Dex
      final titlesStr = await rootBundle.loadString('content/titles.json');
      _titles = List<Map<String, dynamic>>.from(json.decode(titlesStr) as List);

      _isLoaded = true;
    } catch (e) {
      // debugPrint fallback for test harnesses
    }
  }

  void loadFromRaw({
    required List<CrosswordPuzzle> crosswords,
    required List<RebusPuzzle> rebusPuzzles,
    required List<Map<String, dynamic>> titles,
  }) {
    _crosswords = crosswords;
    _rebusPuzzles = rebusPuzzles;
    _titles = titles;
    _manifest = PuzzleManifest(
      crosswordCount: crosswords.length,
      rebusCount: rebusPuzzles.length,
      totalLevels: crosswords.length + rebusPuzzles.length,
    );
    _isLoaded = true;
  }

  CrosswordPuzzle? getCrosswordByLevel(int level) {
    try {
      return _crosswords.firstWhere((p) => p.levelNumber == level);
    } catch (_) {
      return _crosswords.isNotEmpty ? _crosswords.first : null;
    }
  }

  RebusPuzzle? getRebusByLevel(int level) {
    try {
      return _rebusPuzzles.firstWhere((p) => p.levelNumber == level);
    } catch (_) {
      return _rebusPuzzles.isNotEmpty ? _rebusPuzzles.first : null;
    }
  }

  Map<String, dynamic>? getTitleById(String id) {
    try {
      return _titles.firstWhere((t) => t['id'] == id);
    } catch (_) {
      return null;
    }
  }
}
