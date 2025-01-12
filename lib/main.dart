import 'package:flutter/material.dart';
// import 'dart:math';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  static const int gridSize = 3;
  List<List<String>> grid =
      List.generate(gridSize, (_) => List.filled(gridSize, ''));
  String currentPlayer = 'O';

  bool _checkWin(String player) {
    // Check rows
    for (int i = 0; i < gridSize; i++) {
      if (grid[i].every((cell) => cell == player)) return true;
    }
    // Check columns
    for (int i = 0; i < gridSize; i++) {
      if (grid.every((row) => row[i] == player)) return true;
    }
    // Check diagonals
    if (grid
        .every((row) => grid[grid.indexOf(row)][grid.indexOf(row)] == player))
      return true;
    if (grid.every((row) =>
        grid[grid.indexOf(row)][gridSize - grid.indexOf(row) - 1] == player))
      return true;
    return false;
  }

  void _showWinDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$winner Wins!'),
          actions: <Widget>[
            TextButton(
              child: const Text('New Game'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      grid = List.generate(gridSize, (_) => List.filled(gridSize, ''));
      currentPlayer = 'O';
    });
  }

  bool _isDraw() {
    for (var row in grid) {
      if (row.contains('')) return false;
    }
    return true;
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Draw!'),
          actions: <Widget>[
            TextButton(
              child: const Text('New Game'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleTap(int row, int col) {
    if (grid[row][col] == '') {
      setState(() {
        grid[row][col] = currentPlayer;
        if (_checkWin(currentPlayer)) {
          _showWinDialog(currentPlayer);
        } else if (_isDraw()) {
          _showDrawDialog();
        } else {
          currentPlayer = currentPlayer == 'O' ? 'X' : 'O';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(gridSize, (row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(gridSize, (col) {
                    return GestureDetector(
                      onTap: () => _handleTap(row, col),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            grid[row][col],
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Transform.rotate(
              angle: 3.14159, // 180 degrees in radians
              child: const Text(
                '× Player',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: const Text(
              '⚪︎ Player',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: Transform.rotate(
              angle: 3.14159, // 180 degrees in radians
              child: Text(
                currentPlayer == 'X' ? 'Your Turn' : '',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 10,
            child: Text(
              currentPlayer == 'O' ? 'Your Turn' : '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
