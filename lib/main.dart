import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/config.dart';
import 'logic/game_bloc.dart';
import 'models/rank_score.dart';
import 'screens/game.dart';
import 'utility.dart';

SharedPreferences? _sharedPreferences;
RankScore _rankScore = const RankScore(-1, 0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp();
  final String? user =
      _sharedPreferences?.getString(Config.sharedPreferencesUserIdKey);
  if (user != null) {
    final int? personalBest =
        _sharedPreferences?.getInt(Config.sharedPreferencesScoreKey);
    if (personalBest != null) {
      _rankScore = await EscapaUtility.getPlayerRankAndGlobalBest(personalBest);
    }
  }

  runApp(const EscapaApp());
}

class EscapaApp extends StatelessWidget {
  const EscapaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Escapa',
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: EscapaHome(),
      ),
    );
  }
}

class EscapaHome extends StatelessWidget {
  const EscapaHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBloc>(
      create: (_) => GameBloc(
        sharedPreferences: _sharedPreferences!,
        screenSize: MediaQuery.of(context).size,
        screenOrientation: MediaQuery.of(context).orientation,
        rankScore: _rankScore,
      ),
      child: const GameScreen(),
      lazy: false,
    );
  }
}
