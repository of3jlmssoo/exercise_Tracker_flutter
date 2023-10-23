import 'package:exercise_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import 'package:logging/logging.dart';

final log = Logger('TimerLogger');

const timePeriodValue = 5;

final periodicTimerProvider =
    StateNotifierProvider<PeriodicTimerStateNotifier, int>((ref) {
  return PeriodicTimerStateNotifier();
});

class PeriodicTimerStateNotifier extends StateNotifier<int> {
  // PeriodicTimerStateNotifier({required int i}) : super(i);
  PeriodicTimerStateNotifier() : super(timePeriodValue);

  int originalTimePeriod = 0;

  Timer? timerobj;
  void set(int newval) {
    state = newval;
  }

  // int get m => state ~/ 60;
  // int get s => state % 60;

  void reset() {
    state = originalTimePeriod;
  }

  // void starttimer(int counter) {
  void starttimer(Function func) {
    if (originalTimePeriod == 0) originalTimePeriod = state;
    int counter = state;
    log.info('periodicTimer started counter:$counter and state:$state');
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        timerobj = timer;
        log.info(
            'periodicTimer timer.tick:${timer.tick}, counter:$counter and state:$state');

        counter--;
        state = counter;
        if (counter == 0) {
          log.info('periodicTimer Cancel timer');
          timer.cancel();
          func();
          // set(timePeriodValue);
          reset();
        }
      },
    );
  }

  void canceltimer() {
    if (timerobj != null) {
      timerobj!.cancel();
      reset();
    }
    timerobj = null;
  }
}
