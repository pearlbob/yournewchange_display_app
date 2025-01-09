import 'package:logger/logger.dart';
import 'package:test/test.dart';
import 'package:yournewchange_display_app/app_logger.dart';
import 'package:yournewchange_display_app/exercise_data.dart';

void main() {
  Logger.level = Level.info;

  test('test display data', () {
    //  note that the display data class does not use flutter so it can be tested in dart

    ExerciseData dd = ExerciseData();
    logger.i('$dd'); //  toString() used
    var start = dd.start;

    dd.currentRepetitions++;
    dd.targetRepetitions = 12;
    logger.i('$dd');
    expect(dd.currentRepetitions, 1);

    dd.reset();
    expect(dd.currentRepetitions, 0);
    assert(start.compareTo(dd.start) < 0); //  i.e. a new start on a reset
    logger.i('$dd');

    // expect(dd.currentRepetitions, 123); //  sample test failure
  });
}
