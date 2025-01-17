import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'exercise_data.dart';
import 'main.dart';

class ExercisePassiveWidget extends StatefulWidget {
  const ExercisePassiveWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExercisePassiveState();
  }
}

/// The passive display, that is the client facing display
class _ExercisePassiveState extends State<ExercisePassiveWidget> {
  @override
  Widget build(BuildContext context) {
    final fontSize = computeFontSize(context);
    final style = (Theme.of(context).textTheme.displayLarge ?? TextStyle()).copyWith(fontSize: fontSize);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
       Consumer<ClockRefreshNotifier>(
        builder: (context, clockRefreshNotifier, child) {
          return Text(DateFormat.jm().format(clockRefreshNotifier.now), style: style);
        },
      ),
      Consumer<ExerciseDataNotifier>(builder: (context, exerciseDataNotifier, child) {
        var exerciseData = exerciseDataNotifier.exerciseData;
        var currentRepetitions = (exerciseData.currentRepetitions - (exerciseData.targetRepetitions ?? 0));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpace(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(exerciseData.exerciseName, style: style),
              ],
            ),
            AppSpace(),
            Text('(video goes here)', style: style),
            AppSpace(),
            if (exerciseData.exerciseMetric == ExerciseMetric.repetitions)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Reps:     ', style: style),
                  Text(
                    '${exerciseData.currentRepetitions}',
                    style: style,
                  ),
                  if (exerciseData.targetRepetitions != null)
                    Text(
                      ' / ${exerciseData.targetRepetitions}',
                      style: style,
                    ),
                  AppSpace(),
                  if (exerciseData.targetRepetitions != null)
                    SizedBox(
                      width: (style.fontSize ?? App.defaultFontSize) * 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '(${currentRepetitions.sign > 0 ? '+' : ''}$currentRepetitions)',
                          style: style,
                        ),
                      ),
                    ),
                ],
              ),
            if (exerciseData.exerciseMetric == ExerciseMetric.time)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Duration:          ', style: style),
                  Text(
                    '${exerciseData.currentDuration}',
                    style: style,
                  ),
                  if (exerciseData.targetDuration != null)
                    Text(
                      ' / ${exerciseData.targetDuration}',
                      style: style,
                    ),
                ],
              ),
          ],
        );
      }),
    ]);
  }
}
