import 'dart:io';

import 'package:logger/logger.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'web_socket.dart';

//  diagnostic logging enables
const Level _logVerbose = Level.info;

//  channel found to client
WebSocketChannel? clientWebSocketChannel;

final hostname = Platform.localHostname; // returns hostname as string

void main() async {
  Logger.level = Level.info;

  setupWebSocket();
}

setupWebSocket() {
  var handler = webSocketHandler((givenWebSocketChannel) {
    clientWebSocketChannel = givenWebSocketChannel;
    clientWebSocketChannel?.stream.listen((message) async {
      print('message in: "${message.toString().replaceFirst('\n', '')}"');
      clientWebSocketChannel!.sink.add('returned message: $message');
    });
  });

  shelf_io
      .serve(
          handler,
          //'10.42.0.1',
          '$hostname.local',
          //'localhost',
          dynamicPort)
      .then((server) {
    // print('shelf_io: handler: ${handler.runtimeType}: $server');
    print('Serving at ws://${server.address.host}:${server.port}, ${DateTime.now()}');
  });
}
