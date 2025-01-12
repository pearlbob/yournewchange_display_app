import 'package:logger/logger.dart';
import 'package:server_nano/server_nano.dart';

import 'web_socket_config.dart';

void main() async {
  Logger.level = Level.info;

  final server = Server();

  // websockets out-the-box
  server.ws('/ws', (socket) {
    socket.onMessage((message) {
      print('server.ws: got: "$message"');
      socket.broadcast(message);  //  echo to all others
      socket.send('ws server returned: "$message"');
    });
  });

  await server.listen(
    // host: Platform.localHostname,
     port: dynamicPort + 1,
    wsPort: dynamicPort,
    useWebsocketInMainThread: true,
  );
}
