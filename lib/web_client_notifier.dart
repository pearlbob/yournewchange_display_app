import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:yournewchange_display_app/exercise_data.dart';

import 'app_logger.dart';
import 'web_socket_config.dart';

const Level _logMessaging = Level.info;
const Level _logErrors = Level.info;

class WebSocketClientNotifier extends ChangeNotifier {
  WebSocketClientNotifier() {
    _connect();
  }

  //  try to reconnect on demand if required
  void _connect() async {
    Uri uri = Uri.parse(_uriString);
    logger.i('uri: $uri port: ${uri.port}');
    try {
      WebSocketChannel channel = WebSocketChannel.connect(
        Uri.parse(_uriString),
      );
      _webSocketChannel = channel;
      await channel.ready;
      channel.stream.listen(onMessage, onDone: onDone, onError: onError);
      _connected = true; //  make a presumption
    }
    on Exception catch (e) {
      _webSocketChannel = null; //fixme: required?
      _webSocketReconnectAttempts++;
      logger.i('onCatch #$_webSocketReconnectAttempts: $e');
      _connected = false;
      await Future.delayed(const Duration(seconds: 3));
      _connect();
    }
  }

  void onMessage(message) {
    if (message is String) {
      {
      exerciseData = ExerciseData.fromJson(_decoder.convert(message));
      //  logger.log(_logErrors, 'WebSocketClient.onMessage: unknown String: "$message"');
       logger.log(_logMessaging, 'WebSocketClient.onMessage: exerciseData: $exerciseData');
       notifyListeners();
      }
    } else {
      logger.log(_logErrors, 'WebSocketClient.onMessage: unknown type: "$message"');
    }

    _connected = true;
    _webSocketReconnectAttempts = 0;
    notifyListeners();
  }

  void onDone() async {
    _webSocketReconnectAttempts++;
    var delay = min(_webSocketReconnectAttempts++, _maxDelay);
    logger.i('onDone: reconnecting in $delay seconds, attempt $_webSocketReconnectAttempts');
    _connected = false;
    _webSocketChannel = null;
    await Future.delayed(Duration(seconds: delay));
    _connect();
  }

  void onError(error) async {
    _webSocketReconnectAttempts++;
    logger.i('onError: $error');
    var delay = min(_webSocketReconnectAttempts, _maxDelay);
    logger.i('onDone: reconnecting in $delay seconds, attempt $_webSocketReconnectAttempts');
    _connected = false;
    _webSocketChannel = null;
    // await Future.delayed(Duration(seconds: delay));
    // _connect();
  }

  Future<bool> sendMessage(Object message) async {
    logger.log(
        _logMessaging,
        'sendMessage(): _isConnected: $_isConnected'
        ', message: ${message.toString()}');

    if (_isConnected) {
      _webSocketChannel?.sink.add(message.toString());
      return true;
    } else {
      _connect();
      return false;
    }
  }

  get isConnected => _isConnected;

  set _connected(bool value) {
    if (_isConnected != value) {
      _isConnected = value;
      logger.i('connected: $_isConnected');
      notifyListeners();
    }
  }

  //  websocket channel
  bool _isConnected = false;
  int _webSocketReconnectAttempts = 0;
  static const _maxDelay = 4;

  ExerciseData exerciseData = ExerciseData();

  static const _uriString = 'ws://$webSocketServerHost:$webSocketDynamicPort/ws';
  WebSocketChannel? _webSocketChannel;
  static const JsonDecoder _decoder = JsonDecoder();
}
