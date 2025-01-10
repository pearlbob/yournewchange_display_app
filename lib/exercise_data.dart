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

  Map<String, dynamic> toJson() => {
        'exerciseMetric': exerciseMetric.name,
        'exerciseName': exerciseName,
        'currentRepetitions': currentRepetitions,
        'targetRepetitions': targetRepetitions,
        //not required 'isRunning': isRunning,
        'currentDuration': currentDuration,
        'targetDuration': targetDuration,
      };

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    var ret = ExerciseData();
    var name = json['exerciseMetric'];
    ret.exerciseMetric = ExerciseMetric.values.where((e) => e.name == name).first;
    ret.exerciseName = json['exerciseName'];
    ret.currentRepetitions = json['currentRepetitions'];
    ret.targetRepetitions = json['targetRepetitions'];
    //not required  ret.isRunning = json['isRunning'];
    ret.currentDuration = json['currentDuration'];
    ret.targetDuration = json['targetDuration'];
    return ret;
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

  //  class variables
  ExerciseMetric exerciseMetric = ExerciseMetric.repetitions;
  String exerciseName = 'curls'; //  default only
  //  hints:
  //  double weight = 0;  //  in pounds?
  //   List<String> bandColors = [];
  int currentRepetitions = 0;
  int? targetRepetitions = 12; //  default only
  bool isRunning = false;
  int currentDuration = 0;
  int? targetDuration = 60; //  in seconds, default only
//  hints:
//  DateTime startTime = DateTime.now();
//  DateTime endTime = DateTime.now();//  default only
}
