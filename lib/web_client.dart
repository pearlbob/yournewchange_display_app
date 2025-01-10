import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'web_socket.dart';

import 'app_logger.dart';

const Level _logMessaging = Level.info;
const Level _logErrors = Level.info;

class WebSocketClient extends ChangeNotifier {
  WebSocketClient() {
    _connect();
  }

  //  try to reconnect on demand if required
  void _connect() async {
    try {
      WebSocketChannel channel = WebSocketChannel.connect(
        Uri.parse(uriString),
      );
      _webSocketChannel = channel;
      await channel.ready;
      channel.stream.listen(onMessage, onDone: onDone, onError: onError);
      _connected = true; //  make a presumption
    }
    // on SocketException catch (e) {
    // } on WebSocketChannelException catch (e) {
    // }
    on Exception catch (e) {
      _webSocketChannel = null; //fixme: required?
      _webSocketReconnectAttempts++;
      logger.i('onCatch #$_webSocketReconnectAttempts: $e');
      _connected = false;
      //await Future.delayed(const Duration(seconds: 1));
      //_connect();
    }
  }

  void onMessage(message) {
    if (message is String) {
      {
        logger.log(_logErrors, 'WebSocketClient.onMessage: unknown String: "$message"');
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

  static const String serverHostname = //
// '10.42.0.1'
      'bob.local' //
      ;

  static const uriString = 'ws://$serverHostname:$dynamicPort';
  WebSocketChannel? _webSocketChannel;
}
