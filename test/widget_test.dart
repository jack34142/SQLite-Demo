// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite_demo/models/User.dart';
import 'package:sqlite_demo/sqlite/LessonDao.dart';
import 'package:sqlite_demo/sqlite/SqliteHelper.dart';
import 'package:sqlite_demo/sqlite/UserDao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() async {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory for unit testing calls for SQFlite
    databaseFactory = databaseFactoryFfi;
    await SqliteHelper().getEmptyDb();
  });

  test("SQLite test", () async {
    UserDao userDao = UserDao();
    LessonDao lessonDao = LessonDao();
    var user = {
      UserDao.COLUMN_NAME: "test name",
      UserDao.COLUMN_INTRODUCTION: "test introduction",
      UserDao.COLUMN_AVATAR: "https://scontent.ftpe14-1.fna.fbcdn.net/v/t39.30808-6/360160780_6368772023210857_1282950499820586998_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=5f2048&_nc_ohc=GsPVL4rWFxUQ7kNvgHDnLix&_nc_ht=scontent.ftpe14-1.fna&oh=00_AYCk-xP8oaRyquEsrs4qht9jDdktX-UPk7Pt65X1y3kcTg&oe=66452A56",
      UserDao.COLUMN_ACCOUNT: "test",
      UserDao.COLUMN_PASSWORD: "123456",
      UserDao.COLUMN_JOB: UserDao.ENUM_PROFESSOR,
    };

    expect(await userDao.insert(  // 註冊
        name: user[UserDao.COLUMN_NAME]!,
        introduction: user[UserDao.COLUMN_INTRODUCTION]!,
        avatar: user[UserDao.COLUMN_AVATAR]!,
        account: user[UserDao.COLUMN_ACCOUNT]!,
        password: user[UserDao.COLUMN_PASSWORD]!,
        job: "test job"  // job必須是 Demonstrator Lecturer Senior Lecturer Professor Student
    ), 0);  // 註冊失敗

    final uid = await userDao.insert(  // 註冊
      name: user[UserDao.COLUMN_NAME]!,
      introduction: user[UserDao.COLUMN_INTRODUCTION]!,
      avatar: user[UserDao.COLUMN_AVATAR]!,
      account: user[UserDao.COLUMN_ACCOUNT]!,
      password: user[UserDao.COLUMN_PASSWORD]!,
      job: user[UserDao.COLUMN_JOB]!
    );
    expect(uid > 0, true);  // 註冊成功

    expect(await userDao.insert(  // 用同樣的帳號再註冊一次
        name: user[UserDao.COLUMN_NAME]!,
        introduction: user[UserDao.COLUMN_INTRODUCTION]!,
        avatar: user[UserDao.COLUMN_AVATAR]!,
        account: user[UserDao.COLUMN_ACCOUNT]!,
        password: user[UserDao.COLUMN_PASSWORD]!,
        job: user[UserDao.COLUMN_JOB]!
    ), 0);  //重複帳號, uid=0

    User? userInfo = await userDao.login("test_account", "test_password");  // 用錯誤的帳號登入
    expect(userInfo, null);  // 登入失敗

    userInfo = await userDao.login(user[UserDao.COLUMN_ACCOUNT]!, user[UserDao.COLUMN_PASSWORD]!);  // 登入
    expect(userInfo != null, true);  // 登入成功
    expect(userInfo!.toJson(), {  // 檢查用戶資料
      UserDao.ID: uid,
      UserDao.COLUMN_NAME: user[UserDao.COLUMN_NAME]!,
      UserDao.COLUMN_AVATAR: user[UserDao.COLUMN_AVATAR]!,
      UserDao.COLUMN_JOB: user[UserDao.COLUMN_JOB]!
    });

    int? lesson_id = await lessonDao.insert(  //新增課程
        title: "test title",
        description: "test description",
        teacher_id: uid,
        time_json: ["456", "789"]  //給出錯誤的時間表
    );
    expect(lesson_id, 0);  // 課程新增失敗

    lesson_id = await lessonDao.insert(  //新增課程
        title: "test title",
        description: "test description",
        teacher_id: uid,
        time_json: ["108", "109"]  // 給出正確的時間表
    );
    expect(lesson_id > 0, true);  // 課程新增成功
  });
}
