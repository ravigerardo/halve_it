import 'dart:io';

import 'response.dart';

abstract class Handle {
  final List<Cookie> cookies = [];
  Future<Response> call(HttpRequest request, Map<String, String> params);
}
