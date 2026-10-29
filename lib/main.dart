import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/game_storage.dart';
import 'services/puzzle_loader.dart';
import 'ui/screens/home_screen.dart';
import 'ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock to comfortable portrait mode for crosswords
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize offline persistence and load pre-compiled puzzle manifests
  await GameStorage().init();
  await PuzzleLoader().loadAll();

  runApp(const ToonCrosswordsApp());
}

class ToonCrosswordsApp extends StatelessWidget {
  const ToonCrosswordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2000s Toon Crosswords',
      debugShowCheckedModeBanner: false,
      theme: ToonTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
