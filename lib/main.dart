import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rubiks Stopper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

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

  @override
  void initState() {
    tc = TabController(
      length: 2,
      vsync: this,
    );
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
              flex: 6,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  // SS:MilliMilli
                  stopwatchTimeToDisplay,
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )),
          Expanded(
            flex: 4,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildFloatingButton(
                      swatch.isRunning ? "stop" : "Go!", goButtonPressed),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // build app

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stopwatch",
        ),
        centerTitle: true,
        bottom: TabBar(
          tabs: <Widget>[Text("Timer"), Text("Stopwatch")],
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
        children: <Widget>[timer(), stopwatch()],
        controller: tc,
      ),
    );
  }

  // STOPWATCH
  bool startIsDisabled = true;
  bool stopIsDisabled = true;
  bool resetIsDisabled = true;
  String stopwatchTimeToDisplay = "00:000";
  var swatch = Stopwatch();
  final dur = const Duration(milliseconds: 1);

  void startSwatchTimer() {
    Timer(dur, keepRunning);
  }

  void keepRunning() {
    if (swatch.isRunning) {
      startSwatchTimer();
    }
    setState(() {
      stopwatchTimeToDisplay =
          (swatch.elapsed.inSeconds % 60).toString().padLeft(2, '0') +
              ":" +
              (swatch.elapsedMilliseconds % 1000).toString().padLeft(3, '0');
    });
  }

  void goButtonPressed() {
    setState(() {
      if (swatch.isRunning) {
        setState(() {
          swatch.stop();
        });
      } else {
        swatch.reset();
        stopwatchTimeToDisplay = "00:000";
        swatch.start();
        startSwatchTimer();
      }
    });
  }
}

Widget buildFloatingButton(String text, VoidCallback callback) {
  return new Container(
    width: 200.0,
    height: 200.0,
    child: FittedBox(
      child: FloatingActionButton(
        onPressed: callback,
        child: new Text(text),
      ),
    ),
  );
}
