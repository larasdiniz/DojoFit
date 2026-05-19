import 'package:flutter/material.dart';
import 'entrypoints/main_mock.dart';
import 'entrypoints/main_prod.dart';
import 'package:flutter/services.dart';

void main() {
  final flavor = appFlavor?.toLowerCase();

  // ver no console se ele ler com letra maiúscula
  debugPrint('[DOJOFIT_BOOT] O flavor lido pelo Flutter é: $flavor');

  if (flavor == "mock") {
    mainMock();
  } else {
    mainProd();
  }
}
