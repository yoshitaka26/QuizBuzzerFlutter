import 'package:flutter/material.dart';
import '../models/game_state.dart';

class BuzzerButton extends StatelessWidget {
  final QuizPlayer player;
  final int? answerNumber;
  final VoidCallback onTap;
  final int playerCount;
  final double? fontSize;

  const BuzzerButton({
    Key? key,
    required this.player,
    required this.answerNumber,
    required this.onTap,
    required this.playerCount,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: player.color,
          shape: BoxShape.circle,
          border: Border.all(
            color: (answerNumber == player.buttonNumber) 
                ? (isDarkMode ? Colors.white : Colors.black)
                : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
          ],
        ),
        child: Center(
          child: Text(
            // 1人プレイ時は数字を表示しない
            (playerCount == 1) ? '' : player.countString,
            style: TextStyle(
              fontSize: fontSize ?? 36,
              fontWeight: FontWeight.bold,
              color: player.errorState ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
} 