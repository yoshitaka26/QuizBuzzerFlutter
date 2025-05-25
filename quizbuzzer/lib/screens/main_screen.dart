import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/buzzer_button.dart';
import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          _buildControlButtons(context),
          const SizedBox(height: 20),
          // 早押しボタンエリア
          Expanded(child: _buildPlayerButtons(context)),
        ],
      ),
    );
  }

  Widget _buildControlButtons(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 正解ボタン
              ElevatedButton(
                onPressed: gameState.isResultButtonDisabled ? null : gameState.correctButtonTapped,
                child: const Icon(Icons.circle_outlined, size: 30),
              ),
              // 不正解ボタン
              ElevatedButton(
                onPressed: gameState.isResultButtonDisabled ? null : gameState.incorrectButtonTapped,
                child: const Icon(Icons.close, size: 30),
              ),
              // リセットボタン
              ElevatedButton(
                onPressed: gameState.resetButtonTapped,
                child: const Icon(Icons.refresh, size: 30),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayerButtons(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        if (gameState.playerCount == 1) {
          return _buildSinglePlayerView(gameState);
        } else {
          return _buildMultiPlayerView(gameState);
        }
      },
    );
  }

  Widget _buildSinglePlayerView(GameState gameState) {
    final player = gameState.players[0];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            player.scoreString,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          BuzzerButton(
            player: player,
            answerNumber: gameState.nowOnAnswer,
            playerCount: gameState.playerCount,
            onTap: () => gameState.buttonTapped(0),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiPlayerView(GameState gameState) {
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            BuzzerButton(
              player: player,
              answerNumber: gameState.nowOnAnswer,
              playerCount: gameState.playerCount,
              onTap: () => gameState.buttonTapped(index),
            ),
          ],
        );
      },
    );
  }
} 