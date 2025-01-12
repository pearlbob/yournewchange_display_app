import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:yournewchange_display_app/web_socket_config.dart';

final _hostname = Platform.localHostname; // returns hostname as string
final List<HttpSession> _sessions = []; // note: HttpSession is not a comparable!

void main() async {
  Logger.level = Level.info;

  runZoned(() async {
    var server = await HttpServer.bind('$_hostname.local', dynamicPort);
    print('server at: ${server.address}:${server.port}');
    server.listen((HttpRequest req) async {
      // print('req.headers: ${req.headers}');
      // print('req.headers[upgrade]: ${req.headers['upgrade']?.first}');
      if (req.headers['upgrade']?.first == 'websocket') {
        var session = req.session;
        if (!_sessions.contains(session)) {
          _sessions.add(session);
        }

        WebSocketTransformer.upgrade(req).then((websocket) {
          print('ws transform: ${websocket.runtimeType} ${websocket}');
          //   //  relay message to all the other sessions
          //   for (var s in _sessions) {
          //     if (!identical(s, session)) {
          //       print('send ws message to: $s');
          //
          //       // on error  disconnect( _sessions.remove(s));
          //     } else {
          //       print('   not sent');
          //     }
          //   }

        websocket.listen((message) {
          print('ws message: ${message.runtimeType}: $message');

          //  relay message to all the other sessions
          for (var s in _sessions) {
            if (!identical(s, session)) {
              print('send ws message to: $s');

              // on error  disconnect( _sessions.remove(s));
            } else {
              print('   not sent');
            }
          }

        }, onError: (e) => print('A WebSocketTransformer error occurred.'));
        });
      }
    });
  });
}
