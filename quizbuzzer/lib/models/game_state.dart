import 'package:flutter/material.dart';
import 'quiz_player.dart';

class GameState extends ChangeNotifier {
  static const List<Color> defaultColors = [
    Colors.red, Colors.orange, Colors.teal, Colors.green,
    Colors.blue, Colors.purple, Colors.pink, Colors.yellow
  ];

  List<QuizPlayer> _players = [];
  List<QuizPlayer> _tapList = [];
  int _playerCount = 4;
  int _nowOnAnswer = 1;
  int _answeredCount = 1;
  bool _isEnabledEndless = true;

  // getters
  List<QuizPlayer> get players => _players;
  int get playerCount => _playerCount;
  int get nowOnAnswer => _nowOnAnswer;
  bool get isEnabledEndless => _isEnabledEndless;
  bool get isResultButtonDisabled => _tapList.isEmpty;

  // プレイヤー初期化
  void createPlayers() {
    _players = defaultColors.take(8).map((color) => QuizPlayer(color: color)).toList();
    notifyListeners();
  }

  // プレイヤー数変更
  void setPlayerCount(int count) {
    _playerCount = count;
    notifyListeners();
  }

  // ボタンタップ処理
  void buttonTapped(int index) {
    if (index >= _playerCount) return;
    
    final player = _players[index];
    if (player.buttonState) return;

    player.buttonState = true;
    _tapList.add(player);
    player.buttonNumber = _answeredCount;
    _answeredCount++;
    
    notifyListeners();
  }

  // 正解処理
  void correctButtonTapped() {
    if (_tapList.isEmpty) return;
    
    final player = _tapList.first;
    player.correctCount++;
    resetButtonTapped();
  }

  // 不正解処理
  void incorrectButtonTapped() {
    if (_tapList.isEmpty) return;
    
    final player = _tapList.first;
    player.errorState = true;
    player.missCount++;
    _tapList.removeAt(0);
    _nowOnAnswer++;

    if (!_isEnabledEndless) {
      resetButtonTapped();
    }
    
    notifyListeners();
  }

  // リセット処理
  void resetButtonTapped() {
    for (var player in _players) {
      player.resetState();
    }
    _tapList.clear();
    _nowOnAnswer = 1;
    _answeredCount = 1;
    notifyListeners();
  }

  // エンドレスモード切り替え
  void toggleEndlessMode() {
    _isEnabledEndless = !_isEnabledEndless;
    notifyListeners();
  }

  // スコアリセット
  void resetScores() {
    for (var player in _players) {
      player.correctCount = 0;
      player.missCount = 0;
    }
    notifyListeners();
  }
} 