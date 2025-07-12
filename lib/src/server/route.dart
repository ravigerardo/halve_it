import '../handle/handle.dart';
import 'http_methods.dart';

class Route {
  final HttpMethod method;
  final String path;
  final Handle handle;

  // Extract parameter names from path pattern (e.g., /user/:id)
  List<String> get pathParams {
    final regExp = RegExp(r':(\w+)');
    return regExp.allMatches(path).map((m) => m.group(1)!).toList();
  }

  Route({
    this.method = HttpMethod.GET,
    required this.path,
    required this.handle,
  });
}
