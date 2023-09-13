import 'package:enerren/util/system.dart';
import 'package:flutter/material.dart';

import 'presenter.dart';

class View extends PresenterState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sample"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                widget.postQueue?.call();
              },
              child: Text(
                "Post Queue",
                style: System.data.textStyles!.boldTitleLightLabel,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.todoList?.call();
              },
              child: Text(
                "Todo List",
                style: System.data.textStyles!.boldTitleLightLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
