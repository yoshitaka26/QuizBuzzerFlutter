import 'package:audioplayers/audioplayers.dart';

enum SoundType {
  buzzer,
  correct,
  missed,
}

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final Map<SoundType, AudioPlayer> _players = {};
  bool _isSoundEnabled = false;

  bool get isSoundEnabled => _isSoundEnabled;

  void initialize() async {
    // 各音声用のプレイヤーを初期化
    for (SoundType soundType in SoundType.values) {
      _players[soundType] = AudioPlayer();
    }
  }

  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
  }

  Future<void> playSound(SoundType soundType) async {
    if (!_isSoundEnabled) return;

    final player = _players[soundType];
    if (player == null) return;

    String soundPath;
    switch (soundType) {
      case SoundType.buzzer:
        soundPath = 'sounds/buzzer.mp3';
        break;
      case SoundType.correct:
        soundPath = 'sounds/correct.mp3';
        break;
      case SoundType.missed:
        soundPath = 'sounds/missed.mp3';
        break;
    }

    try {
      await player.stop();
      await player.play(AssetSource(soundPath));
    } catch (e) {
      print('音声再生エラー: $e');
    }
  }

  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
} 