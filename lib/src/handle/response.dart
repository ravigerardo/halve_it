import 'dart:io';

class Response {
  final ContentType? type;
  final int status;
  dynamic body;

  Response({
    this.type,
    this.status = HttpStatus.ok,
    this.body
  });
}