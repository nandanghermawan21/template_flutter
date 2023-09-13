import 'package:flutter/material.dart';
import 'package:enerren/module/sample/main.dart' as splash_screen;
import 'package:enerren/module/post_queue/main.dart' as post_queue;
import 'package:enerren/module/todo_list/main.dart' as todo_list;

String initialRouteName = RouteName.sample;

class RouteName {
  static const String sample = "sample";
  static const String postQueue = "postQueue";
  static const String todoList = "todoList";
}

enum ParamName {
  user,
}

Map<String, WidgetBuilder> route = {
  RouteName.sample: (BuildContext context) {
    return splash_screen.Presenter(
      postQueue: () {
        Navigator.pushNamed(context, RouteName.postQueue);
      },
      todoList: () {
        Navigator.pushNamed(context, RouteName.todoList);
      },
    );
  },
  RouteName.postQueue: (BuildContext context) {
    return const post_queue.Presenter();
  },
  RouteName.todoList: (BuildContext context) {
    return const todo_list.Presenter();
  },
};
