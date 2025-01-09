import 'package:flutter/material.dart';

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Name: ${exerciseData.exerciseName} ', style: style),
        AppSpace(),
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
      ],
    );
  }
}
