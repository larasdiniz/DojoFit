import 'entrypoints/main_mock.dart';
import 'entrypoints/main_prod.dart';
import 'package:flutter/services.dart';

void main() {
  if (appFlavor == "mock") {
    mainMock();
  } else {
    mainProd();
  }
}
