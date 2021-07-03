import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
// int endTime  = DateTime.now().millisecondsSinceEpoch + 1000 * 25 * 60;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Simple Timer',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Icon playIcon = Icon(Icons.play_circle_filled, color: Colors.green);
  bool bTimerIsRunning = false;
  bool bResumeTimer = false;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 90;
  CountdownTimerController controller = CountdownTimerController(
      endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 60);
  var timerObject = CountdownTimer(
      controller: CountdownTimerController(
          endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 60),
      endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 90,
      endWidget: Text("ended1"),
      textStyle: TextStyle());
  Text pausedTimerText = Text("");
  TextStyle timerTextStyle = TextStyle(
      backgroundColor: Colors.white.withOpacity(.5),
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontSize: 34.0,
      // decoration: TextDecoration.underline,
      // decorationColor: Colors.red,
      decorationStyle: TextDecorationStyle.dotted);
  var floatingActionButtonShape = RoundedRectangleBorder(
      side: BorderSide(color: Colors.pink, width: 4.0),
      borderRadius: BorderRadius.all(Radius.circular(16.0)));

  var backgroundImage = AssetImage("images/background-phb4.jpg");

  //Drop down
  String dropdownTimerOptionValue = "25 minutes";
  bool bStartNewTimer = true;
  bool bEnableDropDownTimerOptionList = true;

  void _PauseTimer() {
    playIcon = Icon(Icons.play_circle_filled);
    bTimerIsRunning = false;
    bResumeTimer = false;
    pausedTimerText = Text("", style: timerTextStyle);
  }

  void PauseTimer() {
    print("paused timer");
    print("    " + controller.currentRemainingTime.toString());

    // Pause the timer
    _PauseTimer();

    // formulate paused timer string because timer object does not display timer after getting disposed.
    if (controller.currentRemainingTime != null) {
      String secString = "00";
      if (controller.currentRemainingTime!.sec != null) {
        secString =
            controller.currentRemainingTime!.sec!.toString().padLeft(2, '0');
      }
      String hourString = "00";
      if (controller.currentRemainingTime!.hours != null) {
        hourString =
            controller.currentRemainingTime!.hours!.toString().padLeft(2, '0');
      }
      String minString = "00";
      if (controller.currentRemainingTime!.min != null) {
        minString =
            controller.currentRemainingTime!.min!.toString().padLeft(2, '0');
      }
      pausedTimerText =
          Text("$hourString : $minString : $secString", style: timerTextStyle);
    }
    print(("    timer text:") + pausedTimerText.toString());

    // todo: find better way to pause timer instead of disposing and recreating object because it is better to reuse than to keep deleting and creating new objects
    controller.disposeTimer();
  }

  void onTimerEnd(){
    backgroundImage = AssetImage("images/success-phb.gif");
  }

  void StartOrResumeTimer() {
    ///Update play icon
    playIcon = Icon(
      Icons.pause_circle_filled,
      color: Colors.blue,
    );

    ///Update whether timer is running or paused
    bTimerIsRunning = true;
    print("started timer");

    ///Seconds in an hour
    int hourSecond = 60 * 60;

    ///Seconds in a minute
    int minuteSecond = 60;

    ///Set total remaining seconds to resume timer or to start a new timer
    var totalRemainingSeconds =
        DateTime.now().millisecondsSinceEpoch + 1000 * 90;

    ///Set total remaining seconds to the remaining seconds if timer was paused
    if (!bStartNewTimer && controller.currentRemainingTime != null) {
      if (controller.currentRemainingTime!.sec != null) {
        totalRemainingSeconds = controller.currentRemainingTime!.sec!;
      }
      if (controller.currentRemainingTime!.hours != null) {
        totalRemainingSeconds +=
            controller.currentRemainingTime!.hours! * hourSecond;
      }
      if (controller.currentRemainingTime!.min != null) {
        totalRemainingSeconds +=
            controller.currentRemainingTime!.min! * minuteSecond;
      }
      totalRemainingSeconds =
          totalRemainingSeconds * 1000 + DateTime.now().millisecondsSinceEpoch;
      print("    existing timer");
    } else {
      ///Set total remaining secodns to the option chosen from drop down menu to start a new timer
      print("    new timer");
      if (dropdownTimerOptionValue == "25 minutes") {
        totalRemainingSeconds =
            DateTime.now().millisecondsSinceEpoch + 1000 * 25;
            //suja delete
        totalRemainingSeconds = DateTime.now().millisecondsSinceEpoch + 1000 * 5;
      } else if (dropdownTimerOptionValue == "1 hour") {
        totalRemainingSeconds =
            DateTime.now().millisecondsSinceEpoch + 1000 * 60;
      } else if (dropdownTimerOptionValue == "1 hour 30 minutes") {
        totalRemainingSeconds =
            DateTime.now().millisecondsSinceEpoch + 1000 * 90;
      }
      bEnableDropDownTimerOptionList = false;
    }

    ///Create a new controller
    controller = CountdownTimerController(endTime: totalRemainingSeconds);

    ///Create a new timer object
    timerObject = CountdownTimer(
        controller: controller,
        textStyle: timerTextStyle,
        onEnd: () {
                      setState(() {
                        backgroundImage = AssetImage("images/success-phb.gif");
                      });
                  },
    );   
    ///Resume timer
    bResumeTimer = true;

    ///Timer started, hence next time this function is called, resume existing timer instead of starting new timer.
    bStartNewTimer = false;
  }

  @protected
  @mustCallSuper
  void initState() {
    ///Setup paused timer text so that the alignment does not change when starting new timer for first time
    pausedTimerText = Text("", style: timerTextStyle);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backgroundImage,  
            // image: new AssetImage("images/success-phb.gif"),
            fit: BoxFit.scaleDown,
          ),
        ),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Container(
            height: 200,
            width: 170,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(.2)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                bResumeTimer
                    ? timerObject
                    : pausedTimerText, // Timer object or text to display when paused
                IgnorePointer(
                  // Drop down list to chose timer options from
                  ignoring: !bEnableDropDownTimerOptionList,
                  child: DropdownButton<String>(
                    items: <String>['25 minutes', '1 hour', '1 hour 30 minutes']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                color: Colors.yellowAccent,
                                backgroundColor: Colors.blueAccent),
                          ));
                    }).toList(),
                    autofocus: true,
                    disabledHint:
                        Text("Wait till the timer ends. Just.. Just.. Wait"),
                    focusColor: Colors.blueAccent,
                    dropdownColor: Colors.blueAccent,
                    hint: Text("Chose your timer option"),
                    value: dropdownTimerOptionValue,
                    icon: const Icon(Icons.arrow_downward_rounded,
                        color: Colors.yellowAccent),
                    iconSize: 16,
                    iconDisabledColor: Colors.black,
                    iconEnabledColor: Colors.yellow,
                    elevation: 16,
                    style: const TextStyle(
                        color: Colors.yellowAccent,
                        backgroundColor: Colors.blueAccent),
                    underline: Container(
                      height: 3,
                      color: Colors.yellow,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownTimerOptionValue = newValue!;
                        bStartNewTimer = true;
                      });
                    },
                  ),
                ),
                Row(
                    // Play and Stop buttons in a single row
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Play button
                      FloatingActionButton(
                        onPressed: () => setState(() {
                          if (bTimerIsRunning) {
                            PauseTimer();
                          } else {
                            StartOrResumeTimer();
                          }
                        }),
                        tooltip:
                            bTimerIsRunning ? "Pause Timer" : "Start Timer",
                        foregroundColor: Colors.green,
                        backgroundColor: Colors.pink,
                        mini: false,
                        shape: floatingActionButtonShape,
                        child: playIcon,
                      ),
                      // Stop button
                      FloatingActionButton(
                        heroTag: "stop_button",
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.grey,
                        elevation: 16,
                        focusColor: Colors.yellowAccent,
                        child: const Icon(Icons.stop_sharp),
                        focusElevation: 26,
                        highlightElevation: 36,
                        hoverElevation: 20,
                        mini: false,
                        shape: floatingActionButtonShape,
                        tooltip:
                            "Stop timer. Or would you rather finish what you started?",
                        onPressed: () => setState(() {
                          print("stopped timer");
                          _PauseTimer();
                          bStartNewTimer = true;
                          bEnableDropDownTimerOptionList = true;
                          controller.disposeTimer();
                        }),
                      ), // This trailing comma makes auto-formatting nicer for build methods.
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
