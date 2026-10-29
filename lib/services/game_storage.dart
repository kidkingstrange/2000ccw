import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Pure-Dart offline persistence service handling coins, progression, streaks,
/// and unlocked Trophy Dex trivia cards with in-memory reactivity.
class GameStorage extends ChangeNotifier {
  static final GameStorage _instance = GameStorage._internal();
  factory GameStorage() => _instance;
  GameStorage._internal();

  int _coins = 100; // Starter balance: 100 Coins
  final Set<String> _solvedLevelIds = {};
  final Map<String, int> _levelStars = {}; // levelId -> stars (1..3)
  final Set<String> _unlockedDexCardIds = {}; // titleId
  int _dailyStreak = 1;
  String _lastPlayedDate = '';
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;

  File? _storageFile;
  bool _isInitialized = false;

  int get coins => _coins;
  Set<String> get solvedLevelIds => Set.unmodifiable(_solvedLevelIds);
  Set<String> get unlockedDexCardIds => Set.unmodifiable(_unlockedDexCardIds);
  int get dailyStreak => _dailyStreak;
  bool get soundEnabled => _soundEnabled;
  bool get hapticsEnabled => _hapticsEnabled;

  int getStars(String levelId) => _levelStars[levelId] ?? 0;
  bool isLevelSolved(String levelId) => _solvedLevelIds.contains(levelId);
  bool isDexCardUnlocked(String titleId) => _unlockedDexCardIds.contains(titleId);

  /// Initializes storage with local file or test fallback
  Future<void> init([File? customFile]) async {
    if (_isInitialized && customFile == null) return;
    _storageFile = customFile;

    if (_storageFile != null && await _storageFile!.exists()) {
      try {
        final content = await _storageFile!.readAsString();
        final data = json.decode(content) as Map<String, dynamic>;
        _coins = (data['coins'] as int?) ?? 100;
        _dailyStreak = (data['dailyStreak'] as int?) ?? 1;
        _lastPlayedDate = (data['lastPlayedDate'] as String?) ?? '';
        _soundEnabled = (data['soundEnabled'] as bool?) ?? true;
        _hapticsEnabled = (data['hapticsEnabled'] as bool?) ?? true;

        if (data['solvedLevels'] is List) {
          _solvedLevelIds.addAll(List<String>.from(data['solvedLevels']));
        }
        if (data['levelStars'] is Map) {
          (data['levelStars'] as Map).forEach((k, v) {
            _levelStars[k.toString()] = v as int;
          });
        }
        if (data['unlockedDexCards'] is List) {
          _unlockedDexCardIds.addAll(List<String>.from(data['unlockedDexCards']));
        }
      } catch (e) {
        debugPrint('Error reading storage file: $e');
      }
    }
    _checkDailyStreak();
    _isInitialized = true;
    notifyListeners();
  }

  void _checkDailyStreak() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (_lastPlayedDate.isEmpty) {
      _lastPlayedDate = today;
      _dailyStreak = 1;
    } else if (_lastPlayedDate != today) {
      final lastDate = DateTime.tryParse(_lastPlayedDate);
      if (lastDate != null) {
        final difference = DateTime.now().difference(lastDate).inDays;
        if (difference == 1) {
          _dailyStreak += 1;
        } else if (difference > 1) {
          _dailyStreak = 1;
        }
      }
      _lastPlayedDate = today;
    }
  }

  /// Sequential Progression: Level 1 unlocked by default; Level N requires Level N-1 cleared
  bool isLevelUnlocked(int levelNumber, String modePrefix) {
    if (levelNumber <= 1) return true;
    final prevLevelId = '$modePrefix-${(levelNumber - 1).toString().padLeft(3, '0')}';
    return _solvedLevelIds.contains(prevLevelId);
  }

  void addCoins(int amount) {
    _coins += amount;
    _save();
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      _save();
      notifyListeners();
      return true;
    }
    return false;
  }

  void completeLevel(String levelId, int stars, {int bonusCoins = 200, String? titleId}) {
    _solvedLevelIds.add(levelId);
    final currentStars = _levelStars[levelId] ?? 0;
    if (stars > currentStars) {
      _levelStars[levelId] = stars;
    }
    _coins += bonusCoins;
    if (titleId != null && titleId.isNotEmpty) {
      _unlockedDexCardIds.add(titleId);
    }
    _save();
    notifyListeners();
  }

  void unlockDexCard(String titleId) {
    if (titleId.isNotEmpty && !_unlockedDexCardIds.contains(titleId)) {
      _unlockedDexCardIds.add(titleId);
      _save();
      notifyListeners();
    }
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    _save();
    notifyListeners();
  }

  void toggleHaptics() {
    _hapticsEnabled = !_hapticsEnabled;
    _save();
    notifyListeners();
  }

  void resetProgress() {
    _coins = 100;
    _solvedLevelIds.clear();
    _levelStars.clear();
    _unlockedDexCardIds.clear();
    _dailyStreak = 1;
    _save();
    notifyListeners();
  }

  int get totalStarsEarned =>
      _levelStars.values.fold(0, (sum, val) => sum + val);

  double calculateCompletion(int totalLevels) {
    if (totalLevels <= 0) return 0.0;
    return (_solvedLevelIds.length / totalLevels).clamp(0.0, 1.0);
  }

  Future<void> _save() async {
    if (_storageFile == null) return;
    try {
      final payload = {
        'coins': _coins,
        'dailyStreak': _dailyStreak,
        'lastPlayedDate': _lastPlayedDate,
        'soundEnabled': _soundEnabled,
        'hapticsEnabled': _hapticsEnabled,
        'solvedLevels': _solvedLevelIds.toList(),
        'levelStars': _levelStars,
        'unlockedDexCards': _unlockedDexCardIds.toList(),
      };
      await _storageFile!.writeAsString(json.encode(payload), flush: true);
    } catch (e) {
      debugPrint('Error saving game storage: $e');
    }
  }
}
