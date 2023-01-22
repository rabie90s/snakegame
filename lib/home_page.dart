import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snakegame/blank_pixel.dart';
import 'package:snakegame/food_pixel.dart';
import 'package:snakegame/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_direction { UP, DOWN, RIGHT, LEFT }

class _HomePageState extends State<HomePage> {
  // Grid dimensions:
  int rowSize = 10;
  int squaresNo = 100;

  int current_score = 0;

  // Snake position:
  List<int> snakePos = [0, 1, 2];

  // Food position:
  int foodPos = 55;

  // Snake direction is initially to the right:
  var currentDirection = snake_direction.RIGHT;

  // Start the game:
  void startGame() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();

        // check if the game over
        if (isGameOver()) {
          timer.cancel();
          // Display a msg to the user
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text('Game Over'),
                  content: Column(
                    children: [
                      Text('Your score is: ' + current_score.toString()),
                      TextField(
                        decoration: InputDecoration(hintText: 'Enter name'),
                      )
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        submitScore();
                        newGame();
                      },
                      child: Text('Submit'),
                      color: Colors.pink,
                    ),
                  ],
                );
              });
        }
      });
    });
  }

  void submitScore() {
    //
  }

  void newGame() {
    setState(() {
      snakePos = [0, 1, 2];
      foodPos = 55;
      currentDirection = snake_direction.RIGHT;
      current_score = 0;
      gameHasStarted = false;
    });
  }

  void eatFood() {
    current_score++;
    // Make sure that the food position not on the same position of the snake:
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(squaresNo);
    }
  }

  bool isGameOver() {
    // The game is over when the snake runs into itself, this occures when there is a duplicate position in the snakePos list:

    // this list is the body of the snake (no head):
    List<int> snakeBody = snakePos.sublist(0, snakePos.length - 1);

    if (snakeBody.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_direction.RIGHT:
        {
          // Add a new Head to the snake = last elemnt in the snakePos List:
          // check if Snake at the right wall => need to re-adjust:
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snake_direction.LEFT:
        {
          // Add a new Head to the snake = last elemnt in the snakePos List:
          // check if Snake at the left wall => need to re-adjust:
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snake_direction.UP:
        {
          // Add a new Head to the snake = last elemnt in the snakePos List:
          // check if Snake at the upper wall => need to re-adjust:
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + squaresNo);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_direction.DOWN:
        {
          // Add a new Head to the snake = last elemnt in the snakePos List:
          // check if Snake at the down wall => need to re-adjust:
          if (snakePos.last + rowSize > squaresNo) {
            snakePos.add(snakePos.last + rowSize - squaresNo);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
    }
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      // Remove the Tail = First elemnt in the snakePos List:
      snakePos.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        //High scores
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // User current score:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your score: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    current_score.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),

              // High scores
              Text(
                ' High scores .. ',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        //Game grid
        Expanded(
          flex: 3,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 0 &&
                  currentDirection != snake_direction.UP) {
                currentDirection = snake_direction.DOWN;
              }
              if (details.delta.dy < 0 &&
                  currentDirection != snake_direction.DOWN) {
                currentDirection = snake_direction.UP;
              }

              if (details.globalPosition == foodPos) {
                snakePos.add(snakePos.last + 1);
                print('Fooooood');
              }
            },
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0 &&
                  currentDirection != snake_direction.LEFT) {
                currentDirection = snake_direction.RIGHT;
              }
              if (details.delta.dx < 0 &&
                  currentDirection != snake_direction.RIGHT) {
                currentDirection = snake_direction.LEFT;
              }
            },
            child: GridView.builder(
              itemCount: squaresNo,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowSize),
              itemBuilder: (context, index) {
                if (snakePos.contains(index)) {
                  return const SnakePixel();
                }
                if (index == foodPos) {
                  return const FoodPixel();
                }
                return const BlankPixel();
              },
            ),
          ),
        ),

        //Play button
        Expanded(
          child: Container(
            child: Center(
              child: MaterialButton(
                onPressed: startGame,
                child: const Text('PLAY'),
                color: Colors.pink,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
