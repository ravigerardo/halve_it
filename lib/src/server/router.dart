import 'dart:io';

import '../handle/response.dart';
import 'route.dart';

class Router {
  List<Route> routes;

  Router({
    required this.routes,
  });

  get props => [routes];

  void addRoute(Route route) {
    this.routes.add(route);
  }

  void addRoutes(List<Route> routes) {
    this.routes.addAll(routes);
  }

  Future<void> resolveRequest(HttpRequest request) async {
    final response = request.response;
    String responseDetails;
    try {
      final route = routes.firstWhere((route) {
        final bool isSamePath = route.path == request.uri.path;
        final bool isSameHttpMethod = route.method.name == request.method;

        return isSamePath && isSameHttpMethod;
      });
      final Response handleResponse = await route.handle();
      response
        ..statusCode = handleResponse.status
        ..headers.contentType = handleResponse.type ?? ContentType.json
        ..write(handleResponse.body);
      responseDetails = '${route.handle.toString()}';
    } catch (error) {
      response.statusCode = HttpStatus.notFound;
      responseDetails = 'Route not found';
    }
    print('Request for ${request.method} ${request.uri.path} - $responseDetails');
    response.close();
  }
}