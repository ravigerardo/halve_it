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
    print('Runing admin server...');
    final requests = await HttpServer.bind(host, port);
    print('Server listening at http://${requests.address.host}:${requests.port}');
    await for (final request in requests) {
      await processRequest(request);
    }
  }

  Future<void> processRequest(HttpRequest request) async {
    print('Request for ${request.method} ${request.uri.path}');
    await router.resolveRequest(request);
  }
}