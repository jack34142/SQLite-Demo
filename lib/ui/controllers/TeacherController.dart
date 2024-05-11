import 'package:get/get.dart';
import 'package:sqlite_demo/configs/GlobalData.dart';
import 'package:sqlite_demo/models/Schedule.dart';
import 'package:sqlite_demo/models/Teacher.dart';
import 'package:sqlite_demo/sqlite/ScheduleDao.dart';
import 'package:sqlite_demo/sqlite/UserDao.dart';
import 'package:sqlite_demo/ui/BaseController.dart';

class TeacherController extends BaseController {
  static TeacherController get to => Get.find();

  final teachers = <Teacher>[].obs;
  final isShowInfo = <int, bool>{}.obs;

  final schedules = <Schedule>[];
  final _timeUsed = <String>{};

  @override
  void onInit() {
    super.onInit();
    getSchedule();
    getTeachers();
  }

  Future<void> getTeachers() async {
    List<Teacher> teachers = await UserDao().getTeacher();
    this.teachers.clear();
    for (var teacher in teachers) {
      this.teachers.add(teacher);
      isShowInfo[teacher.id] = false;
    }
    this.teachers.refresh();
  }

  Future<List<Schedule>> getSchedule() async {
    schedules.clear();
    schedules.addAll(await ScheduleDao().getSchedule(GlobalData.user!.id));
    for (var schedule in schedules) {
      for (var str in schedule.timeJson) {
        _timeUsed.add(str);
      }
    }
    return schedules;
  }

  Future<bool> addSchedule(Lesson lesson) async {
    final affect_rows = await ScheduleDao().insert(lesson_id: lesson.id, student_id: GlobalData.user!.id);
    if(affect_rows == 0){
      return false;
    }

    schedules.add(Schedule(
        id: lesson.id,
        title: lesson.title,
        timeJson: lesson.timeJson
    ));
    for (var str in lesson.timeJson) {
      _timeUsed.add(str);
    }
    return true;
  }

  Future<bool> removeSchedule(Schedule schedule) async {
    final affect_rows = await ScheduleDao().delete(lesson_id: schedule.id, student_id: GlobalData.user!.id);
    if(affect_rows == 0){
      return false;
    }

    schedules.removeWhere((element) => element.id == schedule.id);
    for (var str in schedule.timeJson) {
      _timeUsed.remove(str);
    }
    return true;
  }

  // ------------------------------
  bool isTimeUsed(Lesson lesson){
    for (var str in lesson.timeJson) {
      if(_timeUsed.contains(str)){
        return true;
      }
    }
    return false;
  }

}