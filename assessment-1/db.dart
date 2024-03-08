import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDb
{
  late Database db;

  Future open() async
  {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'demo.db');
    print(path);

    db = await openDatabase(path, version: 1,
        onCreate: (Database db , int version) async
        {
          await db.execute('''
          CREATE TABLE IF NOT EXISTS STUDENTS(
          id primary key,
          word varchar (255) not null,
          meaning varchar(255) not null
          );
          
          ''');

          print("Table Created");
        }
    );
  }


  Future<Map<dynamic , dynamic>?> getStudent(String word) async
  {
    List<Map> maps = await db.query('students',
        where: 'word = ?',
        whereArgs: [word]);

    if(maps.length > 0)
    {
      return maps.first;
    }
    return null;
  }
}