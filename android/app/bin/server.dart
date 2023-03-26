import 'dart:io';
import 'package:appengine/appengine.dart';

requestHandler(HttpRequest request) {
  request.response
      ..write('Hello, world!')
      ..close();
}

main() async {
  
  await runAppEngine(requestHandler);
}