enum ExerciseMetric {
  repetitions,
  time;
}

class ExerciseData {
  ExerciseData();

  void reset() {
    currentRepetitions = 0;
    targetRepetitions = null;
    currentDuration = 0;
    targetDuration = null;
  }

  @override
  String toString() {
    return 'DisplayData{exercise: $exerciseName'
        '${exerciseMetric == ExerciseMetric.repetitions //
            ? ', reps: $currentRepetitions ${targetRepetitions == null ? '' : '/$targetRepetitions'}' //
            : ''}'
        '${exerciseMetric == ExerciseMetric.time //
            ? ', start: $currentDuration'
                '${targetDuration == null ? '' : ', duration: $targetDuration'}' : ''}'
        '}';
  }

  ExerciseData copy() {
    ExerciseData copy = ExerciseData();
    copy.exerciseMetric = exerciseMetric;
    copy.exerciseName = exerciseName;
    copy.currentRepetitions = currentRepetitions;
    copy.targetRepetitions = targetRepetitions;
    copy.isRunning = isRunning;
    copy.currentDuration = currentDuration;
    copy.targetDuration = targetDuration;
    return copy;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseData &&
          runtimeType == other.runtimeType &&
          exerciseMetric == other.exerciseMetric &&
          exerciseName == other.exerciseName &&
          currentRepetitions == other.currentRepetitions &&
          targetRepetitions == other.targetRepetitions &&
          isRunning == other.isRunning &&
          currentDuration == other.currentDuration &&
          targetDuration == other.targetDuration;

  @override
  int get hashCode => Object.hash(
      exerciseMetric, exerciseName, currentRepetitions, targetRepetitions, isRunning, currentDuration, targetDuration);

  ExerciseMetric exerciseMetric = ExerciseMetric.repetitions;
  String exerciseName = 'curls'; //  default only
  int currentRepetitions = 0;
  int? targetRepetitions = 12; //  default only
  bool isRunning = false;
  int currentDuration = 0;
  int? targetDuration = 60; //  in seconds, default only
}