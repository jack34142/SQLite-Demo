import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_demo/models/Account.dart';
import 'package:sqlite_demo/models/Teacher.dart';
import 'package:sqlite_demo/models/User.dart';
import 'package:sqlite_demo/sqlite/LessonDao.dart';
import 'package:sqlite_demo/sqlite/SqliteHelper.dart';

class UserDao extends SqliteHelper {
  static const TABLE_NAME = "user";

  static const ID = "id";
  static const COLUMN_NAME = "name";
  static const COLUMN_INTRODUCTION = "introduction";
  static const COLUMN_AVATAR = "avatar";
  static const COLUMN_ACCOUNT = "account";
  static const COLUMN_PASSWORD = "password";
  static const COLUMN_JOB = "job";

  static const ENUM_DEMONSTRATOR = "Demonstrator";
  static const ENUM_LECTURER = "Lecturer";
  static const ENUM_SENIOR_LECTURER = "Senior Lecturer";
  static const ENUM_PROFESSOR = "Professor";
  static const ENUM_STUDENT = "Student";

  static const CREATE_TABLE = '''
CREATE TABLE IF NOT EXISTS $TABLE_NAME ( 
  $ID                  INTEGER PRIMARY KEY AUTOINCREMENT, 
  $COLUMN_NAME         TEXT    NOT NULL,
  $COLUMN_INTRODUCTION TEXT    NOT NULL,
  $COLUMN_AVATAR       TEXT    NOT NULL,
  $COLUMN_ACCOUNT      TEXT    NOT NULL,
  $COLUMN_PASSWORD     TEXT    NOT NULL,
  $COLUMN_JOB          TEXT    NOT NULL CHECK( $COLUMN_JOB IN ('$ENUM_DEMONSTRATOR','$ENUM_LECTURER','$ENUM_SENIOR_LECTURER','$ENUM_PROFESSOR','$ENUM_STUDENT') ),
  UNIQUE ($COLUMN_ACCOUNT)
)
''';

  Future<int> insert({
    required String name,
    required String introduction,
    required String avatar,
    required String account,
    required String password,
    required String job
  }) async {
    final db = await getDb();
    return db.insert(TABLE_NAME, {
      COLUMN_NAME: name,
      COLUMN_INTRODUCTION: introduction,
      COLUMN_AVATAR: avatar,
      COLUMN_ACCOUNT: account,
      COLUMN_PASSWORD: password,
      COLUMN_JOB: job,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> delete(int id) async {
    final db = await getDb();
    return db.delete(TABLE_NAME, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(int id, {
    String? name,
    String? introduction,
    String? avatar,
    String? password,
    String? job
  }) async {
    Map<String, dynamic> data = {};
    if(name != null){
      data[COLUMN_NAME] = name;
    }
    if(introduction != null){
      data[COLUMN_INTRODUCTION] = introduction;
    }
    if(avatar != null){
      data[COLUMN_AVATAR] = avatar;
    }
    if(password != null){
      data[COLUMN_PASSWORD] = password;
    }
    if(job != null){
      switch(job){
        case ENUM_DEMONSTRATOR:
        case ENUM_LECTURER:
        case ENUM_SENIOR_LECTURER:
        case ENUM_PROFESSOR:
        case ENUM_STUDENT:
          data[COLUMN_JOB] = job;
        default:
          throw Exception("invalid job string");
      }
    }
    if(data.isEmpty){
      return 0;
    }
    final db = await getDb();
    return db.update(TABLE_NAME, data, where: '$ID = ?', whereArgs: [id]);
  }

  Future<List<Account>> getAccount() async {
    final db = await getDb();
    final rows = await db.query(TABLE_NAME, columns: [COLUMN_ACCOUNT, COLUMN_PASSWORD, COLUMN_JOB]);
    return rows.map((e) => Account.fromJson(e)).toList();
  }
  
  Future<User?> login(String account, String password) async {
    final db = await getDb();
    final rows = await db.query(TABLE_NAME,
        columns: [ID, COLUMN_NAME, COLUMN_AVATAR, COLUMN_JOB],
        where: "$COLUMN_ACCOUNT=? AND $COLUMN_PASSWORD=?",
        whereArgs: [account, password]
    );
    if(rows.length != 1){
      return null;
    }
    final row = rows.first;
    return User(
        id: row[ID] as int,
        name: row[COLUMN_NAME] as String,
        avatar: row[COLUMN_AVATAR] as String,
        job: row[COLUMN_JOB] as String
    );
  }

  Future<List<Teacher>> getTeacher() async {
    final db = await getDb();
    final rows = await db.rawQuery('''
SELECT a.$COLUMN_NAME,a.$COLUMN_JOB,a.$COLUMN_INTRODUCTION,a.$COLUMN_AVATAR,b.*,b.${LessonDao.ID} as `lesson_id`,a.$ID 
FROM $TABLE_NAME a LEFT JOIN ${LessonDao.TABLE_NAME} b ON a.${ID}=b.${LessonDao.COLUMN_TEACHER} 
WHERE a.$COLUMN_JOB<>'$ENUM_STUDENT'
''');
    final teachers = <int, Teacher>{};
    for (var row in rows) {
      debugPrint(row.toString());
      final teacher_id = row[ID] as int;

      if(!teachers.containsKey(teacher_id)){
        teachers[teacher_id] = Teacher.fromJson({
          ID: teacher_id,
          COLUMN_NAME: row[COLUMN_NAME],
          COLUMN_INTRODUCTION: row[COLUMN_INTRODUCTION],
          COLUMN_AVATAR: row[COLUMN_AVATAR],
          COLUMN_JOB: row[COLUMN_JOB],
          "lessons": []
        });
      }

      if(row["lesson_id"] != null){
        teachers[teacher_id]!.lessons.add(Lesson.fromJson({
          LessonDao.ID: row["lesson_id"],
          LessonDao.COLUMN_TITLE: row[LessonDao.COLUMN_TITLE],
          LessonDao.COLUMN_DESCRIPTION: row[LessonDao.COLUMN_DESCRIPTION],
          LessonDao.COLUMN_TIME: jsonDecode(row[LessonDao.COLUMN_TIME] as String),
        }));
      }
    }
    return teachers.values.toList();
  }
}