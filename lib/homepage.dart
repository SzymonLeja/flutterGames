import 'dart:math';
import 'package:flutter/material.dart';
import 'package:games_app/snake.dart';
import 'package:games_app/tetris.dart';
import 'package:games_app/tictactoe.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Color> cellColors = [];
  static final myNewFont = GoogleFonts.pressStart2p(
    textStyle: TextStyle(color: Colors.black, letterSpacing: 3),
  );
  static final myNewFontWhite = GoogleFonts.pressStart2p(
    textStyle: TextStyle(color: Colors.white, letterSpacing: 3),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() {
        updateColors();
      })
      ..repeat();
    initializeColors();
  }

  void initializeColors() {
    for (int i = 0; i < 2000; i++) {
      if (Random().nextDouble() < 0.1) {
        cellColors
            .add(Colors.primaries[Random().nextInt(Colors.primaries.length)]);
      } else {
        cellColors.add(Colors.grey[900]!);
      }
    }
  }

  void updateColors() {
    for (int i = 0; i < cellColors.length; i++) {
      if (cellColors[i] != Colors.grey[900]) {
        cellColors[i] =
            Colors.primaries[Random().nextInt(Colors.primaries.length)];
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 15,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        color: cellColors[index % cellColors.length],
                      );
                    },
                    itemCount: cellColors.length,
                  ),
                );
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 150),
              Text(
                "Mini Games",
                style: myNewFontWhite.copyWith(fontSize: 30),
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TicTacToePage()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Text(
                        'Kółko i krzyżyk',
                        style: myNewFont.copyWith(fontSize: 19),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SnakeGamePage()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Snake',
                        style: myNewFont.copyWith(fontSize: 19),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Tetris()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Tetris',
                        style: myNewFont.copyWith(fontSize: 19),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
