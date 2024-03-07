// ignore_for_file: unused_field

import 'package:hive/hive.dart';

class ToDoDB{

  List toDoList = [];
  final _myBox = Hive.box('todoapp');

  //run this method if its the first time ever opening this app
  void createDB(){
    toDoList = [
      ["Learn", false],
      ["Exercise", false],
    ];
  }

  void loadData() {
    toDoList = _myBox.get("todolist");
  }

  void updateDB() {
    _myBox.put("todolist", toDoList);
  }
}