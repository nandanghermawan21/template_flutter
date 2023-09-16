import 'package:flutter/material.dart';
import 'package:my_image_picker/my_image_picker.dart';
import 'package:my_image_picker/my_multiple_image_picker.dart';
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
  ImagePickerController imagePickerController = ImagePickerController();
  MultipleImagePickerController multipleImagePickerController =
      MultipleImagePickerController();

  @override
  void initState() {
    super.initState();
  }
}
