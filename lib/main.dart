import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'timers.dart';
import 'constants.dart';
import 'exercise.dart';

final log = Logger('MainLogger');

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord rec) {
    debugPrint(
        '[${rec.loggerName}] ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  log.info('logging started');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(filteredExercises);
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
                  title: Text('exercise tracker',
                      style: TextStyle(
                          color: Color(myAppBarFontColor),
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold))),
            ),
            SliverList(
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
                              height: kMinInteractiveDimension, width: 2),
                          const Text("tap icon\nto start:",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(myTimeInfoFontColor),
                                  decoration: TextDecoration.none)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: kMinInteractiveDimension,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${ref.watch(periodicTimerProvider) ~/ 60}:${(ref.watch(periodicTimerProvider) % 60).toString().padLeft(2, '0')}',
                                      style: const TextStyle(
                                          fontSize: 30.0,
                                          color: Color(myTimeInfoFontColor),
                                          decoration: TextDecoration.none),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text("sec",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Color(myTimeInfoFontColor),
                                      decoration: TextDecoration.none)),
                              IconButton(
                                onPressed: () {
                                  ref
                                      .read(periodicTimerProvider.notifier)
                                      .canceltimer();
                                },
                                icon: const Icon(Icons.cancel),
                                color: const Color(myTimeInfoFontColor),
                              ),
                            ],
                          ),
                          const Text("remain:",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(myTimeInfoFontColor),
                                  decoration: TextDecoration.none)),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: kMinInteractiveDimension,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            color: Color(myTimeInfoFontColor),
                                            decoration: TextDecoration.none)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Row(children: [
                            IconButton(
                                onPressed: null,
                                icon: Icon(Icons.alarm,
                                    color: Color(myTimeInfoFontColor))),
                            IconButton(
                                onPressed: null,
                                icon: Icon(Icons.edit,
                                    color: Color(myTimeInfoFontColor))),
                          ]),
                          const SizedBox(width: 2.0),
                        ],
                      ));
                },
                childCount: 1,
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400.0,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 1.4),
              delegate: SliverChildListDelegate(
                [
                  for (int index = 0; index < exercises.length; index++) ...{
                    Card(
                      color: const Color(myCardColor),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        highlightColor: Colors.red,
                        splashColor: const Color(0xff445D48),
                        onTap: () {
                          if (exercises[index].name != 'core') {
                            log.info('Card InkWell onTap()');
                            SystemSound.play(SystemSoundType.click);
                            ref
                                .read(periodicTimerProvider.notifier)
                                .starttimer(() => {
                                      ref
                                          .read(exerciseListProvider.notifier)
                                          .toggleTitle(exercises[index].id),
                                      ref
                                          .read(exerciseListProvider.notifier)
                                          .setDone(exercises[index].id),
                                    });

                            ref
                                .read(exerciseListProvider.notifier)
                                .toggleTitle(exercises[index].id);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SoundTimer()));
                          }
                        },
                        child: Column(
                          children: [
                            // imageList[index].$1,
                            Text(exercises[index].name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: exercises[index].fontsize)),
                            SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.asset(exercises[index].imageasset,
                                    fit: BoxFit.contain)),
                            // imageList[index],
                          ],
                        ),
                      ),
                    ),
                  }
                ],
              ),
            ),
          ],
        ));
  }
}

final delayedDuration = StateProvider<int>((ref) => 1);
final soundTimerCounter = StateProvider<int>((ref) => 0);

class SoundTimer extends ConsumerWidget {
  const SoundTimer({super.key});

  void startSoundTimer({required WidgetRef ref, int counter = 5}) async {
    if (counter == 0) return;

    SystemSound.play(SystemSoundType.click);
    await Future.delayed(Duration(milliseconds: ref.watch(delayedDuration)));

    SystemSound.play(SystemSoundType.click);
    log.info(
        'startSoundTimer() next loop. duration:${ref.watch(delayedDuration)} - counter:$counter');
    ref.read(soundTimerCounter.notifier).update((state) => state - 1);
    startSoundTimer(ref: ref, counter: ref.watch(soundTimerCounter));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(myTimeAreaColor),
      appBar: AppBar(
          backgroundColor: const Color(myAppBarColor),
          title: const Text('Sound Timer for core training',
              style: TextStyle(color: Color(myAppBarFontColor)))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Counter:${ref.watch(soundTimerCounter)}',
              style: const TextStyle(
                  fontSize: 30, color: Color(myTimeInfoFontColor))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Duration:${ref.watch(delayedDuration)}',
                  style: const TextStyle(
                      fontSize: 25, color: Color(myTimeInfoFontColor))),
              const Text('ミリ秒',
                  style: TextStyle(
                      fontSize: 18, color: Color(myTimeInfoFontColor)))
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  color: const Color(myTimeInfoFontColor),
                  iconSize: 25,
                  icon: const Icon(Icons.add),
                  tooltip: 'Increase by $adjustmentUnitSeconds seconds',
                  onPressed: () {
                    ref.read(delayedDuration.notifier).update(
                        (state) => state + adjustmentUnitSeconds * 1000);
                  }),
              IconButton(
                  color: const Color(myTimeInfoFontColor),
                  iconSize: 25,
                  icon: const Icon(Icons.remove),
                  tooltip: 'Decrease by $adjustmentUnitSeconds seconds',
                  onPressed: () {
                    ref.read(delayedDuration.notifier).update(
                        (state) => state - adjustmentUnitSeconds * 1000);
                  }),
              const Text('$adjustmentUnitSeconds秒',
                  style: TextStyle(color: Color(myTimeInfoFontColor))),
              const SizedBox(width: 15),
              IconButton(
                color: const Color(myTimeInfoFontColor),
                iconSize: 25,
                icon: const Icon(Icons.add),
                tooltip: 'Increase by $adjustmentUnitMilliseconds milliseconds',
                onPressed: () {
                  ref
                      .read(delayedDuration.notifier)
                      .update((state) => state + adjustmentUnitMilliseconds);
                },
              ),
              IconButton(
                color: const Color(myTimeInfoFontColor),
                iconSize: 25,
                icon: const Icon(Icons.remove),
                tooltip: 'Decrease by $adjustmentUnitMilliseconds milliseconds',
                onPressed: () {
                  ref
                      .read(delayedDuration.notifier)
                      .update((state) => state - adjustmentUnitMilliseconds);
                },
              ),
              const Text('$adjustmentUnitMillisecondsミリ秒',
                  style: TextStyle(
                    color: Color(myTimeInfoFontColor),
                  )),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(myCardColor),
                foregroundColor: Colors.black),
            onPressed: () {
              ref.read(soundTimerCounter.notifier).update((state) => 10);
              ref.read(delayedDuration.notifier).update((state) => 2750);
              startSoundTimer(ref: ref, counter: ref.watch(soundTimerCounter));
            },
            child: const Text('start timer'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(myCardColor),
                foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ],
      ),
    );
  }
}
