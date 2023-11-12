import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  bool oTurn = true;
  List<String> displayXO = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  int oScore = 0;
  int xScore = 0;
  int click = 0;

  static var myNewFont = GoogleFonts.pressStart2p(
    textStyle: TextStyle(color: Colors.black, letterSpacing: 3),
  );
  static var myNewFontWhite = GoogleFonts.pressStart2p(
    textStyle: TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 15),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Gracz O', style: myNewFontWhite),
                          SizedBox(height: 15),
                          Text(oScore.toString(), style: myNewFontWhite),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Gracz X', style: myNewFontWhite),
                          SizedBox(height: 15),
                          Text(xScore.toString(), style: myNewFontWhite),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      oTurn ? 'Ruch gracza O' : 'Ruch gracza X',
                      style: myNewFontWhite.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 3,

              child: GridView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _tapped(index);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Center(
                            child: Text(
                                displayXO[index],
                                style: myNewFontWhite.copyWith(fontSize: 30)),
                          )),
                    );
                  }),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(
                  'Kółko i krzyżyk',
                  style: myNewFontWhite,
                ),
              ),
            ),
          ],
        ));
  }

  void _tapped(int index) {
    setState(() {
      if (oTurn && displayXO[index] == '') {
        displayXO[index] = 'O';
        click +=1;
        oTurn = !oTurn;
      } else if (!oTurn && displayXO[index] == '') {
        displayXO[index] = 'X';
        click +=1;
        oTurn = !oTurn;
      }
      _checkWinner();
    });
  }

  void _checkWinner() {
    //1 poziom
    if (displayXO[0] == displayXO[1] &&
        displayXO[1] == displayXO[2] &&
        displayXO[0] != "") {
      _showWin(displayXO[0]);
    }

    //2 poziom
    else if (displayXO[3] == displayXO[4] &&
        displayXO[4] == displayXO[5] &&
        displayXO[3] != "") {
      _showWin(displayXO[3]);
    }

    // 3 poziom
    else if (displayXO[6] == displayXO[7] &&
        displayXO[7] == displayXO[8] &&
        displayXO[6] != "") {
      _showWin(displayXO[6]);
    }

    // 1 pion
    else if (displayXO[0] == displayXO[3] &&
        displayXO[3] == displayXO[6] &&
        displayXO[0] != "") {
      _showWin(displayXO[0]);
    }
    // 2 pion
    else if (displayXO[1] == displayXO[4] &&
        displayXO[4] == displayXO[7] &&
        displayXO[1] != "") {
      _showWin(displayXO[1]);
    }
    // 3 pion
    else if (displayXO[2] == displayXO[5] &&
        displayXO[5] == displayXO[8] &&
        displayXO[2] != "") {
      _showWin(displayXO[2]);
    }
    // 1 skos
    else if (displayXO[0] == displayXO[4] &&
        displayXO[4] == displayXO[8] &&
        displayXO[0] != "") {
      _showWin(displayXO[0]);
    }

    // 2 skos
    else if (displayXO[2] == displayXO[4] &&
        displayXO[4] == displayXO[6] &&
        displayXO[2] != "") {
      _showWin(displayXO[2]);
    } else if (click == 9) {
      _showDialog();
    }
  }

  void _showDialog(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Remis"),
            actions: <Widget>[
              TextButton(
                child: Text('Zagraj ponownie'),
                onPressed: () {
                  _clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showWin(String winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Wygrywa: " + winner),
            actions: <Widget>[
              TextButton(
                child: Text('Zagraj ponownie'),
                onPressed: () {
                  _clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    if (winner == "O"){
      oScore +=1;
      oTurn = false;
    }
    else if (winner == "X"){
      xScore +=1;
      oTurn = true;
    }
  }

  void _clear (){
    setState(() {
      for (int i=0; i < 9; i++) {
        displayXO[i] = "";
      }
    });
    click = 0;
  }
}
