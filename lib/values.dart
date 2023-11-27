import 'package:flutter/material.dart';

int rowLength = 10;
int columnLength = 18;

enum Tetromino { L, J, I, O, S, Z, T }

enum Direction { left, right, down }

const Map<Tetromino, Color> tetrominoColor = {
  Tetromino.L: Colors.orange,
  Tetromino.J: Colors.blue,
  Tetromino.I: Colors.cyan,
  Tetromino.O: Colors.yellow,
  Tetromino.S: Colors.green,
  Tetromino.Z: Colors.red,
  Tetromino.T: Colors.purple,
};
