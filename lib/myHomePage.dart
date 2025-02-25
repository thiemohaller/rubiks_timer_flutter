import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController tc;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  bool timerRunning = true;
  bool timerStopped = true;
  bool checkTimer = true;
  int timeForTimer = 0;
  String timeToDisplay = "00:00:00";
  String scrambledMoves = "";
  List<String> scrambledMovesAsList = [];
  int amountOfScrambles = 20;

  var possibleScrambleMoves = [
    'F',
    'U',
    'D',
    'B',
    'L',
    'R',
    "F'",
    "U'",
    "D'",
    "B'",
    "L'",
    "R'",
    'F2',
    'U2',
    'D2',
    'B2',
    'L2',
    'R2'
  ];

// build app

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rubiks Timer",
        ),
        centerTitle: true,
        bottom: TabBar(
          tabs: <Widget>[Text("Stopwatch"), Text("Solves")],
          labelPadding: EdgeInsets.only(
            bottom: 10.0,
          ),
          labelStyle: TextStyle(
            fontSize: 18.0,
          ),
          unselectedLabelColor: Colors.white70,
          controller: tc,
        ),
      ),
      body: TabBarView(
        children: <Widget>[stopwatch(), statsList()],
        controller: tc,
      ),
    );
  }

  @override
  void initState() {
    tc = TabController(
      length: 2,
      vsync: this,
    );
    scrambleList();
    super.initState();
  }

  void startTimer() {
    setState(() {
      timerRunning = false;
      timerStopped = false;
    });
    timeForTimer = hours * 60 * 60 + minutes * 60 + seconds;
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeForTimer < 1 || checkTimer == false) {
          t.cancel();
          if (timeForTimer == 0) {
            debugPrint("Stopped by default.");
          }
          timeToDisplay = "00:00:00";
          checkTimer = true;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ));
        } else if (timeForTimer < 60) {
          timeToDisplay = "00:00:" + timeForTimer.toString().padLeft(2, '0');
          timeForTimer = timeForTimer - 1;
        } else if (timeForTimer < 3600) {
          int m = timeForTimer ~/ 60;
          int s = timeForTimer - 60 * m;
          timeToDisplay = "00:" +
              m.toString().padLeft(2, '0') +
              ":" +
              s.toString().padLeft(2, '0');
          timeForTimer = timeForTimer - 1;
        } else {
          int h = timeForTimer ~/ 3600;
          int t = timeForTimer - 3600 * h;
          int m = t ~/ 60;
          int s = t - 60 * m;
          timeToDisplay = h.toString().padLeft(2, '0') +
              ":" +
              m.toString().padLeft(2, '0') +
              ":" +
              s.toString().padLeft(2, '0');
          timeForTimer = timeForTimer - 1;
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      timerRunning = true;
      timerStopped = true;
      checkTimer = false;
    });
  }

  // TIMER
  Widget timer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Text(
                        "HH",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    NumberPicker.integer(
                      initialValue: hours,
                      minValue: 0,
                      maxValue: 23,
                      listViewWidth: 60.0,
                      infiniteLoop: true,
                      onChanged: (val) {
                        setState(() {
                          hours = val;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Text(
                        "MM",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    NumberPicker.integer(
                      initialValue: minutes,
                      minValue: 0,
                      maxValue: 59,
                      infiniteLoop: true,
                      listViewWidth: 60.0,
                      onChanged: (val) {
                        setState(() {
                          minutes = val;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Text(
                        "SS",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    NumberPicker.integer(
                      initialValue: seconds,
                      minValue: 0,
                      maxValue: 59,
                      listViewWidth: 60.0,
                      infiniteLoop: true,
                      onChanged: (val) {
                        setState(() {
                          seconds = val;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              timeToDisplay,
              style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: timerRunning ? startTimer : null,
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                  color: Colors.lightBlue,
                  child: Text(
                    "Go!",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                RaisedButton(
                  onPressed: timerStopped ? null : stopTimer,
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                  color: Colors.redAccent,
                  child: Text(
                    "Stop",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STOPWATCH
  Widget stopwatch() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  // SS:MilliMilliMilli
                  stopwatchTimeToDisplay,
                  style: TextStyle(
                    fontSize: 75.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                millisToString(averageOfFive),
                style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    scrambledMoves,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  buildBigFloatingButton(
                      cubeStopwatch.isRunning ? "Stop" : "Go!",
                      goButtonPressed),
                  //buildSmallFloatingButton(updateScrambledList)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool startIsDisabled = true;
  bool stopIsDisabled = true;
  bool solveTookMinute = false;
  String stopwatchTimeToDisplay = "00:000";
  String previousSwatchTime = "00:000";
  var cubeStopwatch = Stopwatch();
  final dur = const Duration(milliseconds: 1);

  void startSwatchTimer() {
    Timer(dur, keepRunning);
  }

  void keepRunning() {
    if (cubeStopwatch.isRunning) {
      startSwatchTimer();
    }
    setState(() {
      // if solve takes over 1 minute, display minutes as well
      if (cubeStopwatch.elapsed.inSeconds < 60) {
        stopwatchTimeToDisplay =
            (cubeStopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0') +
                ":" +
                (cubeStopwatch.elapsedMilliseconds % 1000)
                    .toString()
                    .padLeft(3, '0');
      } else {
        stopwatchTimeToDisplay = (cubeStopwatch.elapsed.inMinutes % 60)
                .toString() +
            ":" +
            (cubeStopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0') +
            ":" +
            (cubeStopwatch.elapsedMilliseconds % 1000)
                .toString()
                .padLeft(3, '0');
        solveTookMinute = true;
      }
    });
  }

  void goButtonPressed() {
    setState(() {
      if (cubeStopwatch.isRunning) {
        setState(() {
          previousSolvesInMilliseconds.insert(0, cubeStopwatch.elapsedMilliseconds);
          previousSolvesList.insert(0, stopwatchTimeToDisplay);
          cubeStopwatch.stop();

          if(previousSolvesInMilliseconds.length >= 5) {
             averageOfFive = 0;

            for(int i = 0; i < 5 ;i++) {
              averageOfFive = averageOfFive + previousSolvesInMilliseconds[i];
            }

            averageOfFive = (averageOfFive / 5).round();
          }

          scrambleList();
        });
      } else {
        cubeStopwatch.reset();
        stopwatchTimeToDisplay = "00:000";
        cubeStopwatch.start();
        startSwatchTimer();
      }
    });
  }

// update existing list
  void scrambleList() {
    scrambledMovesAsList = [];

    for (var i = 0; i < amountOfScrambles; i++) {
      // https://stackoverflow.com/questions/17476718/
      List possibleScrambleMovesCopy = possibleScrambleMoves.toList();
      var randElement = (possibleScrambleMovesCopy..shuffle()).first;

      if (i == 0) {
        scrambledMovesAsList.add(randElement);
      } else if ((randElement == 'F' ||
              randElement == "F'" ||
              randElement == 'F2') &&
          (scrambledMovesAsList[i - 1] == 'F' ||
              scrambledMovesAsList[i - 1] == "F'" ||
              scrambledMovesAsList[i - 1] == 'F2')) {
        i = i - 1;
      } else if ((randElement == 'U' ||
              randElement == "U'" ||
              randElement == 'U2') &&
          (scrambledMovesAsList[i - 1] == 'U' ||
              scrambledMovesAsList[i - 1] == "U'" ||
              scrambledMovesAsList[i - 1] == 'U2')) {
        i = i - 1;
      } else if ((randElement == 'R' ||
              randElement == "R'" ||
              randElement == 'R2') &&
          (scrambledMovesAsList[i - 1] == 'R' ||
              scrambledMovesAsList[i - 1] == "R'" ||
              scrambledMovesAsList[i - 1] == 'R2')) {
        i = i - 1;
      } else if ((randElement == 'L' ||
              randElement == "L'" ||
              randElement == 'L2') &&
          (scrambledMovesAsList[i - 1] == 'L' ||
              scrambledMovesAsList[i - 1] == "L'" ||
              scrambledMovesAsList[i - 1] == 'L2')) {
        i = i - 1;
      } else if ((randElement == 'D' ||
              randElement == "D'" ||
              randElement == 'D2') &&
          (scrambledMovesAsList[i - 1] == 'D' ||
              scrambledMovesAsList[i - 1] == "D'" ||
              scrambledMovesAsList[i - 1] == 'D2')) {
        i = i - 1;
      } else if ((randElement == 'B' ||
              randElement == "B'" ||
              randElement == 'B2') &&
          (scrambledMovesAsList[i - 1] == 'B' ||
              scrambledMovesAsList[i - 1] == "B'" ||
              scrambledMovesAsList[i - 1] == 'B2')) {
        i = i - 1;
      } else {
        scrambledMovesAsList.add(randElement);
      }

      debugPrint("scrambledmoves as list: " + scrambledMovesAsList.toString());
    }

    var scrambledMovesCopy = scrambledMovesAsList.toString();
    scrambledMoves = scrambledMovesCopy
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll(",", " ");
  }
}

String millisToString(int timeInMillis) {
  Duration solveDuration = new Duration(milliseconds: timeInMillis);
  int minutes =  solveDuration.inMinutes;
  int seconds = solveDuration.inSeconds;
  int millis = solveDuration.inMilliseconds;

  if(averageOfFive > 0) {
    return minutes.toString() + ":" + seconds.toString().padLeft(2, '0') + ":" +
        millis.toString().substring(1);
  } else
    return "0:00:000";
}

Widget buildBigFloatingButton(String text, VoidCallback callback) {
  return new Container(
    width: 200.0,
    height: 200.0,
    child: FittedBox(
      child: FloatingActionButton(
        onPressed: callback,
        child: new Text(text),
        backgroundColor: Colors.blueAccent,
      ),
    ),
  );
}

Widget buildSmallFloatingButton(String text, VoidCallback callback) {
  return new Container(
    width: 75.0,
    height: 75.0,
    child: FittedBox(
      child: FloatingActionButton(
        onPressed: callback,
        child: new Text(text),
        backgroundColor: Colors.blueAccent,
      ),
    ),
  );
}

// model for solve
class SolveDetails {
  String solveTime;
  List<String> solveScramble;
  bool solveDNF;

  SolveDetails(this.solveTime, this.solveScramble, this.solveDNF);
}

List<String> previousSolvesList = [];
List<int> previousSolvesInMilliseconds = [];
int averageOfFive = 0;

Widget buildStatisticsList(BuildContext context, int index) {
  return new Text(
    previousSolvesList[index],
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 30.0,),
  );
}

Widget statsList() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(8.0),
    child: Center(
      child: new ListView.builder(
          padding: EdgeInsets.all(5.0),
          itemCount: previousSolvesList.length,
          itemBuilder: (context, int index) =>
              buildStatisticsList(context, index)),
    ),
  );
}
