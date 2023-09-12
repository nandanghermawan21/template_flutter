import 'package:flutter/material.dart';

class ModeUtil {
  static String mode = "release";

  static bool get debugMode {
    var debug = false;
    assert(debug = true);
    return debug;
  }

  static debugPrint(Object message) {
    var x = debugMode;
    if (x == true) {
      // ignore: avoid_print
      print(message);
    }
  }

  static executeOnDebug(VoidCallback fn) {
    var x = debugMode;
    if (x == true) {
      fn();
    }
  }

  static isDebugMode() {
    assert(() {
      mode = "debug";
      return true;
    }());
  }
}
