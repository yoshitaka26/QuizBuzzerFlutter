import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // プレイヤー数
  int getPlayerCount() => _prefs?.getInt('playerCount') ?? 4;
  Future<void> setPlayerCount(int count) async => 
      await _prefs?.setInt('playerCount', count);

  // エンドレスモード
  bool getEndlessMode() => _prefs?.getBool('endlessMode') ?? true;
  Future<void> setEndlessMode(bool enabled) async => 
      await _prefs?.setBool('endlessMode', enabled);

  // サウンド設定
  bool getSoundEnabled() => _prefs?.getBool('soundEnabled') ?? true;
  Future<void> setSoundEnabled(bool enabled) async => 
      await _prefs?.setBool('soundEnabled', enabled);

  // 文字サイズ設定
  int getTextSize() => _prefs?.getInt('textSize') ?? 0; // 0=小, 1=中
  Future<void> setTextSize(int size) async => 
      await _prefs?.setInt('textSize', size);

  // テーマ設定
  bool getDarkMode() => _prefs?.getBool('darkMode') ?? false;
  Future<void> setDarkMode(bool enabled) async => 
      await _prefs?.setBool('darkMode', enabled);
} 