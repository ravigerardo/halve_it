import 'dart:io';

import 'response.dart';

abstract class Handle {
  Future<Response> call(HttpRequest request, Map<String, String> params);
}
