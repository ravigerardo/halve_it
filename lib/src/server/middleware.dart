import 'dart:io';

import '../handle/response.dart';

abstract class Middleware {
  Future<Response?> call(HttpRequest request, Map<String, String> params);
}
