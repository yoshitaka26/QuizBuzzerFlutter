import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class QuizPlayer {
  final Color color;
  bool buttonState;
  bool errorState;
  int buttonNumber;
  int correctCount;
  int missCount;

  QuizPlayer({
    required this.color,
    this.buttonState = false,
    this.errorState = false,
    this.buttonNumber = 0,
    this.correctCount = 0,
    this.missCount = 0,
  });

  String get countString => buttonNumber > 0 ? '$buttonNumber' : '';
  String get scoreString {
    if (correctCount == 0 && missCount == 0) return '';
    final correct = correctCount > 0 ? '○${correctCount}' : '';
    final miss = missCount > 0 ? '×${missCount}' : '';
    return [correct, miss].where((s) => s.isNotEmpty).join(' ');
  }
}

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
  final SoundService _soundService = SoundService();

  // getters
  List<QuizPlayer> get players => _players;
  int get playerCount => _playerCount;
  int get nowOnAnswer => _nowOnAnswer;
  bool get isEnabledEndless => _isEnabledEndless;
  bool get isResultButtonDisabled => _tapList.isEmpty;

  // プレイヤー初期化
  void createPlayers() {
    _players.clear();
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    for (int i = 0; i < _playerCount; i++) {
      _players.add(QuizPlayer(color: colors[i]));
    }
    notifyListeners();
  }

  // プレイヤー数変更
  void setPlayerCount(int count) {
    if (count < 1 || count > 6) return;
    _playerCount = count;
    createPlayers();
  }

  // ボタンタップ処理
  void buttonTapped(int index) {
    if (index >= _playerCount) return;
    
    final player = _players[index];
    if (player.buttonState) return;

    // 音声再生
    _soundService.playSound(SoundType.buzzer);

    player.buttonState = true;
    _tapList.add(player);
    player.buttonNumber = _answeredCount;
    _answeredCount++;
    
    notifyListeners();
  }

  // 正解処理
  void correctButtonTapped() {
    if (_tapList.isEmpty) return;
    
    // 音声再生
    _soundService.playSound(SoundType.correct);
    
    final player = _tapList.first;
    player.correctCount++;
    resetButtonTapped();
  }

  // 不正解処理
  void incorrectButtonTapped() {
    if (_tapList.isEmpty) return;
    
    // 音声再生
    _soundService.playSound(SoundType.missed);
    
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
      player.buttonState = false;
      player.errorState = false;
      player.buttonNumber = 0;
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