import 'dart:async';

import 'package:args/args.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:yournewchange_display_app/exercise_active_widget.dart';
import 'package:yournewchange_display_app/exercise_passive_widget.dart';
import 'package:yournewchange_display_app/web_client_notifier.dart';

import 'app/app.dart';
import 'app_logger.dart';
import 'exercise_data.dart';

String client = 'bob';
ClockRefreshNotifier _clockRefreshNotifier = ClockRefreshNotifier();
ExerciseDataNotifier _exerciseDataNotifier = ExerciseDataNotifier();
final WebSocketClientNotifier webSocketClientNotifier = WebSocketClientNotifier();

Level _logMessaging = Level.info;
Level _logConnection = Level.info;
bool _coach = false;
bool _display = false;

var _count = 1; //  temp!!!!!!!!!!!!!!!!!!!!!

void main(final List<String> args) {
  var parser = ArgParser();
  parser.addFlag('coach', abbr: 'c');
  parser.addFlag('display', abbr: 'd');

  var results = parser.parse(args);
  _coach = results.flag('coach');
  _display = results.flag('display');

  //  insist on a display if not coach
  _display |= !_coach;

  Logger.level = kDebugMode ? Level.info : Level.warning;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your New Change',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Your New Change'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    webSocketClientNotifier.addListener(_webSocketClientListener);

    myTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      DateTime now = DateTime.now();
      if (now.minute != lastClockMinutes) {
        _clockRefreshNotifier.refresh(now);
        lastClockMinutes = now.minute; //  only update on change of minutes
      }

      //  run the timer
      var exerciseData = _exerciseDataNotifier.exerciseData;
      if (exerciseData.isRunning) {
        if (exerciseData.currentDuration < (exerciseData.targetDuration ?? 0)) {
          exerciseData.currentDuration++;
        } else {
          exerciseData.isRunning = false;
        }
        _exerciseDataNotifier.refresh(exerciseData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    TextStyle style = themeData.textTheme.headlineLarge ?? TextStyle();

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MultiProvider(
      providers: [
        //  has to be a widget level above it's use
        ChangeNotifierProvider<ClockRefreshNotifier>(create: (_) => _clockRefreshNotifier),
        ChangeNotifierProvider<ExerciseDataNotifier>(create: (_) => _exerciseDataNotifier),
      ],
      child: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('${widget.title}${_coach ? ' Coach' : ''}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(90.0),
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appButton('test', onPressed: () {
                  webSocketClientNotifier.sendMessage('hello dude: ${_count++} times');
                }),
                if (_coach && _display) Text('coach display:  ', style: style),
                if (_coach) ExerciseActiveWidget(),
                if (_coach && _display)
                AppSpace(
                  verticalSpace: 50,
                ),
                if (_coach && _display) Text('client display:  ', style: style),
                if (_display) ExercisePassiveWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _webSocketClientListener() {
    logger.log(_logMessaging, 'webSocketClient._webSocketClientListener():');
    if (_lastConnection != webSocketClientNotifier.isConnected) {
      setState(() {
        //  update state on a connection change
        _lastConnection = webSocketClientNotifier.isConnected;
        logger.log(_logConnection, 'connection: ${webSocketClientNotifier.isConnected}');
      });
    }
    logger.log(_logMessaging, 'message: ????');
  }

  @override
  void dispose() {
    myTimer?.cancel();
    super.dispose();
  }

  bool _lastConnection = false;
  int lastClockMinutes = -1; //  will always trigger on first use
  Timer? myTimer;
}

class ClockRefreshNotifier extends ChangeNotifier {
  void refresh(final DateTime refreshedNow) {
    now = refreshedNow;
    // logger.i( 'ClockRefreshNotifier: ${identityHashCode(this)}: $now');
    notifyListeners();
  }

  DateTime now = DateTime.now();
}

class ExerciseDataNotifier extends ChangeNotifier {
  void refresh(final ExerciseData newData) {
    if (newData != _exerciseData) {
      _exerciseData = newData.copy();
      // logger.i( 'ExerciseDataNotifier: ${identityHashCode(this)}: $data');
      notifyListeners();
    }
  }

  // fixme: this copy is a bit abusive but required to see the diff on the refresh
  get exerciseData => _exerciseData.copy();

  ExerciseData _exerciseData = ExerciseData();
}
