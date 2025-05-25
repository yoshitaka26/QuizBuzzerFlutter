import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

enum TextSizeOption {
  small(0, 'small', 14.0),
  medium(1, 'medium', 18.0);

  const TextSizeOption(this.value, this.label, this.fontSize);
  final int value;
  final String label;
  final double fontSize;

  static TextSizeOption fromValue(int value) {
    return TextSizeOption.values.firstWhere(
      (option) => option.value == value,
      orElse: () => TextSizeOption.small,
    );
  }
}

class AppSettings extends ChangeNotifier {
  bool _isSoundEnabled = true;
  TextSizeOption _textSize = TextSizeOption.small;
  bool _isDarkMode = false;

  bool get isSoundEnabled => _isSoundEnabled;
  TextSizeOption get textSize => _textSize;
  bool get isDarkMode => _isDarkMode;

  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
    notifyListeners();
  }

  void setTextSize(TextSizeOption size) {
    _textSize = size;
    notifyListeners();
  }

  void setDarkMode(bool enabled) {
    _isDarkMode = enabled;
    notifyListeners();
  }

  // 設定の読み込み
  Future<void> loadSettings() async {
    final prefs = PreferencesService();
    _isSoundEnabled = prefs.getSoundEnabled();
    _textSize = TextSizeOption.fromValue(prefs.getTextSize());
    _isDarkMode = prefs.getDarkMode();
    notifyListeners();
  }

  // 設定の保存
  Future<void> saveSettings() async {
    final prefs = PreferencesService();
    await prefs.setSoundEnabled(_isSoundEnabled);
    await prefs.setTextSize(_textSize.value);
    await prefs.setDarkMode(_isDarkMode);
  }
} 