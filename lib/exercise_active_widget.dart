import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'exercise_data.dart';
import 'main.dart';

class ExerciseActiveWidget extends StatefulWidget {
  const ExerciseActiveWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExerciseActiveState();
  }
}

/// The inter active display, that is the coach facing display
class _ExerciseActiveState extends State<ExerciseActiveWidget> {
  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.headlineLarge ?? TextStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  clock
        AppSpace(
          verticalSpace: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<ClockRefreshNotifier>(
              builder: (context, clockRefreshNotifier, child) {
                return Text(DateFormat.jm().format(clockRefreshNotifier.now), style: style);
              },
            ),
            Consumer<ClockRefreshNotifier>(
              builder: (context, clockRefreshNotifier, child) {
                return Text('${50-clockRefreshNotifier.now.minute} min left', style: style);
              },
            ),
            appButton('next', onPressed: (){}),
          ],
        ),
        Consumer<ExerciseDataNotifier>(builder: (context, exerciseDataNotifier, child) {
          var exerciseData = exerciseDataNotifier.exerciseData;

          if ( _firstDisplay) {
            _firstDisplay = false;
            _exerciseNameTextEditingController.text = exerciseData.exerciseName;
            _repetitionTextEditingController.text = exerciseData.targetRepetitions.toString();
            _durationTextEditingController.text = (exerciseData.targetDuration ?? 60).toString();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Exercise:  ', style: style),
                  AppTextField(
                    controller: _exerciseNameTextEditingController,
                    hintText: 'Name of the exercise',
                    width: (style.fontSize ?? App.defaultFontSize) * 20,
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
                ],
              ),
              AppSpace(),
              SegmentedButton<ExerciseMetric>(
                showSelectedIcon: false,
                style: ButtonStyle(
                  visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
                ),
                segments: <ButtonSegment<ExerciseMetric>>[
                  ButtonSegment<ExerciseMetric>(
                    label: Text(
                      'Reps',
                      style: style,
                    ),
                    value: ExerciseMetric.repetitions,
                    enabled: true,
                  ),
                  ButtonSegment<ExerciseMetric>(
                    label: Text(
                      'Time',
                      style: style,
                    ),
                    value: ExerciseMetric.time,
                    enabled: true,
                  ),
                ],
                selected: <ExerciseMetric>{exerciseData.exerciseMetric},
                onSelectionChanged: (Set<ExerciseMetric> newSelection) {
                  // logger.i('onSelectionChanged: $newSelection');
                  exerciseData.exerciseMetric = newSelection.first;
                  exerciseDataNotifier.refresh(exerciseData);
                },
              ),
              AppSpace(),
              if (exerciseData.exerciseMetric == ExerciseMetric.repetitions)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Reps:  ', style: style),
                    SizedBox(
                      width: (style.fontSize ?? App.defaultFontSize) * 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${exerciseData.currentRepetitions}',
                          style: style.copyWith(),
                        ),
                      ),
                    ),
                    Text(
                      ' / ',
                      style: style,
                    ),
                    AppTextField(
                      controller: _repetitionTextEditingController,
                      keyboardType: TextInputType.number,
                      hintText: 'reps',
                      width: (style.fontSize ?? App.defaultFontSize) * 2,
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
                    SizedBox(
                      width: (style.fontSize ?? App.defaultFontSize) * 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '(${exerciseData.currentRepetitions - (exerciseData.targetRepetitions ?? 0)})',
                          style: style,
                        ),
                      ),
                    ),
                    AppSpace(),
                    appIconButton(
                      icon: const Icon(Icons.clear),
                      iconSize: 1.25 * (style.fontSize ?? App.defaultFontSize),
                      onPressed: (() {
                        exerciseData.currentRepetitions = 0;
                        exerciseDataNotifier.refresh(exerciseData);
                      }),
                    ),
                    AppSpace(),
                    appIconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 1.25 * (style.fontSize ?? App.defaultFontSize),
                      onPressed: (() {
                        exerciseData.currentRepetitions++;
                        exerciseDataNotifier.refresh(exerciseData);
                      }),
                    )
                  ],
                ),
              AppSpace(),
              if (exerciseData.exerciseMetric == ExerciseMetric.time)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Duration:  ', style: style),
                    AppSpace(),
                    SizedBox(
                      width: (style.fontSize ?? App.defaultFontSize) * 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${exerciseData.currentDuration}',
                          style: style.copyWith(),
                        ),
                      ),
                    ),
                    Text(' / ', style: style),
                    AppSpace(),
                    AppTextField(
                      controller: _durationTextEditingController,
                      keyboardType: TextInputType.number,
                      hintText: 'seconds',
                      width: (style.fontSize ?? App.defaultFontSize) * 2,
                      maxLines: 1,
                      style: style,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            int? seconds = int.tryParse(value);
                            if (seconds != null) {
                              exerciseData.targetDuration = seconds;
                              exerciseDataNotifier.refresh(exerciseData);
                            }
                          });
                        }
                      },
                    ),
                    Text('s', style: style),
                    AppSpace(
                      horizontalSpace: 40,
                    ),
                    appButton(
                      'Start',
                      onPressed: () {
                        exerciseData.currentDuration = 0;
                        exerciseData.isRunning = true;
                        exerciseDataNotifier.refresh(exerciseData);
                      },
                    ),
                    AppSpace(
                      horizontalSpace: 40,
                    ),
                    appButton(
                      'Stop',
                      onPressed: () {
                        exerciseData.isRunning = false;
                        exerciseDataNotifier.refresh(exerciseData);
                      },
                    ),
                  ],
                ),
            ],
          );
        }),
      ],
    );
  }

  bool _firstDisplay = true;
  final TextEditingController _exerciseNameTextEditingController = TextEditingController();
  final TextEditingController _repetitionTextEditingController = TextEditingController();
  final TextEditingController _durationTextEditingController = TextEditingController();
}
