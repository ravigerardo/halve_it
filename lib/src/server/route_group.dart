import 'route.dart';
import '../server/middleware.dart';

class RouteGroup {
  String id;
  String? namespace;
  List<Route> routes;
  List<Middleware> middlewares;

  RouteGroup({
    required this.id,
    this.namespace,
    required this.routes,
    this.middlewares = const [],
  });

  get props => [routes, middlewares];

  void addRoute(Route route) {
    this.routes.add(route);
  }

  void addRoutes(List<Route> routes) {
    this.routes.addAll(routes);
  }
}
