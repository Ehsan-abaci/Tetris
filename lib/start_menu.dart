import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetris/main.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/values.dart';

class StartMenu extends StatefulWidget {
  StartMenu({Key? key, required this.bestScore}) : super(key: key);
  late int bestScore;

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> {
  late int bestEasyScore;
  late int bestMediumScore;
  late int bestHardScore;
  List<int> points = [
    48,
    49,
    47,
    71,
    94,
    117,
    140,
    51,
    52,
    53,
    74,
    97,
    120,
    143,
    144,
    145,
    98,
    99,
    55,
    56,
    57,
    79,
    102,
    125,
    148,
    59,
    82,
    105,
    128,
    151,
    60,
    61,
    84,
    107,
    106,
    129,
    153,
    63,
    86,
    109,
    132,
    155,
    65,
    66,
    67,
    88,
    111,
    112,
    113,
    136,
    159,
    158,
    157
  ];
  bool isMedium = false;
  bool isHard = false;
  bool isEasy = false;

  void changeMode(Mode mode) {
    switch (mode) {
      case Mode.EASY:
        setState(() {
          isEasy = !isEasy;
          isMedium = false;
          isHard = false;
          widget.bestScore = bestEasyScore;
        });
        break;
      case Mode.MEDIUM:
        setState(() {
          isMedium = !isMedium;
          isEasy = false;
          isHard = false;
          widget.bestScore = bestMediumScore;
        });
        break;
      case Mode.HARD:
        setState(() {
          isHard = !isHard;
          isEasy = false;
          isMedium = false;
          widget.bestScore = bestHardScore;
        });
        break;
    }
  }

  @override
  void initState() {
    print("initState ---------------------------------------");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getRecords();
      getMode();
    });

    super.initState();
  }

  void getMode() async {
    Mode? mode = ModalRoute.of(context)?.settings.arguments as Mode?;
    print(mode);
    if (mode == null) {
      isMedium = true;
    } else {
      switch (mode) {
        case Mode.EASY:
          isEasy = true;
          widget.bestScore = bestEasyScore;
          break;
        case Mode.MEDIUM:
          isMedium = true;
          widget.bestScore = bestMediumScore;
          break;
        case Mode.HARD:
          isHard = true;
          widget.bestScore = bestHardScore;
          break;
      }
    }
    setState(() {});
  }

  Future<void> getRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bestEasyScore = prefs.getInt("easy_score") ?? 0;
    bestMediumScore = prefs.getInt("medium_score") ?? 0;
    bestHardScore = prefs.getInt("hard_score") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Center(
            child: SizedBox(
              height: constraints.maxHeight,
              width: kIsWeb ? constraints.maxWidth * .27 : constraints.maxWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: GridView.builder(
                        itemCount: 23 * 7,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 23,
                        ),
                        itemBuilder: (context, index) {
                          if (points.contains(index)) {
                            if (points.sublist(0, 7).contains(index)) {
                              return Pixel(
                                color: Colors.red.shade800,
                              );
                            } else if (points.sublist(7, 18).contains(index)) {
                              return Pixel(color: Colors.blue.shade800);
                            } else if (points.sublist(18, 25).contains(index)) {
                              return Pixel(color: Colors.yellow.shade800);
                            } else if (points.sublist(25, 37).contains(index)) {
                              return Pixel(color: Colors.green.shade800);
                            } else if (points.sublist(37, 42).contains(index)) {
                              return Pixel(color: Colors.pink.shade800);
                            } else if (points
                                .sublist(37, points.length)
                                .contains(index)) {
                              return Pixel(color: Colors.orange.shade800);
                            }
                          }
                          return const Pixel(
                            color: Colors.black,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Best score : ${widget.bestScore}",
                        style:
                            const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: modeButton(
                            "Easy",
                            () {
                              changeMode(Mode.EASY);
                            },
                            isEasy,
                          )),
                          Expanded(
                              child: modeButton(
                            "Medium",
                            () {
                              changeMode(Mode.MEDIUM);
                            },
                            isMedium,
                          )),
                          Expanded(
                              child: modeButton(
                            "Hard",
                            () {
                              changeMode(Mode.HARD);
                            },
                            isHard,
                          )),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: playButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget playButton() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Container(
          height: 95,
          width: 95,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(47.5),
          ),
          child: IconButton(
            iconSize: 50,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/board',
                  arguments: [isEasy, isMedium, isHard]);
            },
            icon: const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget modeButton(String text, VoidCallback function, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: function,
        style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.grey : Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.grey,
                ))),
        child: Text(text),
      ),
    );
  }
}
