import 'package:circular_loader/circular_loader.dart';
import 'package:enerren/model/todo_model.dart';
import 'package:enerren/module/todo_list/view_model.dart';
import 'package:enerren/util/system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:list_data/list_data.dart';
import 'package:provider/provider.dart';

import 'presenter.dart';

class View extends PresenterState {
  @override
  Widget build(BuildContext context) {
    return CircularLoaderComponent(
      controller: loadingController,
      cover: false,
      successMessageAlign: Alignment.topCenter,
      successMessageBuilder: CircularLoaderComponent.messageSuccessNotifMode,
      loadingDecoration: const BoxDecoration(color: Colors.transparent),
      //add error notif mode
      errorMessageAlign: Alignment.topCenter,
      errorMessageBuilder: CircularLoaderComponent.messageErrorNotifMode,
      child: ChangeNotifierProvider.value(
        value: model,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Todo List"),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                ListDataComponent<TodoModel>(
                  controller: listDataController,
                  enableDrag: false,
                  listViewMode: ListDataComponentMode.listView,
                  enableGetMore: true,
                  showSearchBox: true,
                  dataSource: (skip, key) {
                    debugPrint("fire me $key skip $skip");
                    return TodoModel.getFromDb(
                      db: System.data.database!.db!,
                    ).then((value) {
                      return value ?? [];
                    });
                  },
                  itemBuilder: (data, index) {
                    return ChangeNotifierProvider.value(
                      value: data ?? TodoModel(),
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 5, top: 5),
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Consumer<TodoModel>(builder: (c, d, w) {
                              return SizedBox(
                                width: 20,
                                child: Checkbox(
                                  value: data?.isCompleted ?? false,
                                  onChanged: (value) {
                                    check(d, value ?? false);
                                  },
                                ),
                              );
                            }),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data?.title ?? "",
                                    style:
                                        System.data.textStyles!.boldTitleLabel,
                                  ),
                                  Text(data?.description ?? ""),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: (data?.onProgess ?? false) == false
                                  ? const SizedBox()
                                  : CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: FloatingActionButton(
                      onPressed: () {
                        showModalAddTodo();
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showModalAddTodo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: ChangeNotifierProvider.value(
            value: model,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IntrinsicHeight(
                child: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              hintText: "Title",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              model.todoModel.title = value;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          IntrinsicHeight(
                            child: TextField(
                              controller: descriptionController,
                              minLines: null,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                hintText: "description",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                model.todoModel.description = value;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              debugPrint("fire me");
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)))
                                  .then((value) {
                                model.todoModel.dueDate =
                                    value ?? DateTime.now();
                                model.commit();
                              });
                            },
                            child: Container(
                                height: 50,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Consumer<ViewModel>(
                                  builder: (c, d, w) {
                                    return Text(
                                      DateFormat("dd MMMM yyyy").format(
                                          model.todoModel.dueDate ??
                                              DateTime.now()),
                                    );
                                  },
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                save();
                              },
                              child: const Text("Save"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
