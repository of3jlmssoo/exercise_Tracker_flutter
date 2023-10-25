import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:logging/logging.dart';

import 'constants.dart';

const _uuid = Uuid();

final log = Logger('MainLogger');

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
    log.info('setDone($id)');
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
