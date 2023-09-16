import 'package:enerren/util/system.dart';
import 'package:flutter/material.dart';
import 'package:my_image_picker/my_image_picker.dart';
import 'package:my_image_picker/my_multiple_image_picker.dart';

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
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
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
              const SizedBox(
                height: 10,
              ),
              Text(
                "image Picker",
                style: System.data.textStyles!.boldTitleLabel,
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: ImagePickerComponent(
                  controller: imagePickerController,
                  containerHeight: 100,
                  containerWidth: 100,
                  uploadUrl: "",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Multiple Image Picker",
                style: System.data.textStyles!.boldTitleLabel,
              ),
              IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: MultipleImagePickerComponent(
                    controller: multipleImagePickerController,
                    size: 100,
                    uploadUrl: "",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
