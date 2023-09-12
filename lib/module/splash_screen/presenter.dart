import 'dart:async';

import 'package:flutter/material.dart';
import 'main.dart' as main;

class Presenter extends StatefulWidget {
  final VoidCallback? onFinish;
  const Presenter({
    Key? key,
    this.onFinish,
  }) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return main.View();
  }


}

abstract class PresenterState extends State<Presenter> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      timer.cancel();
      widget.onFinish?.call();
    });
  }
}
