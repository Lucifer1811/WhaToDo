import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/database.dart';
import 'package:flutter_todo_app/util/add_task.dart';
import 'package:flutter_todo_app/util/todo_tile.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // ignore: unused_field
  final _myBox = Hive.box('todoapp');
  ToDoDB db = ToDoDB();

  @override
  void initState() {
    if (_myBox.get("todolist") == null) {
      db.createDB();
    }else{
      db.loadData();
    }
    
    super.initState();
  }

  final _controller = TextEditingController();



  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDB();
  }

  void addTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
    });
    Navigator.of(context).pop();
    db.updateDB();
  }

  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            'TO DO list',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.teal
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showDialog(
            context: context, 
            builder: (context) {
              return DialogBox(
                controller: _controller,
                onSave: addTask,
                onCancel: () => Navigator.of(context).pop(),
              );
            },
          )
        },
        backgroundColor: Colors.teal[300],
        child: Icon(
          Icons.add,
          color: Colors.teal[50],
          ),
      ),

      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
        ),
    );
  }
}