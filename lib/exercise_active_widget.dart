import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'main.dart';

class ExerciseActiveWidget extends StatefulWidget {
  const ExerciseActiveWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExerciseActiveState();
  }
}

class _ExerciseActiveState extends State<ExerciseActiveWidget> {
  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.headlineMedium ?? TextStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpace(
          verticalSpace: 20,
        ),
        Consumer<ClockRefreshNotifier>(
          builder: (context, clockRefreshNotifier, child) {
            return Text(DateFormat.jm().format(clockRefreshNotifier.now), style: style);
          },
        ),
        Consumer<ExerciseDataNotifier>(builder: (context, exerciseDataNotifier, child) {
          var exerciseData = exerciseDataNotifier.exerciseData.copy();

          // if (_exerciseNameTextEditingController.text.isEmpty)
          {
            _exerciseNameTextEditingController.text = exerciseData.exerciseName;
          }
          _repetitionTextEditingController.text = exerciseData.targetRepetitions.toString();
          _durationTextEditingController.text = (exerciseData.targetDuration?.inSeconds ?? 60).toString();

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Name:  ', style: style),
              AppTextField(
                controller: _exerciseNameTextEditingController,
                hintText: 'Name of the exercise',
                width: (style.fontSize ?? App.appDefaultFontSize) * 20,
                maxLines: 1,
                style: style,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      exerciseData.exerciseName = value;
                      exerciseDataNotifier.refresh(exerciseData);
                    });
                  }
                },
              ),
              AppSpace(),
              Text('Reps:  ', style: style),
              Text(
                '${exerciseData.currentRepetitions}',
                style: style,
              ),
              Text(
                ' / ',
                style: style,
              ),
              AppTextField(
                controller: _repetitionTextEditingController,
                keyboardType: TextInputType.number,
                hintText: 'reps',
                width: (style.fontSize ?? App.appDefaultFontSize) * 5,
                maxLines: 1,
                style: style,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      int? reps = int.tryParse(value);
                      if (reps != null) {
                        exerciseData.targetRepetitions = reps;
                        exerciseDataNotifier.refresh(exerciseData);
                      }
                    });
                  }
                },
              ),
              AppSpace(),
              Text('Duration:  ', style: style),
              AppTextField(
                controller: _durationTextEditingController,
                keyboardType: TextInputType.number,
                hintText: 'seconds',
                width: (style.fontSize ?? App.appDefaultFontSize) * 5,
                maxLines: 1,
                style: style,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      int? seconds = int.tryParse(value);
                      if (seconds != null) {
                        exerciseData.targetDuration = Duration(seconds: seconds);
                        exerciseDataNotifier.refresh(exerciseData);
                      }
                    });
                  }
                },
              ),
            ],
          );
        }),
      ],
    );
  }

  final TextEditingController _exerciseNameTextEditingController = TextEditingController();
  final TextEditingController _repetitionTextEditingController = TextEditingController();
  final TextEditingController _durationTextEditingController = TextEditingController();
}
