import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/player_details_screen.dart';
import 'screens/match_analysis_screen.dart';
import 'screens/team_builder_screen.dart';
import 'screens/live_match_screen.dart';
import 'screens/main_navigation.dart';
import 'utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const DreamIQApp());
}

class DreamIQApp extends StatelessWidget {
  const DreamIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DreamIQ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: const MainNavigation(),
      routes: {
        '/player-details': (context) => const PlayerDetailsScreen(),
        '/match-analysis': (context) => const MatchAnalysisScreen(),
        '/team-builder': (context) => const TeamBuilderScreen(),
        '/live-match': (context) => const LiveMatchScreen(),
      },
    );
  }
}
