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
// import 'package:just_audio/just_audio.dart';

const prepDuration = 2;
const int workoutDuration = 3;
const int totalDuration = prepDuration + workoutDuration;

int _selectedWorkout = -1;
bool _cancelTimer = false;
// const int NUMBER_OF_WORKOUT = 10;
const int myAppBarColor = 0xff2C3333;
const int myCardColor = 0xff5B9A8B;
const int myTimeAreaColor = 0xff2E4F4F;
const int myMainContainerColor = myTimeAreaColor;
// const int myAppBarFontColor = 0xFF90a4ae;
// const int myTimeInfoFontColor = 0xFfcfd8dc;
const int myAppBarFontColor = 0xFFB0BEC5;
const int myTimeInfoFontColor = 0xFF78909C;
const int myTimeInfoFontColorInvisible = 0x0078909C;

Set<int> alreadyRendered = {};
Set<int> alreadyTapped = {};

List imageListDone = [
  (
    const Text('Done'),
    Image.asset(
      'images/done.png',
      fit: BoxFit.contain,
    )
  )
];
List imageList = [
  (
    const Text('pullDown'),
    Image.asset(
      'images/pullDown.png',
      fit: BoxFit.contain,
    )
  ),
  (
    const Text('pull'),
    Image.asset(
      'images/pull.png',
      fit: BoxFit.contain,
    )
  ),
  (
    const Text('openArms'),
    Image.asset(
      'images/openArms.png',
      fit: BoxFit.contain,
    )
  ),
  (
    const Text('closeArms'),
    Image.asset(
      'images/closeArms.png',
      fit: BoxFit.contain,
    )
  ),
  (
    const Text('core'),
    Image.asset(
      'images/core.png',
      fit: BoxFit.contain,
    )
  ),
  (
    const Text('core'),
    Image.asset(
      'images/core.png',
      fit: BoxFit.contain,
    )
  ),
  (
    const Text('push'),
    Image.asset(
      'images/push.png',
      fit: BoxFit.contain,
    )
  ),
  (
    const Text('hamstring'),
    Image.asset(
      'images/hamstring.png',
      fit: BoxFit.contain,
    )
  ),
  (
    const Text('openFeet'),
    Image.asset(
      'images/openFeet.png',
      fit: BoxFit.contain,
    )
  ),
  (
    const Text('closeFeet'),
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
  int _remainingTime = totalDuration; //initial time in seconds
  // int _selectedCard = -1;

  late Timer _timer;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _startTimer(int index) {
    setState(() {
      _remainingTime = totalDuration;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_cancelTimer) {
          // final player = AudioPlayer(); // Create a player
          // final duration = player.setAsset('audio/notify.mp3');
          // player.play();
          debugPrint('--> _cancelTimer true');

          _timer.cancel();

          _remainingTime = totalDuration;
          alreadyRendered.remove(index);
          alreadyTapped.remove(index);
          // _selected_workout = index;
          _cancelTimer = false;
        } else if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          // final player = AudioPlayer(); // Create a player
          // final duration = player.setAsset('audio/notify.mp3');
          // player.play();
          SystemSound.play(SystemSoundType.click);
          debugPrint('--> elapsed');

          _timer.cancel();
          _selectedWorkout = index;
          alreadyRendered.add(index);
          _remainingTime = totalDuration;
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
        color: const Color(myMainContainerColor),
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
                      color: const Color(myTimeAreaColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: kMinInteractiveDimension,
                            width: 2,
                          ),
                          const Text(
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
                                      style: const TextStyle(
                                          fontSize: 30.0,
                                          color: Color(myTimeInfoFontColor),
                                          decoration: TextDecoration.none),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),

                              const Text(
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
                                  _cancelTimer = true;
                                },
                                icon: const Icon(Icons.cancel),
                                color: const Color(myTimeInfoFontColor),
                              ),
                            ],
                          ),

                          const Text(
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
                                      style: const TextStyle(
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
                          const Row(children: [
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

                          const SizedBox(
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
              delegate: SliverChildListDelegate([
                Card(
                    color: const Color(myCardColor),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () {
                        debugPrint('>>>>>> $alreadyTapped');
                        alreadyTapped.contains(0)
                            ? {}
                            : {
                                SystemSound.play(SystemSoundType.click),
                                // _selected_workout = index,
                                _incrementCounter(),
                                _startTimer(0),
                                alreadyTapped.add(0)
                              };
                      },
                      child: Column(
                        children: [
                          imageList[0].$1,
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: (0 != _selectedWorkout &&
                                    !alreadyRendered.contains(0))
                                ? imageList[0].$2
                                : imageListDone[0].$2,
                          ),
                          // imageList[index],
                        ],
                      ),
                    )),
              ]),
              // delegate: SliverChildBuilderDelegate(
              //   (BuildContext context, int index) {
              //     // done: need to be clickable
              //     return Card(
              //       // color: Colors.limeAccent,
              //       color: const Color(myCardColor),
              //       clipBehavior: Clip.hardEdge,
              //       child: InkWell(
              //         onTap: () {
              //           debugPrint('>>>>>> $alreadyTapped');
              //           alreadyTapped.contains(index)
              //               ? {}
              //               : {
              //                   SystemSound.play(SystemSoundType.click),
              //                   // _selected_workout = index,
              //                   _incrementCounter(),
              //                   _startTimer(index),
              //                   alreadyTapped.add(index)
              //                 };
              //         },
              //         child: Column(
              //           children: [
              //             imageList[index].$1,
              //             SizedBox(
              //               width: 100,
              //               height: 100,
              //               child: (index != _selectedWorkout &&
              //                       !alreadyRendered.contains(index))
              //                   ? imageList[index].$2
              //                   : imageListDone[0].$2,
              //             ),
              //             // imageList[index],
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              //   childCount: imageList.length,
              // ),
            ),
          ],
        ));
  }
}
