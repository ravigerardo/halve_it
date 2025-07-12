import 'response.dart';

abstract class Handle {
  Future<Response> call();
}
