import 'dart:io';

import 'package:intl/intl.dart';

import '../handle/response.dart';
import 'route_group.dart';
import 'route.dart';

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
    late Route route;
    late RouteGroup routeGroup;
    Response? finalResponse;

    try {
      try {
        (route, routeGroup) = _getRouteAndRoutGroup(request);
      } catch (error) {
        _printRequestPath(request, '😵‍💫 Route not found - $error');
        response.statusCode = HttpStatus.notFound;
        response.close();
        return;
      }

      final params = _getParams(request, route);

      for (var middleware in routeGroup.middlewares) {
        _printRequestPath(request, '🔮 ${_getInstanceName(middleware)}');
        final Response? middlewareResponse = await middleware(request, params);
        if (middlewareResponse != null) {
          finalResponse = middlewareResponse;
          break;
        }
      }

      if (finalResponse == null) {
        _printRequestPath(request, '🌸 ${_getInstanceName(route.handle)}');
        finalResponse = await route.handle(request, params);
      }

      print("There are ${route.handle.cookies.length} cookies");
      if (route.handle.cookies.isNotEmpty) {
        _printRequestPath(request, '🍪 There are cookies!');
        for (Cookie cookie in route.handle.cookies) {
          print('🍪 Cookie: ${cookie.name}: ${cookie.value}');
        }
        response.cookies.addAll(route.handle.cookies);
      }

      if (finalResponse.redirection != null) {
        final redirection = finalResponse.redirection;
        _printRequestPath(
          request,
          '🛸 Redirect to '
          '${redirection!.location.host}'
          '${redirection.location.path}',
        );
        response.redirect(
          redirection.location,
          status: redirection.status,
        );
        return;
      }

      response
        ..statusCode = finalResponse.status
        ..headers.contentType = finalResponse.type ?? ContentType.json
        ..write(finalResponse.body);

      response.close();
      return;
    } catch (error) {
      response.statusCode = HttpStatus.internalServerError;
      _printRequestPath(request, '😵‍💫 Internal Server Error - $error');
      response.close();
      return;
    }
  }

  (Route, RouteGroup) _getRouteAndRoutGroup(HttpRequest request) {
    final uriPath = request.uri.path;
    late Route route;
    late RouteGroup routeGroup;
    for (var group in routeGroups) {
      try {
        route = group.routes.firstWhere((route) {
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
          routeGroup = group;
          return true;
        });
      } catch (_) {}
    }

    return (route, routeGroup);
  }

  Map<String, String> _getParams(HttpRequest request, Route route) {
    final uriPath = request.uri.path;
    final routeSegments =
        route.path.split('/').where((s) => s.isNotEmpty).toList();
    final uriSegments = uriPath.split('/').where((s) => s.isNotEmpty).toList();
    final params = <String, String>{};
    for (int i = 0; i < routeSegments.length; i++) {
      if (routeSegments[i].startsWith(':')) {
        params[routeSegments[i].substring(1)] = uriSegments[i];
      }
    }

    return params;
  }

  void _printRequestPath(HttpRequest request, String details) {
    print('[${DateFormat('Hms').format(DateTime.now())}] ' +
        'Request for ' +
        '${request.method} ${request.uri.path} - $details');
  }

  String _getInstanceName(instance) {
    final match = RegExp(r"'([^']*)'").firstMatch(instance.toString());
    final name = '${match![0]}';
    return name.substring(1, name.length - 1);
  }
}
