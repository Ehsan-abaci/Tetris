import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetris/board.dart';
import 'package:tetris/start_menu.dart';

int? bestScore;


void main() {
   WidgetsFlutterBinding.ensureInitialized();
  getBestScore().then((_) {
    runApp(const MyApp());
  });
}
Future<void> getBestScore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bestScore = prefs.getInt("medium_score") ?? 0;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tetris Game',
      initialRoute: '/',
      routes: {
        "/": (context) => StartMenu(bestScore: bestScore!),
        "/board": (context) => const GameBoard(),
      },
    );
  }
}
