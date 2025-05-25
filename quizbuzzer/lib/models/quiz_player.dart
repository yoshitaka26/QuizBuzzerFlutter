import 'package:flutter/material.dart';

class QuizPlayer {
  final Color color;
  int correctCount = 0;
  int missCount = 0;
  bool buttonState = false;      // ボタンが押されているか
  bool errorState = false;       // 不正解状態か
  int? buttonNumber;             // 押した順番

  QuizPlayer({required this.color});

  void resetState() {
    buttonState = false;
    errorState = false;
    buttonNumber = null;
  }

  String get countString => buttonNumber?.toString() ?? '';
  
  String get scoreString {
    String text = '';
    if (correctCount > 0) text += '${correctCount}○';
    if (missCount > 0) text += '${missCount}×';
    return text;
  }
} 