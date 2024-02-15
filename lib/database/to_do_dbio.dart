import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/database/to_do_db.dart';
import 'package:to_do_app/to_do_model.dart';

import 'to_do_db.dart';

class TodoDbIO {
  TodoDb? databaseProvider;

  TodoDbIO() {
    databaseProvider = TodoDb.instance;
  }

  void insertIntoTaskTable(ToDoModel toDoModel) async {
    Database? db = await databaseProvider!.database;
    await db!.insert(TodoDb.instance.todoTableName, toDoModel.toJson());
  }

  Future<List<ToDoModel>> getFromTaskTable() async {
    var list = <ToDoModel>[];
    Database? db = await databaseProvider!.database;
    List<Map<String, dynamic>> data =
        await db!.query(TodoDb.instance.todoTableName);
    print("data $data");
    return List.generate(data.length, (i) {
      return ToDoModel(
        id: data[i]["id"],
        task: data[i]['task'],
        isCompleted: data[i]['isCompleted'],
        date: data[i]["date"],
      );
    });
  }

  void updateTodo(ToDoModel toDoModel, int id) async {
    Database? db = await databaseProvider!.database;
    await db!.update(TodoDb.instance.todoTableName, toDoModel.toJson(),
        where: " id = ?", whereArgs: [toDoModel.id]);
  }

  void removeTodo(int id) async {
    Database? db = await databaseProvider!.database;
    await db!.delete(TodoDb.instance.todoTableName,
        where: " id = ?", whereArgs: [id]);
  }
}
