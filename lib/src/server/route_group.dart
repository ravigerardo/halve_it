import 'route.dart';

class RouteGroup {
  String id;
  String? namespace;
  List<Route> routes;

  RouteGroup({
    required this.id,
    this.namespace,
    required this.routes,
  });

  get props => [routes];

  void addRoute(Route route) {
    this.routes.add(route);
  }

  void addRoutes(List<Route> routes) {
    this.routes.addAll(routes);
  }
}
