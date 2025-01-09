import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
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
    final TextStyle? style = Theme.of(context).textTheme.headlineMedium;

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
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${exerciseData.exerciseName} ', style: style),
            AppSpace(horizontalSpace: 40,),
            Text('Repetitions:  ', style: style),
            Text(
              '${exerciseData.currentRepetitions}',
              style: style,
            ),
            if (exerciseData.targetRepetitions != null)
              Text(
                ' / ${exerciseData.targetRepetitions}',
                style: style,
              ),
            AppSpace(horizontalSpace: 40,),
            Text('Duration:  ', style: style),
            Text(
              '${exerciseData.start}',
              style: style,
            ),
            if (exerciseData.targetDuration != null)
              Text(
                ' / ${exerciseData.targetDuration!.inSeconds}',
                style: style,
              ),
          ],
        );
      }),
    ]);
  }
}
