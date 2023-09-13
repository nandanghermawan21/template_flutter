import 'package:enerren/model/todo_model.dart';
import 'package:flutter/foundation.dart';

class ViewModel extends ChangeNotifier{
  TodoModel todoModel = TodoModel();

  void commit(){
    notifyListeners();
  }
}