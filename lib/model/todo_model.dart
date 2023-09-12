import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sqflite/sqlite_api.dart';

class TodoModel {
  int? id;
  String? title;
  String? description;
  DateTime? dueDate;
  bool? isCompleted;

  TodoModel({
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.isCompleted,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        dueDate: DateTime.parse(json["dueDate"]),
        isCompleted: json["isCompleted"],
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
    required String? receiver,
    required String? sender,
  }) {
    return rootBundle.loadString("dbquery/selectAllTodo.sql").then((sql) async {
      return db?.rawQuery(sql).then((value) {
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
    return rootBundle.loadString("dbquery/updateStatusTodo.sql").then((sql) async {
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
