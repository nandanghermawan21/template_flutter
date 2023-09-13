import 'package:flutter/material.dart';
import 'main.dart' as main;

class Presenter extends StatefulWidget {
  final VoidCallback? postQueue;
  final VoidCallback? todoList;
  const Presenter({
    Key? key,
    this.postQueue,
    this.todoList,
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
  }
}
