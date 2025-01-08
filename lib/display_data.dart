import 'package:intl/intl.dart';

class DisplayData {
  DisplayData(  this.client);

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
    return 'DisplayData{client: "$client", exercise: ${exercise??'unknown'}, reps: $currentRepetitions'
        '${targetRepetitions==null? '': '/$targetRepetitions'}'
        ', start: ${_displayTime(start)}'
        '${targetDuration == null ? '' : ', duration: ${targetDuration!.inSeconds}}'}'
        '}';
  }

  final String client;
  String? exercise;
  int currentRepetitions = 0;
  int? targetRepetitions;
  DateTime start = DateTime.now();
  Duration? targetDuration;
}
