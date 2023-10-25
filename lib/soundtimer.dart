import 'package:exercise_tracker/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import 'constants.dart';

final log = Logger('SoundTimerLogger');

final delayedDuration = StateProvider<int>((ref) => 1);
final soundTimerCounter = StateProvider<int>((ref) => 0);

class SoundTimer extends ConsumerWidget {
  const SoundTimer({super.key, required String this.id});
  // SoundTimer({required this.cbf});
  // Function cbf;
  final String id;

  void startSoundTimer(
      {required WidgetRef ref, int counter = 5, required String id}) async {
    if (counter == 0) {
      ref.read(exerciseListProvider.notifier).setDone(id);
      return;
    }

    SystemSound.play(SystemSoundType.click);
    await Future.delayed(Duration(milliseconds: ref.watch(delayedDuration)));

    SystemSound.play(SystemSoundType.click);
    log.info(
        'startSoundTimer() next loop. duration:${ref.watch(delayedDuration)} - counter:$counter');
    ref.read(soundTimerCounter.notifier).update((state) => state - 1);
    startSoundTimer(ref: ref, counter: ref.watch(soundTimerCounter), id: id);
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
                    ref.read(delayedDuration.notifier).update((state) =>
                        ((state - adjustmentUnitSeconds * 1000) > 0)
                            ? state - adjustmentUnitSeconds * 1000
                            : 0);
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
                  ref.read(delayedDuration.notifier).update((state) =>
                      ((state - adjustmentUnitMilliseconds) > 0)
                          ? state - adjustmentUnitMilliseconds
                          : 0);
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
              startSoundTimer(
                  ref: ref, counter: ref.watch(soundTimerCounter), id: id);
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
