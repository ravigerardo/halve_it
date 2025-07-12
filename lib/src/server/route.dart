import '../handle/handle.dart';
import 'http_methods.dart';

class Route {
  final HttpMethod method;
  final String path;
  final Handle handle; 

  Route({
    this.method = HttpMethod.GET,
    required this.path,
    required this.handle,
  });
}
