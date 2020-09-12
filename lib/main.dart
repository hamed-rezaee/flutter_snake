import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Snake',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Flutter Snake'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> snakePosition = [45, 65, 85, 105, 125];
  final int numberOfSquares = 760;

  static final Random random = Random();
  int food;
  Direction direction = Direction.down;

  Timer timer;

  @override
  void initState() {
    super.initState();

    _startGame();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  if (direction != Direction.up && details.delta.dy > 0) {
                    direction = Direction.down;
                  } else if (direction != Direction.down &&
                      details.delta.dy < 0) {
                    direction = Direction.up;
                  }
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  if (direction != Direction.left && details.delta.dx > 0) {
                    direction = Direction.right;
                  } else if (direction != Direction.right &&
                      details.delta.dx < 0) {
                    direction = Direction.left;
                  }
                },
                child: Container(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 20,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }

                      if (index == food) {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              color: Colors.green,
                            ),
                          ),
                        );
                      }

                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              color: Colors.grey[900],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Text(
                      'Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onTap: _startGame,
                  ),
                  Text(
                    'Created by Hamed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );

  void _generateFood() {
    food = random.nextInt(numberOfSquares);
  }

  void _startGame() {
    snakePosition = [45, 65, 85, 105, 125];
    _generateFood();

    timer?.cancel();

    timer = Timer.periodic(const Duration(milliseconds: 300), (Timer timer) {
      _updateSnake();

      if (_gameOver()) {
        timer.cancel();
        _showGameOverScreen();
      }
    });
  }

  void _updateSnake() {
    setState(() {
      switch (direction) {
        case Direction.up:
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last - 20 + 760);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }

          break;

        case Direction.down:
          if (snakePosition.last > 740) {
            snakePosition.add(snakePosition.last + 20 - 760);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }

          break;

        case Direction.left:
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }

          break;

        case Direction.right:
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }

          break;
      }

      if (snakePosition.last == food) {
        _generateFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool _gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int counter = 0;

      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          counter++;
        }

        if (counter == 2) {
          return true;
        }
      }
    }

    return false;
  }

  void _showGameOverScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('You\'re Score: ${snakePosition.length}'),
        actions: <Widget>[
          FlatButton(
            child: Text('Play Again'),
            onPressed: () {
              Navigator.of(context).pop();

              _startGame();
            },
          )
        ],
      ),
    );
  }
}

enum Direction {
  up,
  down,
  left,
  right,
}
