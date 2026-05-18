import 'package:dojofit/entrypoints/main_mock.dart';
import 'package:dojofit/entrypoints/main_prod.dart';
import 'package:flutter/services.dart';

void main() {
  if (appFlavor == "mock") {
    mainMock();
  } else {
    mainProd();
  }
}
