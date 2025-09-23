import 'dart:io';

import 'package:intl/intl.dart';

void printRequestPath(HttpRequest request, String details) {
  print('[${DateFormat('Hms').format(DateTime.now())}] ' +
      'Request for ' +
      '${request.method} ${request.uri.path} - $details');
}

String getInstanceName(instance) {
  final match = RegExp(r"'([^']*)'").firstMatch(instance.toString());
  final name = '${match![0]}';
  return name.substring(1, name.length - 1);
}
