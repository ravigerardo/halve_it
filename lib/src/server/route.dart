import 'dart:io';

import 'http_methods.dart';

class Route {
  final HttpMethod httpMethod;
  final String path;
  final Function(HttpRequest request, HttpResponse response) method; 

  Route({
    this.httpMethod = HttpMethod.GET,
    required this.path,
    required this.method,
  });
}
