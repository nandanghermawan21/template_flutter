import 'dart:convert';
import 'dart:math';

import 'package:enerren/util/error_handling_util.dart';
import 'package:flutter/material.dart';
import 'package:list_data/list_data.dart';
import 'package:local_post_management/local_post_management.dart';
import 'package:circular_loader/circular_loader.dart';
import 'main.dart' as main;

class Presenter extends StatefulWidget {
  const Presenter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return main.View();
  }
}

abstract class PresenterState extends State<Presenter> {
  LocalPostManagement localPostManagement = LocalPostManagement();
  ListDataComponentController<QueueModel> queueController =
      ListDataComponentController<QueueModel>();

  //loading controller
  CircularLoaderController loadingController = CircularLoaderController();

  //input controller
  TextEditingController nameController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  TextEditingController headerController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    urlController.text = "https://jsonplaceholder.typicode.com/posts";
    queryController.text = "";
    headerController.text = jsonEncode({
      "Content-type": "application/json; charset=UTF-8",
    });
    bodyController.text = jsonEncode({
      "title": "foo",
      "body": "bar",
      "userId": 1,
    });
    localPostManagement.initialize(
      true,
    ).then((value) {
      localPostManagement.loadQueue();
    });
  }

  //add to queue
  void addToQueue() {
    // loadingController.startLoading();
    nameController.text = "Test${Random().nextInt(max(100, 1000))}";
    localPostManagement
        .addAndLoadQueue(
            name: nameController.text,
            postModel: PostModel(
              url: Uri.parse(urlController.text),
              query: queryController.text == ""
                  ? {}
                  : jsonDecode(queryController.text)?.cast<String, String>(),
              headers: jsonDecode(headerController.text)?.cast<String, String>(),
              body: jsonDecode(bodyController.text)?.cast<String, dynamic>(),
            ))
        .catchError(
      (onError) {
        loadingController.stopLoading(
            message: ErrorHandlingUtil.handleApiError(onError));
        throw onError;
      },
    ).then(
      (value) {
        queueController.refresh();
        loadingController.forceStop();
      },
    );
  }
}
