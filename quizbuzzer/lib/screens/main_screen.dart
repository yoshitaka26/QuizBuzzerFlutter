import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/app_settings.dart';
import '../widgets/buzzer_button.dart';
import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, appSettings, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('早押しボタン'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // 上部コントロールボタン
              _buildControlButtons(context, appSettings),
              const SizedBox(height: 20),
              // 早押しボタンエリア
              Expanded(child: _buildPlayerButtons(context, appSettings)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlButtons(BuildContext context, AppSettings appSettings) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 正解ボタン
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: gameState.isResultButtonDisabled ? null : gameState.correctButtonTapped,
                    icon: const Icon(Icons.circle_outlined, size: 30),
                    label: const Text(''),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
              ),
              // 不正解ボタン
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: gameState.isResultButtonDisabled ? null : gameState.incorrectButtonTapped,
                    icon: const Icon(Icons.close, size: 30),
                    label: const Text(''),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
              ),
              // リセットボタン
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: gameState.resetButtonTapped,
                    icon: const Icon(Icons.refresh, size: 30),
                    label: const Text(''),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayerButtons(BuildContext context, AppSettings appSettings) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        if (gameState.playerCount == 1) {
          return _buildSinglePlayerView(gameState, appSettings);
        } else {
          return _buildMultiPlayerView(gameState, appSettings);
        }
      },
    );
  }

  Widget _buildSinglePlayerView(GameState gameState, AppSettings appSettings) {
    final player = gameState.players[0];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            player.scoreString,
            style: TextStyle(
              fontSize: appSettings.textSize.fontSize + 4,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          BuzzerButton(
            player: player,
            answerNumber: gameState.nowOnAnswer,
            playerCount: gameState.playerCount,
            fontSize: appSettings.textSize.fontSize + 20,
            onTap: () => gameState.buttonTapped(0),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiPlayerView(GameState gameState, AppSettings appSettings) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: gameState.playerCount,
      itemBuilder: (context, index) {
        final player = gameState.players[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              player.scoreString,
              style: TextStyle(
                fontSize: appSettings.textSize.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            BuzzerButton(
              player: player,
              answerNumber: gameState.nowOnAnswer,
              playerCount: gameState.playerCount,
              fontSize: appSettings.textSize.fontSize + 16,
              onTap: () => gameState.buttonTapped(index),
            ),
          ],
        );
      },
    );
  }
} 