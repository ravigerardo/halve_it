import 'dart:io';

import '../handle/response.dart';
import 'route.dart';
import 'route_group.dart';

class Router {
  List<RouteGroup> routeGroups;

  Router({
    required this.routeGroups,
  });

  get props => [routeGroups];

  void addRouteGroup(RouteGroup routeGroup) {
    this.routeGroups.add(routeGroup);
  }

  Future<void> resolveRequest(HttpRequest request) async {
    final response = request.response;
    String responseDetails;
    try {
      final uriPath = request.uri.path;
      late Route route;
      for (var routeGroup in routeGroups) {
        route = routeGroup.routes.firstWhere((route) {
          if (route.method.name != request.method) return false;
          final routeSegments =
              route.path.split('/').where((s) => s.isNotEmpty).toList();
          final uriSegments =
              uriPath.split('/').where((s) => s.isNotEmpty).toList();
          if (routeSegments.length != uriSegments.length) return false;
          for (int i = 0; i < routeSegments.length; i++) {
            if (routeSegments[i].startsWith(':')) continue;
            if (routeSegments[i] != uriSegments[i]) return false;
          }
          return true;
        });
      }

      final routeSegments =
          route.path.split('/').where((s) => s.isNotEmpty).toList();
      final uriSegments =
          uriPath.split('/').where((s) => s.isNotEmpty).toList();
      final params = <String, String>{};
      for (int i = 0; i < routeSegments.length; i++) {
        if (routeSegments[i].startsWith(':')) {
          params[routeSegments[i].substring(1)] = uriSegments[i];
        }
      }

      final Response handleResponse = await route.handle(request, params);
      response
        ..statusCode = handleResponse.status
        ..headers.contentType = handleResponse.type ?? ContentType.json
        ..write(handleResponse.body);
      responseDetails = '🌸 ${route.handle.toString()}';
    } catch (error) {
      response.statusCode = HttpStatus.notFound;
      responseDetails = '😵‍💫 Route not found';
    }
    print(
        'Request for ${request.method} ${request.uri.path} - $responseDetails');
    response.close();
  }
}

