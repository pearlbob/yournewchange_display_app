import 'dart:io';
import 'package:server_nano/server_nano.dart';
import 'web_socket_config.dart';

const _wsIdentifier = '/ws';

void main() async {
  final server = Server();

  // websocket handler
  server.ws(_wsIdentifier, (socket) {
    socket.onMessage((message) {
      socket.broadcast(message); //  echo to all other client sockets
    });
  });

  await server.listen(
    host:Platform.localHostname,
    port: webSocketDynamicPort + 1,
    wsPort: webSocketDynamicPort,
    useWebsocketInMainThread: true,
  );

  print('server on ws://${Platform.localHostname}.local:$webSocketDynamicPort$_wsIdentifier');
}
