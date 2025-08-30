import 'dart:io';

class Response {
  final ContentType? type;
  final int status;
  dynamic body;
  final Redirection? redirection;

  Response({
    this.type,
    this.status = HttpStatus.ok,
    this.body,
    this.redirection,
  });
}

class Redirection {
  final Uri location;
  final int status;

  Redirection({
    required this.location,
    this.status = HttpStatus.movedTemporarily,
  });
}

