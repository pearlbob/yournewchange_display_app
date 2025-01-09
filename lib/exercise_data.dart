import 'package:intl/intl.dart';

class ExerciseData {
  ExerciseData(this.exerciseName);

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
        '${targetRepetitions==null? '': '/$targetRepetitions'}'
        ', start: ${_displayTime(start)}'
        '${targetDuration == null ? '' : ', duration: ${targetDuration!.inSeconds}}'}'
        '}';
  }

  String exerciseName;
  int currentRepetitions = 0;
  int? targetRepetitions;
  DateTime start = DateTime.now();
  Duration? targetDuration;
}
