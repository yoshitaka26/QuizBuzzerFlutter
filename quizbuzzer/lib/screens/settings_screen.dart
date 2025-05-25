import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/app_settings.dart';
import '../services/sound_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer2<GameState, AppSettings>(
        builder: (context, gameState, appSettings, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 早押し設定セクション
              _buildSectionHeader('早押し設定'),
              _buildPlayerCountSetting(gameState),
              _buildEndlessModeSetting(gameState),
              _buildSoundSetting(appSettings),
              _buildScoreResetSetting(context, gameState),
              
              const SizedBox(height: 24),
              
              // 表示設定セクション
              _buildSectionHeader('表示設定'),
              _buildTextSizeSetting(appSettings),
              _buildThemeSetting(appSettings),

              const SizedBox(height: 32),
              
              // クレジット表示
              const Center(
                child: Text(
                  '音声素材: OtoLogic',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildPlayerCountSetting(GameState gameState) {
    return ListTile(
      leading: const Icon(Icons.people),
      title: const Text('プレイヤー数'),
      trailing: DropdownButton<int>(
        value: gameState.playerCount,
        items: List.generate(6, (index) => index + 1)
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
    );
  }

  Widget _buildEndlessModeSetting(GameState gameState) {
    return SwitchListTile(
      secondary: const Icon(Icons.all_inclusive),
      title: const Text('エンドレスチャンス'),
      subtitle: const Text('不正解時に他のプレイヤーが続けて回答できます'),
      value: gameState.isEnabledEndless,
      onChanged: (value) => gameState.toggleEndlessMode(),
    );
  }

  Widget _buildSoundSetting(AppSettings appSettings) {
    return SwitchListTile(
      secondary: const Icon(Icons.volume_up),
      title: const Text('サウンド'),
      subtitle: const Text('効果音を再生します'),
      value: appSettings.isSoundEnabled,
      onChanged: (value) {
        appSettings.setSoundEnabled(value);
        SoundService().setSoundEnabled(value);
        appSettings.saveSettings();
      },
    );
  }

  Widget _buildTextSizeSetting(AppSettings appSettings) {
    return ListTile(
      leading: const Icon(Icons.text_fields),
      title: const Text('文字サイズ'),
      trailing: SegmentedButton<TextSizeOption>(
        segments: const [
          ButtonSegment<TextSizeOption>(
            value: TextSizeOption.small,
            icon: Icon(Icons.text_decrease),
          ),
          ButtonSegment<TextSizeOption>(
            value: TextSizeOption.medium,
            icon: Icon(Icons.text_increase),
          ),
        ],
        selected: {appSettings.textSize},
        onSelectionChanged: (Set<TextSizeOption> newSelection) {
          appSettings.setTextSize(newSelection.first);
          appSettings.saveSettings();
        },
      ),
    );
  }

  Widget _buildThemeSetting(AppSettings appSettings) {
    return SwitchListTile(
      secondary: Icon(appSettings.isDarkMode ? Icons.dark_mode : Icons.light_mode),
      title: const Text('ダークモード'),
      subtitle: const Text('画面を暗くします'),
      value: appSettings.isDarkMode,
      onChanged: (value) {
        appSettings.setDarkMode(value);
        appSettings.saveSettings();
      },
    );
  }

  Widget _buildScoreResetSetting(BuildContext context, GameState gameState) {
    return ListTile(
      leading: const Icon(Icons.refresh),
      title: const Text('スコアリセット'),
      subtitle: const Text('全プレイヤーのスコアをリセットします'),
      onTap: () => _showResetConfirmDialog(context, gameState),
    );
  }

  void _showResetConfirmDialog(BuildContext context, GameState gameState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('スコアをリセットしますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                gameState.resetScores();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('スコアをリセットしました')),
                );
              },
              child: const Text('リセット'),
            ),
          ],
        );
      },
    );
  }
} 