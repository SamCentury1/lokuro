import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lokuro/providers/animation_state.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/screens/game_screen/game_screen.dart';
import 'package:lokuro/screens/home_screen/home_screen.dart';
import 'package:lokuro/settings/persistence/local_storage_settings_persistence.dart';
import 'package:lokuro/settings/persistence/settings_persistence.dart';
import 'package:lokuro/settings/settings_controller.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(
    settingsPersistence: LocalStorageSettingsPersistence(),
  ));
}

class MyApp extends StatelessWidget {
  final SettingsPersistence settingsPersistence;
  const MyApp({
    super.key,
    required this.settingsPersistence
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GamePlayState()),
        ChangeNotifierProvider(create: (_) => SettingsState()),
        ChangeNotifierProvider(create: (_) => AnimationState()),
        Provider<SettingsController>(
          lazy: false,
          create: (context) => SettingsController(
            persistence: settingsPersistence
          )..loadStateFromPersistance(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}


