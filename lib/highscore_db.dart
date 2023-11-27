import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HighscoreDB {
  static final HighscoreDB _singleton = HighscoreDB._internal();

  factory HighscoreDB() {
    return _singleton;
  }

  HighscoreDB._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'highscore_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE highscore(id INTEGER PRIMARY KEY, game TEXT, score INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertHighscore(String game, int score) async {
    final Database db = await database;
    await db.insert(
      'highscore',
      {'game': game, 'score': score},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getHighscore(
      {required String game}) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'highscore',
      where: 'game = ?',
      whereArgs: [game],
      orderBy: 'score DESC',
    );

    return maps;
  }
}

class Highscore {
  final String game;
  final int score;

  Highscore({required this.game, required this.score});

  Map<String, dynamic> toMap() {
    return {'game': game, 'score': score};
  }

  @override
  String toString() {
    return 'Highscore{game: $game, score: $score}';
  }
}
