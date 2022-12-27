import 'dart:async';

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
      });
    });
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_direction.RIGHT:
        {
          // Add a new Head to the snake = last elemnt in the snakePos List:
          snakePos.add(snakePos.last + 1);
          // Remove the Tail = First elemnt in the snakePos List:
          snakePos.removeAt(0);
        }
        break;
      case snake_direction.LEFT:
        {
          // Add a new Head to the snake = last elemnt in the snakePos List:
          snakePos.add(snakePos.last - 1);
          // Remove the Tail = First elemnt in the snakePos List:
          snakePos.removeAt(0);
        }
        break;
      case snake_direction.UP:
        {
          // Add a new Head to the snake = last elemnt in the snakePos List:
          snakePos.add(snakePos.last - rowSize);
          // Remove the Tail = First elemnt in the snakePos List:
          snakePos.removeAt(0);
        }
        break;
      case snake_direction.DOWN:
        {
          // Add a new Head to the snake = last elemnt in the snakePos List:
          snakePos.add(snakePos.last + rowSize);
          // Remove the Tail = First elemnt in the snakePos List:
          snakePos.removeAt(0);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        //High scores
        Expanded(
          child: Container(),
        ),
        //Game grid
        Expanded(
          flex: 3,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 0 && currentDirection != snake_direction.UP) {
                currentDirection = snake_direction.DOWN;
              }
              if (details.delta.dy < 0 && currentDirection != snake_direction.DOWN) {
                currentDirection = snake_direction.UP;
              }

              if (details.globalPosition == foodPos) {
                snakePos.add(snakePos.last + 1);
                print('Fooooood');
              }
            },
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0 && currentDirection != snake_direction.LEFT) {
                currentDirection = snake_direction.RIGHT;
              }
              if (details.delta.dx < 0 && currentDirection != snake_direction.RIGHT) {
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
