import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoDb {
  //step 1 create private constructor of the Database class
  TodoDb._privateConstructor();

  //Step 2 create object of the class
  static final TodoDb instance = TodoDb._privateConstructor();

  var _databaseName = "ToDo.db";
  var todoTableName = "todo";
  var id = "id";
  var task = "task";
  var date = "date";
  var isCompleted = "isCompleted";

  //Step 3 Create static object of Database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initiateDatabase();
    return _database;
  }

  Future<Database> initiateDatabase() async {
    print("in database initialise method");
    final path = await getDatabasesPath();
    var database;
    try {
      database = openDatabase(join(path, _databaseName),
          version: 1, onConfigure: _onConfigure, onCreate: (((db, version) {
        db.execute(
            "CREATE TABLE IF NOT EXISTS $todoTableName($id INTEGER PRIMARY KEY AUTOINCREMENT, $task TEXT, $date STRING, $isCompleted INTEGER)");
        //same db.execute with different table name and column names
        print("in open database");
        return db;
      })));
    } catch (exception) {
      print("in exception");
    }
    return database;
  }

  static Future _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON ");
  }
}
