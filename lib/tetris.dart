import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:games_app/piece.dart';
import 'package:games_app/pixel.dart';
import 'package:games_app/values.dart';

List<List<Tetromino?>> gameBoard =
    List.generate(columnLength, (i) => List.generate(rowLength, (j) => null));

class Tetris extends StatefulWidget {
  const Tetris({super.key});

  @override
  State<Tetris> createState() => _TetrisState();
}

class _TetrisState extends State<Tetris> {
  Piece currentPiece = Piece(type: Tetromino.L);
  Timer? _timer = null;
  int currentScore = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void startGame() {
    currentPiece.initializePiece();

    Duration frameRate = const Duration(milliseconds: 300);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    if (mounted) {
      _timer = Timer.periodic(frameRate, (timer) {
        setState(() {
          clearLines();
          checkLanding();
          if (gameOver) {
            timer.cancel();
            showGameOverDialog();
          }
          currentPiece.movePiece(Direction.down);
        });
      });
    }
  }

  void showGameOverDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('Your score: $currentScore'),
            actions: [
              TextButton(
                onPressed: () {
                  resetGame();
                  Navigator.pop(context);
                },
                child: Text('Play Again'),
              )
            ],
          );
        });
  }

  void resetGame() {
    setState(() {
      gameBoard = List.generate(
          columnLength, (i) => List.generate(rowLength, (j) => null));
    });
    currentScore = 0;
    createNewPiece();

    gameOver = false;
    startGame();
  }

  bool checkCollision(Direction direction) {
    // loop through all direction index
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the index of the current piece
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = (currentPiece.position[i] % rowLength);

      // directions
      if (direction == Direction.down) {
        row++;
      } else if (direction == Direction.right) {
        col++;
      } else if (direction == Direction.left) {
        col--;
      }

      // check for collisions with boundaries
      if (col < 0 || col >= rowLength || row >= columnLength) {
        return true;
      }

      // check for collisions with other landed pieces
      if (row >= 0 && gameBoard[row][col] != null) {
        return true;
      }
    }
    // if there is no collision return false
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int column = currentPiece.position[i] % rowLength;
        if (row >= 0 && column >= 0) {
          gameBoard[row][column] = currentPiece.type;
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
    if (isGameOver()) {
      gameOver = true;
    }
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void clearLines() {
    for (int row = columnLength - 1; row >= 0; row--) {
      bool rowIsFull = true;
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      if (rowIsFull) {
        for (int rowToMove = row; rowToMove > 0; rowToMove--) {
          gameBoard[rowToMove] = List.from(gameBoard[rowToMove - 1]);
        }
        gameBoard[0] = List.generate(row, (index) => null);

        currentScore++;
      }
    }
  }

  bool isGameOver() {
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: [
          Expanded(
              child: GestureDetector(
                  child: GestureDetector(
            onDoubleTap: () {
              rotatePiece();
            },
            onHorizontalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx < 0) {
                moveLeft();
              } else if (details.velocity.pixelsPerSecond.dx > 0) {
                moveRight();
              }
            },
            child: GridView.builder(
              itemCount: rowLength * columnLength,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength),
              itemBuilder: (context, index) {
                int row = (index / rowLength).floor();
                int column = index % rowLength;
                if (currentPiece.position.contains(index)) {
                  return Pixel(
                    color: currentPiece.color,
                  );
                } else if (gameBoard[row][column] != null) {
                  final Tetromino? type = gameBoard[row][column];
                  return Pixel(
                    color: tetrominoColor[type]!,
                  );
                } else {
                  return Pixel(
                    color: Colors.grey[900],
                  );
                }
              },
            ),
          ))),
          Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Score: $currentScore',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    Text('Highscore: $currentScore',
                        style: TextStyle(color: Colors.white, fontSize: 20))
                  ])),
        ]));
  }
}
