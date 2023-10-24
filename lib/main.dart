import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'timers.dart';

final log = Logger('MainLogger');
const _uuid = Uuid();

const prepDuration = 2;
const int workoutDuration = 3;
const int totalDuration = prepDuration + workoutDuration;

// int _selectedWorkout = -1;
// bool _cancelTimer = false;
// const int NUMBER_OF_WORKOUT = 10;

const double normalFontSize = 15.0;
const double largeFontSize = 24.0;
const int myAppBarColor = 0xff2C3333;
// const int myCardColor = 0xff5B9A8B;
const int myCardColor = 0xff5C8374;
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

final exerciseListProvider =
    NotifierProvider<ExerciseList, List<Exercise>>(ExerciseList.new);

enum ExerciseListFilter {
  all,
  active,
  completed,
}

final exerciseListFilter = StateProvider((_) => ExerciseListFilter.all);

final filteredExercises = Provider<List<Exercise>>((ref) {
  final filter = ref.watch(exerciseListFilter);
  final todos = ref.watch(exerciseListProvider);

  switch (filter) {
    case ExerciseListFilter.completed:
      return todos.where((todo) => todo.completed).toList();
    case ExerciseListFilter.active:
      return todos.where((todo) => !todo.completed).toList();
    case ExerciseListFilter.all:
      return todos;
  }
});

@immutable
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.imageasset,
    this.completed = false,
    this.fontsize = normalFontSize,
  });

  final String id;
  final String name;
  final String imageasset;
  final bool completed;
  final double fontsize;
}

class ExerciseList extends Notifier<List<Exercise>> {
  @override
  List<Exercise> build() => [
        const Exercise(
            id: 'exercise-0',
            name: 'pullDown',
            imageasset: 'images/pullDown.png'),
        const Exercise(
            id: 'exercise-1', name: 'pull', imageasset: 'images/pull.png'),
        const Exercise(
            id: 'exercise-2',
            name: 'openArms',
            imageasset: 'images/openArms.png'),
        const Exercise(
            id: 'exercise-3',
            name: 'closeArms',
            imageasset: 'images/closeArms.png'),
        const Exercise(
            id: 'exercise-4', name: 'core', imageasset: 'images/core.png'),
        const Exercise(
            id: 'exercise-5', name: 'core', imageasset: 'images/core.png'),
        const Exercise(
            id: 'exercise-6', name: 'push', imageasset: 'images/push.png'),
        const Exercise(
            id: 'exercise-7',
            name: 'hamstring',
            imageasset: 'images/hamstring.png'),
        const Exercise(
            id: 'exercise-8',
            name: 'openFeet',
            imageasset: 'images/openFeet.png'),
        const Exercise(
            id: 'exercise-9',
            name: 'closeFeet',
            imageasset: 'images/closeFeet.png'),
      ];

  void add(String name, String imageasset) {
    state = [
      ...state,
      Exercise(
        id: _uuid.v4(),
        name: name,
        imageasset: imageasset,
      ),
    ];
  }

  void setDone(String id) {
    log.info('setDone(${id})');
    state = [
      for (final exercise in state)
        if (exercise.id == id)
          Exercise(
            id: exercise.id,
            completed: !exercise.completed,
            name: exercise.name,
            imageasset: 'images/done.png',
            fontsize: normalFontSize,
          )
        else
          exercise,
    ];
  }

  void toggleTitle(String id) {
    state = [
      for (final exercise in state)
        if (exercise.id == id)
          Exercise(
              id: exercise.id,
              completed: !exercise.completed,
              name: exercise.name,
              imageasset: exercise.imageasset, //'images/done.png',
              fontsize: largeFontSize)
        else
          exercise,
    ];
  }
}

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord rec) {
    print('[${rec.loggerName}] ${rec.level.name}: ${rec.time}: ${rec.message}');
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
        useMaterial3: true,
      ),
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
                          const Text(
                            "remain:",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(myTimeInfoFontColor),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: kMinInteractiveDimension,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '0',
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
                      ));
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
                  for (int index = 0; index < exercises.length; index++) ...{
                    Card(
                      color: Color(myCardColor),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        highlightColor: Colors.red,
                        splashColor: Color(0xff445D48),
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
                                  builder: (context) => const SoundTimer()),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            // imageList[index].$1,
                            Text(
                              exercises[index].name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: exercises[index].fontsize),
                            ),
                            SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.asset(
                                  exercises[index].imageasset,
                                  fit: BoxFit.contain,
                                )),
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

// void startbeeptimer() {
//   log.info('startbeeptimer()');
//   var counter = 5;
//   SystemSound.play(SystemSoundType.click);
//   Timer.periodic(Duration(seconds: dura), (timer) {
//     SystemSound.play(SystemSoundType.click);
//     print(timer.tick);
//     counter--;
//     if (counter == 0) {
//       print('Cancel timer');
//       timer.cancel();
//     }
//   });
// }

// final timerValProvider = NotifierProvider<TimerVal, int>(TimerVal.new);

// class TimerVal extends Notifier<int> {
//   @override
//   int build() => 1;
// }

final delayedDuration = StateProvider<int>((ref) => 1);
final soundTimerCounter = StateProvider<int>((ref) => 0);

class SoundTimer extends ConsumerWidget {
  const SoundTimer({super.key});

  void startbeeptimer({required WidgetRef ref, int counter = 5}) async {
    // log.info('startbeeptimer() counter:$counter');
    if (counter == 0) return;

    SystemSound.play(SystemSoundType.click);
    await Future.delayed(Duration(seconds: ref.watch(delayedDuration)));

    SystemSound.play(SystemSoundType.click);
    log.info(
        'startbeeptimer() next loop. duration:${ref.watch(delayedDuration)} - counter:$counter');
    ref.read(soundTimerCounter.notifier).update((state) => state - 1);
    startbeeptimer(ref: ref, counter: ref.watch(soundTimerCounter));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sound Timer for core training'),
      ),
      body: Column(
        children: [
          Text('${ref.watch(soundTimerCounter)}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Increase volume by 1',
                onPressed: () {
                  ref
                      .read(delayedDuration.notifier)
                      .update((state) => state + 1);
                },
              ),
              Text('${ref.watch(delayedDuration)}'),
              IconButton(
                icon: const Icon(Icons.remove),
                tooltip: 'Increase volume by 10',
                onPressed: () {
                  ref
                      .read(delayedDuration.notifier)
                      .update((state) => state - 1);
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(soundTimerCounter.notifier).update((state) => 20);
              startbeeptimer(ref: ref, counter: ref.watch(delayedDuration));
            },
            child: Text('start timer ${ref.watch(delayedDuration)}'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ],
      ),
    );
  }
}
