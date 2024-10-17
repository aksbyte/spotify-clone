import 'dart:developer';

import 'package:flutter/foundation.dart';

void logCat(dynamic value) {
  log('Printed data is-------------> $value');
}

void logCatPro({required String valueName, required dynamic value}) {
  log('The $valueName -------------> $value');
}
