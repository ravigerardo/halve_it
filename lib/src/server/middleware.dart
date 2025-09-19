import 'dart:io';

import '../handle/response.dart';

class Context {
  final HttpRequest request;
  final Map<String, String> params;
  final List<Cookie> cookies;
  Response? response;

  Context({
    required this.request,
    required this.params,
    required this.cookies,
    this.response,
  });
}

typedef Stop = void Function();

abstract class Middleware {
  Future<Context> call(Context context, Stop stop);
}

Future<Context> runMiddlewares({
  required Context context,
  required List<Middleware> middlewares,
}) async {
  bool shouldStop = false;
  void stop() => shouldStop = true;

  for (var middleware in middlewares) {
    // _printRequestPath(request, '🔮 ${_getInstanceName(middleware)}');
    context = await middleware(context, stop);
    if (shouldStop) break;
  }

  return context;
}
