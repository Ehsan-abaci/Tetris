
import 'package:flutter/material.dart';

int rowLength = 10;
int colLength = 15;

enum Direction {
  DOWN,
  RIGHT,
  LEFT,
}

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

enum Mode {
  EASY,
  MEDIUM,
  HARD,
}

Map<Tetromino, Color> tetrominoColors = {
  Tetromino.Z: Colors.red.shade800,
  Tetromino.L: Colors.blue.shade800,
  Tetromino.I: Colors.yellow.shade800,
  Tetromino.J: Colors.green.shade800,
  Tetromino.O: Colors.pink.shade800,
  Tetromino.T: Colors.purple.shade800,
  Tetromino.S: Colors.orange.shade800,
};
