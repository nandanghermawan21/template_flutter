import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sqflite/sqlite_api.dart';

class TodoModel extends ChangeNotifier {
  int? id;
  String? title;
  String? description;
  DateTime? dueDate;
  bool? isCompleted;
  //for ui only
  bool? onProgess = false;

  TodoModel({
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.isCompleted,
  });

  void commit(){
    notifyListeners();
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        dueDate:
            json["due_date"] != null ? DateTime.parse(json["due_date"]) : null,
        isCompleted: json["is_completed"] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "dueDate": dueDate?.toIso8601String(),
        "isCompleted": isCompleted,
      };

  static Future<List<TodoModel>?> getFromDb({
    required Database? db,
  }) {
    return rootBundle.loadString("dbquery/selectAllTodo.sql").then((sql) async {
      return db?.rawQuery(sql).then((value) {
        debugPrint(json.encode(value));
        return value.map((e) => TodoModel.fromJson(e)).toList();
      }).catchError((onError) {
        throw onError;
      });
    }).catchError((onError) {
      throw onError;
    });
  }

  Future<int?> saveToDb({
    required Database? db,
  }) {
    return rootBundle.loadString("dbquery/insertTodo.sql").then((sql) async {
      sql = sprintf(sql, [
        title,
        description,
        dueDate?.toIso8601String(),
        isCompleted == true ? 1 : 0,
      ]);
      return db?.rawInsert(sql).then((value) {
        return value;
      }).catchError((onError) {
        throw onError;
      });
    }).catchError((onError) {
      throw onError;
    });
  }

  static Future<int?> supdateStatusOnDb({
    required Database? db,
    required int? id,
    required bool? isCompleted,
  }) {
    return rootBundle
        .loadString("dbquery/updateStatusTodo.sql")
        .then((sql) async {
      sql = sprintf(sql, [
        id,
        isCompleted == true ? 1 : 0,
      ]);
      return db?.rawInsert(sql).then((value) {
        return value;
      }).catchError((onError) {
        throw onError;
      });
    }).catchError((onError) {
      throw onError;
    });
  }
}
