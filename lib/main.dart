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
  String currentPlayer = 'playerA';
  final List<String> animalEmojis = [
    '🐶',
    '🐱',
    '🐭',
    '🐹',
    '🐰',
    '🦊',
    '🐻',
    '🐼',
    '🐨',
    '🐯'
  ];
  late String playerAEmoji;
  late String playerBEmoji;
  List<List<int>> _winningLine = [];
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _assignRandomEmojis();
  }

  void _assignRandomEmojis() {
    animalEmojis.shuffle();
    playerAEmoji = animalEmojis[0];
    playerBEmoji = animalEmojis[1];
  }

  void _highlightWinningLine(List<List<int>> line) {
    setState(() {
      _winningLine = line;
      _gameOver = true;
    });
  }

  Future<void> _showWinDialog(String winner) async {
    await Future.delayed(const Duration(milliseconds: 500));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              '${winner == 'playerA' ? playerAEmoji : playerBEmoji} Wins!'),
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

  bool _checkWin(String player) {
    String playerEmoji = player == 'playerA' ? playerAEmoji : playerBEmoji;
    // Check rows
    for (int i = 0; i < gridSize; i++) {
      if (grid[i].every((cell) => cell == playerEmoji)) {
        _highlightWinningLine(List.generate(gridSize, (index) => [i, index]));
        return true;
      }
    }
    // Check columns
    for (int i = 0; i < gridSize; i++) {
      if (grid.every((row) => row[i] == playerEmoji)) {
        _highlightWinningLine(List.generate(gridSize, (index) => [index, i]));
        return true;
      }
    }
    // Check diagonals
    if (grid.every(
        (row) => grid[grid.indexOf(row)][grid.indexOf(row)] == playerEmoji)) {
      _highlightWinningLine(List.generate(gridSize, (index) => [index, index]));
      return true;
    }
    if (grid.every((row) =>
        grid[grid.indexOf(row)][gridSize - grid.indexOf(row) - 1] ==
        playerEmoji)) {
      _highlightWinningLine(
          List.generate(gridSize, (index) => [index, gridSize - index - 1]));
      return true;
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      grid = List.generate(gridSize, (_) => List.filled(gridSize, ''));
      currentPlayer = 'playerA';
      _assignRandomEmojis();
      _winningLine.clear();
      _gameOver = false;
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
    if (grid[row][col] == '' && !_gameOver) {
      setState(() {
        grid[row][col] =
            currentPlayer == 'playerA' ? playerAEmoji : playerBEmoji;
        if (_checkWin(currentPlayer)) {
          _showWinDialog(currentPlayer);
        } else if (_isDraw()) {
          _showDrawDialog();
        } else {
          currentPlayer = currentPlayer == 'playerA' ? 'playerB' : 'playerA';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: 3.14159, // 180 degrees in radians
                  child: Text(
                    currentPlayer == 'playerB' ? 'Your Turn' : '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Transform.rotate(
                  angle: 3.14159, // 180 degrees in radians
                  child: Text(
                    '$playerBEmoji Player',
                    style: const TextStyle(fontSize: 24, color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$playerAEmoji Player',
                  style: const TextStyle(fontSize: 24, color: Colors.teal),
                ),
                const SizedBox(height: 10),
                Text(
                  currentPlayer == 'playerA' ? 'Your Turn' : '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(gridSize, (row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(gridSize, (col) {
                    bool isWinningTile = _winningLine
                        .any((pos) => pos[0] == row && pos[1] == col);
                    return GestureDetector(
                      onTap: () => _handleTap(row, col),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color:
                              isWinningTile ? Colors.tealAccent : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Transform.rotate(
                            angle: currentPlayer == 'playerB' ? 3.14159 : 0,
                            child: Text(
                              grid[row][col],
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
