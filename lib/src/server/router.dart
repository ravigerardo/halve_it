import 'dart:io';

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
    try {
      final route = routes.firstWhere((route) {
        final bool isSamePath = route.path == request.uri.path;
        final bool isSameHttpMethod = route.httpMethod.name == request.method;

        return isSamePath && isSameHttpMethod;
      });
      await route.method(request, response);
    } catch (error) {
      print('Route not found: ${request.uri.path}');
      response.statusCode = HttpStatus.notFound;
    }
    response.close();
  }
}