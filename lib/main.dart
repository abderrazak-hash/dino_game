import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DinosorGame(),
  ));
}

class Position {
  late double x, y;

  Position(this.x, this.y);
}

late double height, width;

List<int> scores = [];

class DinosorGame extends StatefulWidget {
  const DinosorGame({Key? key}) : super(key: key);

  @override
  State<DinosorGame> createState() => _DinosorGameState();
}

class _DinosorGameState extends State<DinosorGame> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Spacer(),
            const Center(
              child: Text(
                'Welcome to\n DINO GAME',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            const Spacer(),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DinoGame()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60.0,
                          width: 60.0,
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 234, 131, 41),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_arrow,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Text(
                          'PLAY',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                    width: double.infinity,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScoresScreen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'MY SCORES',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Text('Enjoy Dino Game')
          ],
        ),
      ),
    );
  }
}

class DinoGame extends StatefulWidget {
  const DinoGame({super.key});

  @override
  State<DinoGame> createState() => _DinoGameState();
}

class _DinoGameState extends State<DinoGame> {
  String state = state0;
  bool play = true;

  bool endGame = false;

  int score = 0;

  double right = 0;

  bool init = true;

  late Position dinoPos;

  void animateTree() async {
    await Future.delayed(const Duration(
      milliseconds: 50,
    )).then((value) {
      if (play && right < width + 50) {
        setState(() {
          right += 15;
        });
      }
    });
    animateTree();
  }

  void generateTree() {
    setState(() {
      right = 0;
    });
  }

  void walk() async {
    await Future.delayed(const Duration(
      milliseconds: 100,
    )).then((value) {
      if (play && !jumping) {
        setState(() {
          state = state == state0 ? state1 : state0;
          if (Random().nextInt(4) == 2 && right > width) {
            generateTree();
          }
        });
      }
    });
    walk();
  }

  bool jumping = false;

  void jump() async {
    setState(() {
      jumping = true;
      state = state2;
    });
    await Future.delayed(const Duration(
      milliseconds: 800,
    )).then((value) {
      setState(() {
        jumping = false;
        state = state0;
      });
    });
  }

  void restart() {
    setState(() {
      jumping = false;
      right = 0;
      play = true;
      score = 0;
      endGame = false;
    });
    test();
  }

  void test() async {
    await Future.delayed(const Duration(
      milliseconds: 10,
    )).then((value) {
      if (!jumping &&
          right > width - 100 - dinoPos.x &&
          right < width - dinoPos.x) {
        setState(() {
          play = false;
          state = state3;
          endGame = true;
        });
        scores.add(score);
        scores.sort((a, b) => b > a
            ? 1
            : a == b
                ? 0
                : -1);
        showDialog(
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Game Over!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            content: SizedBox(
              height: 80.0,
              child: Center(
                child: Text(
                  '$score',
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            actions: [
              Center(
                child: IconButton(
                  onPressed: () {
                    restart();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.replay,
                    size: 35.0,
                    color: Colors.black,
                    semanticLabel: 'Restart',
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        score += 2;
      }
    });
    if (!endGame) {
      test();
    }
  }

  @override
  void initState() {
    super.initState();
    walk();
    animateTree();
    test();
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      setState(() {
        height = MediaQuery.of(context).size.height;
        width = MediaQuery.of(context).size.width;
        dinoPos = Position(18, height * .5 - 70);
        init = false;
      });
    }
    return GestureDetector(
      onTap: () {
        jump();
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      '$score',
                      style: const TextStyle(fontSize: 30.0),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: jumping ? dinoPos.y - 150 : dinoPos.y,
                left: dinoPos.x,
                child: AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: const Duration(microseconds: 150),
                  padding: EdgeInsets.only(bottom: jumping ? 150 : 0),
                  child: Image.asset(
                    state,
                  ),
                ),
              ),
              const Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                right: right,
                top: height * .5 - 60,
                child: Image.asset(
                  'assets/treeAsset.png',
                  width: 100.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const state4 = 'assets/etat.png',
    state2 = 'assets/etat1.png',
    state3 = 'assets/etat3.png',
    state0 = 'assets/etat2.png',
    state1 = 'assets/etat5.png';

class ScoresScreen extends StatelessWidget {
  const ScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                'Previous Scores',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: List.generate(
                    scores.length,
                    (index) => Container(
                      child: Text(
                        '${index + 1} - ${scores[index]}',
                        style: const TextStyle(fontSize: 30.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
