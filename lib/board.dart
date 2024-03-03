import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/values.dart';

List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece = Piece(type: Tetromino.L);
  int currentScore = 0;
  late Mode mode;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      startGame();
    });
    super.initState();
  }

  void startGame() {
    List<bool> arg = ModalRoute.of(context)?.settings.arguments as List<bool>;
    print(arg);
    if (arg[0] == true) {
      mode = Mode.EASY;
    } else if (arg[1] == true) {
      mode = Mode.MEDIUM;
    } else if (arg[2] == true) {
      mode = Mode.HARD;
    }
    currentPiece.initializePiece();
    Duration frameRate;
    switch (mode) {
      case Mode.EASY:
        frameRate = const Duration(milliseconds: 500);
        break;
      case Mode.MEDIUM:
        frameRate = const Duration(milliseconds: 425);
        break;
      case Mode.HARD:
        frameRate = const Duration(milliseconds: 350);
        break;
    }
    gameLoop(frameRate);
  }

  late Timer timer;

  void gameLoop(Duration frameRate) {
    timer = Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          clearLine();
          checkLanding();
          currentPiece.movePiece(Direction.DOWN);
          if (gameBoard[0][4] != null) {
            timer.cancel();
            showGameOverDialog();
            setScore();
          }
        });
      },
    );
  }

  void showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        titlePadding: const EdgeInsets.fromLTRB(30, 30, 0, 20),
        contentPadding: const EdgeInsets.fromLTRB(30, 0, 0, 20),
        title: const Text('Game Over !!'),
        content: Text('Score: $currentScore'),
        actions: [
          TextButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                foregroundColor:
                    MaterialStatePropertyAll(Colors.redAccent.shade700),
                overlayColor: MaterialStatePropertyAll(Colors.pink.shade100),
                backgroundColor: MaterialStatePropertyAll(Colors.grey.shade200),
              ),
              onPressed: () {
                
                Navigator.pushReplacementNamed(context, '/', arguments: mode);
              },
              child: const Text("Restart game"))
        ],
      ),
    );
  }

  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;
      if (direction == Direction.LEFT) {
        col -= 1;
      } else if (direction == Direction.RIGHT) {
        col += 1;
      } else if (direction == Direction.DOWN) {
        row += 1;
      }
      if (row >= colLength ||
          col < 0 ||
          col >= rowLength ||
          (row >= 0 && gameBoard[row][col] != null)) {
        return true;
      }
    }
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.DOWN)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
  }

  void moveLeft() {
    if (!checkCollision(Direction.LEFT)) {
      setState(() {
        currentPiece.movePiece(Direction.LEFT);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.RIGHT)) {
      setState(() {
        currentPiece.movePiece(Direction.RIGHT);
      });
    }
  }

  void rotate() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void clearLine() {
    bool isFullLine;
    for (int row = colLength - 1; row >= 0; row--) {
      isFullLine = true;
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          isFullLine = false;
          break;
        }
      }
      if (isFullLine) {
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        gameBoard[0] = List.generate(rowLength, (index) => null);
        currentScore++;
      }
    }
  }

  @override
  void dispose() {
    resetGame();
    super.dispose();
  }

  void resetGame() {
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );
    timer.cancel();
    currentScore = 0;
  }

  void setScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (mode) {
      case Mode.EASY:
        if (prefs.containsKey("easy_score")) {
          int? lastScore = prefs.getInt("easy_score");
          if (currentScore > lastScore!) {
            prefs.setInt("easy_score", currentScore);
          }
        } else {
          prefs.setInt("easy_score", currentScore);
        }
        break;
      case Mode.MEDIUM:
        if (prefs.containsKey("medium_score")) {
          int? lastScore = prefs.getInt("medium_score");
          if (currentScore > lastScore!) {
            prefs.setInt("medium_score", currentScore);
          }
        } else {
          prefs.setInt("medium_score", currentScore);
        }
        break;
      case Mode.HARD:
        if (prefs.containsKey("hard_score")) {
          int? lastScore = prefs.getInt("hard_score");
          if (currentScore > lastScore!) {
            prefs.setInt("hard_score", currentScore);
          }
        } else {
          prefs.setInt("hard_score", currentScore);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Center(
            child: AspectRatio(
              aspectRatio: 3 / 5.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 12,
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: colLength * rowLength,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: rowLength,
                        ),
                        itemBuilder: (context, index) {
                          int row = (index / rowLength).floor();
                          int col = index % rowLength;
                          if (currentPiece.position.contains(index)) {
                            return Pixel(
                              color: currentPiece.color,
                            );
                          } else if (row < colLength &&
                              col < rowLength &&
                              gameBoard[row][col] != null) {
                            final Tetromino? tetrominoType =
                                gameBoard[row][col];
                            return Pixel(
                              color: tetrominoColors[tetrominoType]!,
                            );
                          } else {
                            return Pixel(
                              color: Colors.grey.shade900,
                            );
                          }
                        }),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: iconButton(Icons.arrow_left, moveLeft)),
                          Expanded(
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: FittedBox(
                                    child: Text(
                                      "Score: $currentScore",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 2,
                                    child:
                                        iconButton(Icons.rotate_left, rotate)),
                              ],
                            ),
                          ),
                          Expanded(
                              child: iconButton(Icons.arrow_right, moveRight))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget iconButton(IconData icon, VoidCallback function) {
    return FittedBox(
      child: IconButton(
        onPressed: function,
        splashColor: Colors.black,
        highlightColor: Colors.black,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
