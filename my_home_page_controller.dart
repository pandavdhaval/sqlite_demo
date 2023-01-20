import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqllite_demo/my_home_page.dart';
import 'package:path/path.dart';
import 'package:sqllite_demo/todo_model.dart';

import 'constant.dart';

class MyHomePageController extends GetxController{
  var todoList=<TodoModel>[].obs;
  @override
  void onInit() {
    createDatabase();
    super.onInit();
  }

  Future<void> createDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    await openDatabase(path, version: version,
        onCreate: (Database db, int version) async {
          printInfo(info: "db:" + db.toString());
          /// for the create table
          await db.execute("CREATE TABLE $tblName ("
              "$columnId TEXT PRIMARY KEY,"
              "$columnTitle TEXT NOT NULL,"
              "$columnDescription TEXT NOT NULL,"
              "$columnDate TEXT NOT NULL"
              ")");
        });
    getTodo();
  }

  void addData(
      {required String name,
        required String task,
        required String desc}) {
    var todo = TodoModel(
        id: (todoList.length + 1).toString(),
        name: name,
        task: task,
        desc: desc);
    insertData(todo);
  }

  Future<void> insertData(TodoModel todo) async {
    String path = join(await getDatabasesPath(), databaseName);
    final db = await openDatabase(path);

    print("Hello"+ todo.toJson().toString());
    await db.insert(tblName, todo.toJson());
    getTodo();
  }
  Future<void> getTodo() async {
    todoList.clear();
    String path = join(await getDatabasesPath(), databaseName);
    final db = await openDatabase(path, version: version);

    final List<Map<String, dynamic>> maps = await db.query(tblName);
    todoList.addAll(maps.map((value) => TodoModel.fromJson(value)).toList());
    print("LENGTH::::::${todoList.length}");
  }


  updeteTodu(TodoModel todo) async {
    var  databesespath = await getDatabasesPath();
    String path=join(databesespath,"${databaseName}");
    final db=await openDatabase( path);
    await db.update(tblName, todo.toJson(),
    where :"$columnId=?",
      whereArgs: [todo.id],

    );
    getTodo();
    return todo;
  }



  deleteTodo(String? id) async {
    var  databesespath =await getDatabasesPath();
    String path =join(databesespath,"${databaseName}");
    final db = await openDatabase(path);


    getTodo();
    return await db.delete(tblName,
        where:"$columnId=?",
        whereArgs: [id]);
  }

}