import 'package:flutter/material.dart';
import 'package:tetris/board.dart';
import 'package:tetris/values.dart';

class Piece {
  Tetromino type;

  Piece({required this.type});

  List<int> position = [];

  Color get color {
    return tetrominoColors[type] ?? const Color(0xFFFFFFFF);
  }

  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetromino.I:
        position = [-7, -6, -5, -4];
        break;
      case Tetromino.J:
        position = [-25, -15, -5, -6];
        break;
      case Tetromino.O:
        position = [-16, -15, -6, -5];
        break;
      case Tetromino.S:
        position = [-15, -16, -7, -6];
        break;
      case Tetromino.T:
        position = [-26, -16, -15, -6];
        break;
      case Tetromino.Z:
        position = [-17, -16, -6, -5];
        break;
      default:
    }
  }

  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.DOWN:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.LEFT:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.RIGHT:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
    }
  }

  int rotateState = 1;

  void rotatePiece() {
    print(rotateState);
    List<int> newPosition = [];
    switch (type) {
      case Tetromino.L:
        switch (rotateState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }

            break;
          case 3:
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }
            break;
        }
      case Tetromino.J:
        switch (rotateState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] - rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }

            break;
          case 3:
            newPosition = [
              position[1] + rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }
            break;
        }
      case Tetromino.I:
        switch (rotateState) {
          case 0:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 2;
            }
            break;
          case 1:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + (2 * rowLength),
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 2;
            }
            break;
        }
      case Tetromino.S:
        switch (rotateState) {
          case 0:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 2;
            }
            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + rowLength,
              position[1] - rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 2;
            }
            break;
        }
      case Tetromino.Z:
        switch (rotateState) {
          case 0:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 2;
            }
            break;
          case 1:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] + rowLength,
              position[1] - rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 2;
            }
            break;
        }
      case Tetromino.T:
        switch (rotateState) {
          case 0:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - rowLength,
              position[1] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] - rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] - 1,
              position[1] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }

            break;
          case 3:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + rowLength,
              position[1] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }
            break;
        }
        break;
      default:
    }
  }

  bool positionIsValid(int position) {
    int row = (position / rowLength).floor();
    int col = position % rowLength;

    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }
    return true;
  }

  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstCol = false;
    bool lastCol = false;
    for (int pos in piecePosition) {
      if (!positionIsValid(pos)) {
        return false;
      }
      int col = pos % rowLength;
      if (col == 0) {
        firstCol = true;
      }
      if (col == rowLength - 1) {
        lastCol = true;
      }
    }
    return !(firstCol && lastCol);
  }
}
