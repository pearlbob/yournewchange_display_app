import 'package:intl/intl.dart';

class ExerciseData {
  ExerciseData();

  void reset() {
    currentRepetitions = 0;
    targetRepetitions = null;
    start = DateTime.now();

    targetDuration = null;
  }

  String _displayTime(final DateTime dateTime) {
    return DateFormat.Hms().format(dateTime);
  }

  @override
  String toString() {
    return 'DisplayData{exercise: $exerciseName, reps: $currentRepetitions'
        '${targetRepetitions == null ? '' : '/$targetRepetitions'}'
        ', start: ${_displayTime(start)}'
        '${targetDuration == null ? '' : ', duration: ${targetDuration!.inSeconds}}'}'
        '}';
  }

  ExerciseData copy() {
    ExerciseData copy = ExerciseData();
    copy.exerciseName = exerciseName;
    copy.currentRepetitions = currentRepetitions;
    copy.targetRepetitions = targetRepetitions;
    copy.start = start;
    copy.targetDuration = targetDuration;
    return copy;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseData &&
          runtimeType == other.runtimeType &&
          exerciseName == other.exerciseName &&
          currentRepetitions == other.currentRepetitions &&
          targetRepetitions == other.targetRepetitions &&
          start == other.start &&
          targetDuration == other.targetDuration;

  @override
  int get hashCode => Object.hash(exerciseName, currentRepetitions, targetRepetitions,
      start, targetDuration);

  String exerciseName = 'curls';  //  default only
  int currentRepetitions = 0;
  int? targetRepetitions = 12;  //  default only
  DateTime start = DateTime.now();
  Duration? targetDuration = Duration(seconds: 60);//  default only
}
