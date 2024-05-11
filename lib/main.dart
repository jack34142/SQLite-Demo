import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_demo/ui/views/LessonPage.dart';
import 'package:sqlite_demo/ui/views/OverlayPage.dart';
import 'package:sqlite_demo/ui/views/RegisterPage.dart';
import 'package:sqlite_demo/ui/views/TeacherPage.dart';
import 'package:sqlite_demo/ui/views/LoginPage.dart';

void main() {
  if (!kDebugMode) {
    debugPrint = (String? message, {int? wrapWidth}) => null;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: kDebugMode,
      // navigatorKey: Get.key,
      // navigatorObservers: [
      //   //GetObserver(),
      // ],
      title: 'SQLite Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFFABDAF8),
        useMaterial3: true
      ),
      popGesture: true,
      builder: (context, child){
        return OverlayPage(child!);
      },
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage(), binding: LoginBinding()),
        GetPage(name: '/register', page: () => RegisterPage(), binding: RegisterBinding()),
        GetPage(name: '/teacher', page: () => TeacherPage(), binding: TeacherBinding()),
        GetPage(name: '/lesson', page: () => LessonPage(), binding: LessonBinding()),
      ],
    );
  }
}