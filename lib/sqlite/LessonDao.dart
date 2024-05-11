import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqlite_demo/models/Student.dart';
import 'package:sqlite_demo/models/Teacher.dart';
import 'package:sqlite_demo/sqlite/ScheduleDao.dart';
import 'package:sqlite_demo/sqlite/SqliteHelper.dart';
import 'package:sqlite_demo/sqlite/UserDao.dart';

class LessonDao extends SqliteHelper{
  static const TABLE_NAME = "lesson";

  static const ID = "id";
  static const COLUMN_TITLE = "title";
  static const COLUMN_DESCRIPTION = "description";
  static const COLUMN_TEACHER = "teacher";
  static const COLUMN_TIME = "time_json";

  static const CREATE_TABLE = '''
CREATE TABLE IF NOT EXISTS $TABLE_NAME ( 
  $ID                 INTEGER PRIMARY KEY AUTOINCREMENT, 
  $COLUMN_TITLE       TEXT    NOT NULL,
  $COLUMN_DESCRIPTION TEXT    NOT NULL,
  $COLUMN_TEACHER     TEXT    NOT NULL,
  $COLUMN_TIME        TEXT    NOT NULL,
  FOREIGN KEY($COLUMN_TEACHER) REFERENCES ${UserDao.TABLE_NAME}(${UserDao.ID}) ON DELETE CASCADE ON UPDATE CASCADE
)
''';

  Future<int> insert({
    required String title,
    required String description,
    required int teacher_id,
    required List<String> time_json,
  }) async {
    if( !_validTimeJson(time_json) ){
      return 0;
    }
    final db = await getDb();
    return db.insert(TABLE_NAME, {
      COLUMN_TITLE: title,
      COLUMN_DESCRIPTION: description,
      COLUMN_TEACHER: teacher_id,
      COLUMN_TIME: jsonEncode(time_json),
    });
  }

  Future<int> delete(int id) async {
    final db = await getDb();
    return db.delete(TABLE_NAME, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(int id, {
    String? title,
    String? description,
    List<String>? time_json,
  }) async {
    Map<String, dynamic> data = {};
    if(title != null){
      data[COLUMN_TITLE] = title;
    }
    if(description != null){
      data[COLUMN_DESCRIPTION] = description;
    }
    if(time_json != null){
      if( !_validTimeJson(time_json) ){
        return 0;
      }
      data[COLUMN_TIME] = jsonEncode(time_json);
    }
    if(data.isEmpty){
      return 0;
    }
    final db = await getDb();
    return db.update(TABLE_NAME, data, where: '$ID = ?', whereArgs: [id]);
  }

  Future<List<Lesson>> getLessons(int teacher_id) async {
    final db = await getDb();
    final rows = await db.rawQuery('''
SELECT a.*,c.name,c.avatar 
FROM $TABLE_NAME a LEFT JOIN ${ScheduleDao.TABLE_NAME} b ON a.${ID}=b.${ScheduleDao.COLUMN_LESSON_ID} 
LEFT JOIN ${UserDao.TABLE_NAME} c ON c.${UserDao.ID}=b.${ScheduleDao.COLUMN_STUDENT} 
WHERE a.$COLUMN_TEACHER='$teacher_id'
''');

    final lessons = <int, Lesson>{};
    for (var row in rows) {
      debugPrint(row.toString());
      final lesson_id = row[ID] as int;

      if(!lessons.containsKey(lesson_id)){
        lessons[lesson_id] = Lesson.fromJson({
          ID: lesson_id,
          COLUMN_TITLE: row[COLUMN_TITLE],
          COLUMN_DESCRIPTION: row[COLUMN_DESCRIPTION],
          COLUMN_TIME: jsonDecode(row[COLUMN_TIME] as String),
          "students": []
        });
      }

      if(row["name"] != null){
        lessons[lesson_id]!.students.add(Student.fromJson({
          UserDao.COLUMN_NAME: row[UserDao.COLUMN_NAME],
          UserDao.COLUMN_AVATAR: row[UserDao.COLUMN_AVATAR],
        }));
      }
    }
    return lessons.values.toList();
  }

  // ------------------------------
  bool _validTimeJson(List<String> time_json){
    for (var str in time_json) {
      final week = int.parse(str.substring(0, 1));
      final time = int.parse(str.substring(1));
      debugPrint("$week, $time");
      if(week < 1 || week > 7){
        return false;
      }else if (time < 0 || time > 23){
        return false;
      }
    }
    return true;
  }
}