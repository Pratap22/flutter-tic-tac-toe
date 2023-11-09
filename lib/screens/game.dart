import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/colors.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
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
  List<int> matchedIndexes = [];
  int oScore = 0;
  int xScore = 0;
  int attempts = 0;
  String winner = '';
  int filledBoxes = 0;
  bool winnerFound = false;

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;

  static var fontWhite = TextStyle(
      color: Colors.white,
      letterSpacing: 2,
      fontSize: 28,
      fontWeight: FontWeight.w900);

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("LWP - Tic Tac Toe")),
        backgroundColor: MainColor.accentColor,
      ),
      backgroundColor: MainColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Player O',
                          style: fontWhite,
                        ),
                        Text(oScore.toString(), style: fontWhite)
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Player X', style: fontWhite),
                        Text(xScore.toString(), style: fontWhite)
                      ],
                    )
                  ],
                )),
            Expanded(
                flex: 3,
                child: GridView.builder(
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _tapped(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: matchedIndexes.contains(index)
                                  ? MainColor.accentColor
                                  : MainColor.secondaryColor,
                              border: Border.all(
                                  width: 5, color: MainColor.primaryColor),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Text(
                            displayXO[index],
                            style: TextStyle(
                                fontSize: 64,
                                color: MainColor.primaryColor,
                                fontWeight: FontWeight.w600),
                          )),
                        ),
                      );
                    })),
            Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          winner.isNotEmpty
                              ? winner == 'N'
                                  ? 'Nobody Wins!'
                                  : 'Player $winner wins'
                              : '',
                          style: fontWhite,
                        ),
                        SizedBox(height: 10),
                        _buildTimer()
                      ]),
                ))
          ],
        ),
      ),
    );
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;

    if (isRunning) {
      setState(() {
        if (oTurn && displayXO[index] == '') {
          displayXO[index] = 'O';
        } else if (!oTurn && displayXO[index] == '') {
          displayXO[index] = 'X';
        }
        filledBoxes++;
        oTurn = !oTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != '') {
      winner = displayXO[0];
      matchedIndexes.addAll([0, 1, 2]);
      _updateWiner();
    }

    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      winner = displayXO[3];
      matchedIndexes.addAll([3, 4, 5]);
      _updateWiner();
    }

    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      winner = displayXO[6];
      matchedIndexes.addAll([6, 7, 8]);
      _updateWiner();
    }

    if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != '') {
      winner = displayXO[0];
      matchedIndexes.addAll([0, 3, 6]);
      _updateWiner();
    }

    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      winner = displayXO[1];
      matchedIndexes.addAll([1, 4, 7]);
      _updateWiner();
    }

    if (displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8] &&
        displayXO[2] != '') {
      winner = displayXO[2];
      matchedIndexes.addAll([2, 5, 8]);
      _updateWiner();
    }

    if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != '') {
      winner = displayXO[0];
      matchedIndexes.addAll([0, 4, 8]);
      _updateWiner();
    }

    if (displayXO[2] == displayXO[4] &&
        displayXO[2] == displayXO[6] &&
        displayXO[2] != '') {
      winner = displayXO[2];
      matchedIndexes.addAll([2, 4, 6]);
      _updateWiner();
    }

    if (!winnerFound && filledBoxes == 9) {
      setState(() {
        winner = 'N';
        stopTimer();
      });
    }
  }

  void _updateWiner() {
    stopTimer();
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < displayXO.length; i++) {
        displayXO[i] = '';
      }
      winner = '';
      matchedIndexes = [];
    });
    winnerFound = false;
    filledBoxes = 0;
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning
        ? SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 8,
                  backgroundColor: MainColor.accentColor,
                ),
                Center(
                  child: Text(
                    '$seconds',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                ),
              ],
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            onPressed: () {
              startTimer();
              _clearBoard();
              attempts++;
            },
            child: Text(
              attempts == 0 ? 'Start' : 'Play Again!',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          );
  }
}
