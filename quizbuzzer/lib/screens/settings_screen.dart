import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // プレイヤー数設定
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('プレイヤー数'),
                trailing: DropdownButton<int>(
                  value: gameState.playerCount,
                  items: List.generate(8, (index) => index + 1)
                      .map((count) => DropdownMenuItem<int>(
                            value: count,
                            child: Text('$count'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      gameState.setPlayerCount(value);
                    }
                  },
                ),
              ),
              // エンドレスモード
              SwitchListTile(
                secondary: const Icon(Icons.all_inclusive),
                title: const Text('エンドレスチャンス'),
                subtitle: const Text('不正解時に他のプレイヤーが続けて回答できます'),
                value: gameState.isEnabledEndless,
                onChanged: (value) => gameState.toggleEndlessMode(),
              ),
              // スコアリセット
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('スコアリセット'),
                onTap: () {
                  gameState.resetScores();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('スコアをリセットしました')),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
} 