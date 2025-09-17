import 'dart:io';

import '../handle/response.dart';

abstract class Middleware {
  final List<Cookie> cookies = [];
  Future<Response?> call(HttpRequest request, Map<String, String> params);
}
