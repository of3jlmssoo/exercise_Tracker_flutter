import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'timers.dart';

final log = Logger('MainLogger');

const prepDuration = 2;
const int workoutDuration = 3;
const int totalDuration = prepDuration + workoutDuration;

int _selectedWorkout = -1;
bool _cancelTimer = false;
// const int NUMBER_OF_WORKOUT = 10;
const int myAppBarColor = 0xff2C3333;
// const int myCardColor = 0xff5B9A8B;
const int myCardColor = 0xff388e3c;
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
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord rec) {
    print('[${rec.loggerName}] ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  log.info('logging started');
  runApp(ProviderScope(child: const MyApp()));
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
      home: MyHomePage(title: 'exercise tracker'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  int _counter = 0;
  int _remainingTime = totalDuration; //initial time in seconds
  // int _selectedCard = -1;

  late Timer _timer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                                      // "$_remainingTime",
                                      // '${ref.watch(periodicTimerProvider) ~/ 60}:${ref.watch(periodicTimerProvider) % 60}',
                                      '${ref.watch(periodicTimerProvider) ~/ 60}:${(ref.watch(periodicTimerProvider) % 60).toString().padLeft(2, '0')}',
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
                                  // _cancelTimer = true;
                                  ref
                                      .read(periodicTimerProvider.notifier)
                                      .canceltimer();
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
              delegate: SliverChildListDelegate(
                [
                  for (int index = 0; index < imageList.length; index++) ...{
                    Card(
                        color: const Color(myCardColor),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          highlightColor: Colors.red,
                          splashColor: Colors.red,
                          onTap: () {
                            log.info('>>>>>>>>>>>> $alreadyTapped');
                            debugPrint('>>>>>> $alreadyTapped');
                            alreadyTapped.contains(index)
                                ? {}
                                : {
                                    SystemSound.play(SystemSoundType.click),
                                    ref
                                        .read(periodicTimerProvider.notifier)
                                        .starttimer(),
                                    alreadyTapped.add(index),
                                  };
                          },
                          child: Column(
                            children: [
                              imageList[index].$1,
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: (index != _selectedWorkout &&
                                        !alreadyRendered.contains(index))
                                    ? imageList[index].$2
                                    : imageListDone[index].$2,
                              ),
                              // imageList[index],
                            ],
                          ),
                        )),
                  }
                ],
              ),
            ),
          ],
        ));
  }
}
