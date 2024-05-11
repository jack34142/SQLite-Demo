import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_demo/models/Schedule.dart';
import 'package:sqlite_demo/sqlite/LessonDao.dart';
import 'package:sqlite_demo/sqlite/SqliteHelper.dart';
import 'package:sqlite_demo/sqlite/UserDao.dart';

class ScheduleDao extends SqliteHelper{
  static const TABLE_NAME = "schedule";

  static const COLUMN_LESSON_ID = "lesson_id";
  static const COLUMN_STUDENT = "student";

  static const CREATE_TABLE = '''
CREATE TABLE IF NOT EXISTS $TABLE_NAME ( 
  $COLUMN_LESSON_ID  TEXT    NOT NULL,
  $COLUMN_STUDENT    TEXT    NOT NULL,
  UNIQUE ($COLUMN_LESSON_ID, $COLUMN_STUDENT),
  FOREIGN KEY($COLUMN_LESSON_ID) REFERENCES ${LessonDao.TABLE_NAME}(${LessonDao.ID}) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY($COLUMN_STUDENT) REFERENCES ${UserDao.TABLE_NAME}(${UserDao.ID}) ON DELETE CASCADE ON UPDATE CASCADE
)
''';

  Future<int> insert({
    required int lesson_id,
    required int student_id,
  }) async {
    final db = await getDb();
    return db.insert(TABLE_NAME, {
      COLUMN_LESSON_ID: lesson_id,
      COLUMN_STUDENT: student_id,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> delete({required int student_id, required int lesson_id}) async {
    final db = await getDb();
    return db.delete(TABLE_NAME,
        where: '$COLUMN_STUDENT=? AND $COLUMN_LESSON_ID=?',
        whereArgs: [student_id, lesson_id]
    );
  }

  Future<List<Schedule>> getSchedule(int student_id) async {
    final db = await getDb();
    final rows = await db.rawQuery('''
SELECT b.${LessonDao.ID},b.${LessonDao.COLUMN_TITLE},b.${LessonDao.COLUMN_TIME} FROM $TABLE_NAME a LEFT JOIN ${LessonDao.TABLE_NAME} b ON a.$COLUMN_LESSON_ID=b.${LessonDao.ID} 
WHERE a.$COLUMN_STUDENT='$student_id'
''');
    return rows.map((row){
      return Schedule.fromJson({
        LessonDao.ID: row[LessonDao.ID],
        LessonDao.COLUMN_TITLE: row[LessonDao.COLUMN_TITLE],
        LessonDao.COLUMN_TIME: jsonDecode(row[LessonDao.COLUMN_TIME] as String),
      });
    }).toList();
  }
}