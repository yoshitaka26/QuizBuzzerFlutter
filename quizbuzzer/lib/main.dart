import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/game_state.dart';
import 'models/app_settings.dart';
import 'screens/main_screen.dart';
import 'services/sound_service.dart';
import 'services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // サービス初期化
  await PreferencesService().initialize();
  SoundService().initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GameState()..createPlayers(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppSettings()..loadSettings(),
        ),
      ],
      child: Consumer<AppSettings>(
        builder: (context, appSettings, child) {
          return MaterialApp(
            title: '早押しボタン',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: appSettings.isDarkMode ? Brightness.dark : Brightness.light,
              ),
              useMaterial3: true,
            ),
            home: MainScreen(),
          );
        },
      ),
    );
  }
}
