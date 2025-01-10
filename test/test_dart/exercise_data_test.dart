import 'package:logger/logger.dart';
import 'package:test/test.dart';
import 'package:yournewchange_display_app/app_logger.dart';
import 'package:yournewchange_display_app/exercise_data.dart';

void main() {
  Logger.level = Level.info;

  test('test display data', () {
    //  note that the display data class does not use flutter so it can be tested in dart

    ExerciseData exerciseData = ExerciseData();
    logger.i('$exerciseData'); //  toString() used
    var start = exerciseData.currentDuration;

    exerciseData.currentRepetitions++;
    exerciseData.targetRepetitions = 12;
    logger.i('$exerciseData');
    expect(exerciseData.currentRepetitions, 1);

    exerciseData.reset();
    expect(exerciseData.currentRepetitions, 0);
    expect(start.compareTo(exerciseData.currentDuration), 0); //  i.e. a new start on a reset
    logger.i('$exerciseData');

    // expect(dd.currentRepetitions, 123); //  sample test failure
  });

  test('test to/from json', () {
    //  note that the display data class does not use flutter so it can be tested in dart

    ExerciseData exerciseData = ExerciseData();
    logger.i('${exerciseData.toJson()}'); //  toString() used


    final encoded = exerciseData.toJson();
    // logger.i('$measure: $encoded');
    final copy = ExerciseData.fromJson(encoded);
    expect(copy, exerciseData);

    for ( var exerciseMetric in ExerciseMetric.values)
      {
        exerciseData = ExerciseData();
        exerciseData.exerciseMetric = exerciseMetric;

        for ( var exerciseName in ['curls', 'push-ups', 'pull/ups'])
        {
          exerciseData.exerciseName = exerciseName;

          for ( var targetRepetitions in [ 3, 10, 15])
          {
            exerciseData.targetRepetitions = targetRepetitions;
            for ( var targetDuration in [ 30, 45, 60]) {
              exerciseData.targetDuration = targetDuration;

              final encoded = exerciseData.toJson();
              logger.i('$exerciseData: $encoded');
              final copy = ExerciseData.fromJson(encoded);
              expect(copy, exerciseData);
            }
          }
        }

      }

    // var start = exerciseData.currentDuration;
    //
    // exerciseData.currentRepetitions++;
    // exerciseData.targetRepetitions = 12;
    // logger.i('$exerciseData');
    // expect(exerciseData.currentRepetitions, 1);
    //
    // exerciseData.reset();
    // expect(exerciseData.currentRepetitions, 0);
    // expect(start.compareTo(exerciseData.currentDuration), 0); //  i.e. a new start on a reset
    // logger.i('$exerciseData');
    //
    // // expect(dd.currentRepetitions, 123); //  sample test failure
  });
}
