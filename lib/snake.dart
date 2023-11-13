import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: SafeArea(
          child: SnakeGamePage(),
        ),
      ),
    );
  }
}

class SnakeGamePage extends StatefulWidget {
  @override
  _SnakeGamePageState createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  int numberOfSquares = 760;
  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);
  Timer? _timer = null;

  void generateNewFood() {
    food = randomNumber.nextInt(700);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startGame() {
    snakePosition = [45, 65, 85, 105, 125];
    const duration = Duration(milliseconds: 300);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (mounted) {
        updateSnake();
        if (gameOver()) {
          timer.cancel();
          _showGameOverScreen();
        }
      }
    });
  }

  var direcation = 'down';
  void updateSnake() {
    setState(() {
      switch (direcation) {
        case 'down':
          if (snakePosition.last > 740) {
            snakePosition.add(snakePosition.last + 20 - 760);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;
        case 'up':
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last - 20 + 760);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;
        case 'right':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        case 'left':
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
      }
      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count++;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  bool _gameOver = false;

  void _showGameOverScreen() {
    if (!_gameOver) {
      _gameOver = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('You\'re score: ${snakePosition.length - 5}'),
            actions: <Widget>[
              TextButton(
                child: Text('Play Again'),
                onPressed: () {
                  startGame();
                  Navigator.of(context).pop();
                  _gameOver = false;
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (direcation != 'up' && details.delta.dy > 0) {
                direcation = 'down';
              } else if (direcation != 'down' && details.delta.dy < 0) {
                direcation = 'up';
              }
            },
            onHorizontalDragUpdate: (details) {
              if (direcation != 'right' && details.delta.dx > 0) {
                direcation = 'left';
              } else if (direcation != 'left' && details.delta.dx < 0) {
                direcation = 'right';
              }
            },
            child: Container(
                child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: numberOfSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 20,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (snakePosition.contains(index)) {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                if (index == food) {
                  return Container(
                    padding: EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Colors.green,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Colors.grey[900],
                      ),
                    ),
                  );
                }
              },
            )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: startGame,
                child: Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Text(
                'Score: ${snakePosition.length - 5}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
