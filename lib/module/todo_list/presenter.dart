import 'package:circular_loader/circular_loader.dart';
import 'package:enerren/model/todo_model.dart';
import 'package:enerren/module/todo_list/view_model.dart';
import 'package:enerren/util/system.dart';
import 'package:flutter/material.dart';
import 'package:list_data/list_data.dart';
import 'main.dart' as main;

class Presenter extends StatefulWidget {
  const Presenter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return main.View();
  }
}

abstract class PresenterState extends State<Presenter> {
  CircularLoaderController loadingController = CircularLoaderController();
  ListDataComponentController<TodoModel> listDataController =
      ListDataComponentController<TodoModel>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ViewModel model = ViewModel();

  void save() {
    loadingController.startLoading();
    model.todoModel
        .saveToDb(
      db: System.data.database!.db!,
    )
        .then((value) {
      loadingController.stopLoading(
        message: "Saved",
        isError: false,
        duration: const Duration(seconds: 2),
      );
    }).catchError((onError) {
      loadingController.stopLoading(
        message: onError.toString(),
        isError: true,
      );
    });
  }

  void check(TodoModel todoModel, bool isCompleted) {
    todoModel.onProgess = true;
    todoModel.commit();
    TodoModel.supdateStatusOnDb(
            db: System.data.database!.db!,
            id: todoModel.id,
            isCompleted: isCompleted)
        .then((value) {
      todoModel.onProgess = false;
      todoModel.isCompleted = isCompleted;
      todoModel.commit();
    }).catchError((onError) {
      todoModel.onProgess = false;
      todoModel.commit();
      loadingController.stopLoading(
        message: onError.toString(),
        isError: true,
      );
    });
  }
}
