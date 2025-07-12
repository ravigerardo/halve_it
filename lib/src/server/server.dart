import 'dart:io';

import 'router.dart';

class Server {
  final String host;
  final int port;
  final Router router;

  Server({
    required this.host,
    required this.port,
    required this.router,
  });

  void run() async {
    print('🎯 Stating server...');
    final requests = await HttpServer.bind(host, port);
    print('Server listening at http://${requests.address.host}:${requests.port}\n');
    await for (final request in requests) {
     await router.resolveRequest(request);
    }
  }
}