// todo: the color of the cancel icon
// todo: visibility of the cancel icon
//        when the timer is running, visible
//        otherwise non-visible

// todo: move time info are to "title"

// done: make the cancel icon functional
// todo: test the cancel function

// todo: reverse the workout counter. use alreadyRendered length
// todo: move time info area layout to an another .dart

// done:    tap icon to start  5:15 sec  ✖ ⏰   🖊  remaings
// done: group "5 sec cancel icon"
// done: group "alarm icon and edit icons"
// done:  add "remaing:" on the top of the time info area before the count
// todo: make the timer(alarm) icon functional, showimepiicker to set the duration
// todo: make workout menu icon functional

// todo: make a hamburger icon on the right hand side of the information area
// todo: move the alarm icon and the edit icon to the hamburger icon
// todo: make a new icon, view, to show the workout log

// todo: scheduleTimeout to make beep sounds. at the end of prep and workout
// done: make beep sound at the end of the workout

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
// import 'package:tuple/tuple.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';

const int PREP_DURATION = 2;
const int WORKOUT_DURATION = 5;
const int TOTAL_DURATION = PREP_DURATION + WORKOUT_DURATION;

int _selected_workout = -1;
bool _cancelthetimer = false;
// const int NUMBER_OF_WORKOUT = 10;
const int myAppBarColor = 0xff2C3333;
const int myCardColor = 0xff5B9A8B;
const int myTimeAreaColor = 0xff2E4F4F;
const int myMainContainerColor = myTimeAreaColor;
// const int myAppBarFontColor = 0xFF90a4ae;
// const int myTimeInfoFontColor = 0xFfcfd8dc;
const int myAppBarFontColor = 0xFFB0BEC5;
const int myTimeInfoFontColor = 0xFF78909C;
const int myTimeInfoFontColorinvisible = 0x0078909C;

Set<int> alreadyRendered = Set();
Set<int> alreadyTapped = Set();

List imageListDone = [
  (
    Text('Done'),
    Image.asset(
      'images/done.png',
      fit: BoxFit.contain,
    )
  )
];
List imageList = [
  (
    Text('pullDown'),
    Image.asset(
      'images/pullDown.png',
      fit: BoxFit.contain,
    )
  ),
  (
    Text('pull'),
    Image.asset(
      'images/pull.png',
      fit: BoxFit.contain,
    )
  ),
  (
    Text('openArms'),
    Image.asset(
      'images/openArms.png',
      fit: BoxFit.contain,
    )
  ),
  (
    Text('closeArms'),
    Image.asset(
      'images/closeArms.png',
      fit: BoxFit.contain,
    )
  ),
  (
    Text('core'),
    Image.asset(
      'images/core.png',
      fit: BoxFit.contain,
    )
  ),
  (
    Text('core'),
    Image.asset(
      'images/core.png',
      fit: BoxFit.contain,
    )
  ),
  (
    Text('push'),
    Image.asset(
      'images/push.png',
      fit: BoxFit.contain,
    )
  ),
  (
    Text('hamstring'),
    Image.asset(
      'images/hamstring.png',
      fit: BoxFit.contain,
    )
  ),
  (
    Text('openFeet'),
    Image.asset(
      'images/openFeet.png',
      fit: BoxFit.contain,
    )
  ),
  (
    Text('closeFeet'),
    Image.asset(
      'images/closeFeet.png',
      fit: BoxFit.contain,
    )
  ),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'exercise tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _remainingTime = TOTAL_DURATION; //initial time in seconds
  int _selectedCard = -1;

  late Timer _timer;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _startTimer(int index) {
    setState(() {
      _remainingTime = TOTAL_DURATION;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_cancelthetimer) {
          final player = AudioPlayer(); // Create a player
          final duration = player.setAsset('audio/notify.mp3');
          player.play();

          _timer.cancel();

          _remainingTime = TOTAL_DURATION;
          alreadyRendered.remove(index);
          alreadyTapped.remove(index);
          // _selected_workout = index;
          _cancelthetimer = false;
        } else if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          final player = AudioPlayer(); // Create a player
          final duration = player.setAsset('audio/notify.mp3');
          player.play();

          _timer.cancel();
          _selected_workout = index;
          alreadyRendered.add(index);
          _remainingTime = TOTAL_DURATION;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(myMainContainerColor),
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              floating: false,
              backgroundColor: Color(myAppBarColor),
              centerTitle: true,
              pinned: true,
              expandedHeight: 50.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'exercise tracker',
                  style: TextStyle(
                      color: Color(myAppBarFontColor),
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverList(
              // delegate: SliverChildBuilderDelegate(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                      alignment: Alignment.bottomLeft,
                      color: Color(myTimeAreaColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: kMinInteractiveDimension,
                            width: 2,
                          ),
                          Text(
                            "tap icon\nto start:",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(myTimeInfoFontColor),
                              decoration: TextDecoration.none,
                            ),
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: kMinInteractiveDimension,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$_remainingTime",
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Color(myTimeInfoFontColor),
                                          decoration: TextDecoration.none),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),

                              Text(
                                "sec",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Color(myTimeInfoFontColor),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              // ),
                              IconButton(
                                // iconSize: 12.0,
                                onPressed: () {
                                  _cancelthetimer = true;
                                },
                                icon: const Icon(Icons.cancel),
                                color: Color(myTimeInfoFontColor),
                              ),
                            ],
                          ),

                          Text(
                            "remain:",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(myTimeInfoFontColor),
                              decoration: TextDecoration.none,
                            ),
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: kMinInteractiveDimension,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$_counter',
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Color(myTimeInfoFontColor),
                                          decoration: TextDecoration.none),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // todo: replay and stop icons need to be clickable
                          Row(children: [
                            IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.alarm,
                                color: Color(myTimeInfoFontColor),
                              ),
                            ),
                            IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.edit,
                                color: Color(myTimeInfoFontColor),
                                // size: 15.0,
                              ),
                            ),
                          ]),

                          SizedBox(
                            width: 2.0,
                          ),
                        ],
                      )
                      // done:need to two icons, play and reset
                      );
                },
                childCount: 1,
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400.0,
                // mainAxisExtent: 138,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.4,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // done: need to be clickable
                  return Card(
                    // color: Colors.limeAccent,
                    color: Color(myCardColor),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () {
                        debugPrint('>>>>>> $alreadyTapped');
                        alreadyTapped.contains(index)
                            ? {}
                            : {
                                SystemSound.play(SystemSoundType.click),
                                // _selected_workout = index,
                                _incrementCounter(),
                                _startTimer(index),
                                alreadyTapped.add(index)
                              };
                      },
                      child: Column(
                        children: [
                          imageList[index].$1,
                          Container(
                            width: 100,
                            height: 100,
                            child: (index != _selected_workout &&
                                    !alreadyRendered.contains(index))
                                ? imageList[index].$2
                                : imageListDone[0].$2,
                          ),
                          // imageList[index],
                        ],
                      ),
                    ),
                  );
                },
                childCount: imageList.length,
              ),
            ),
          ],
        ));
  }
}
