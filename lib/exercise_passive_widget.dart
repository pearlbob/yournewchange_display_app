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

class _ExercisePassiveState extends State<ExercisePassiveWidget> {
  @override
  Widget build(BuildContext context) {
    final TextStyle themeStyle = Theme.of(context).textTheme.headlineLarge ?? TextStyle();

    var style = themeStyle.copyWith(fontSize: 48);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppSpace(
        verticalSpace: 20,
      ),
      Consumer<ClockRefreshNotifier>(
        builder: (context, clockRefreshNotifier, child) {
          return Text(DateFormat.jm().format(clockRefreshNotifier.now), style: style);
        },
      ),
      Consumer<ExerciseDataNotifier>(builder: (context, exerciseDataNotifier, child) {
        var exerciseData = exerciseDataNotifier.exerciseData;
        var currentTime = (exerciseData.currentRepetitions - (exerciseData.targetRepetitions ?? 0));
        return Column(
          children: [
            AppSpace(verticalSpace: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(exerciseData.exerciseName, style: style),
              ],
            ),
            AppSpace(verticalSpace: 40),
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
                          '(${currentTime.sign > 0 ? '+' : ''}$currentTime)',
                          style: style,
                        ),
                      ),
                    ),
                ],
              ),
            AppSpace(verticalSpace: 40),
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
