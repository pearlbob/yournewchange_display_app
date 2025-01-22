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

  //  the websocket host will always be the host name of the server
  final host = '${Platform.localHostname}.local';

  await server.listen(
    host: host,
    port: webSocketDynamicPort + 1,
    wsPort: webSocketDynamicPort,
    useWebsocketInMainThread: true,
  );

  print('server on ws://$host:$webSocketDynamicPort$_wsIdentifier');
}
