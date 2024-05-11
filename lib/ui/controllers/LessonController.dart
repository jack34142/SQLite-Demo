import 'package:get/get.dart';
import 'package:sqlite_demo/configs/GlobalData.dart';
import 'package:sqlite_demo/models/Teacher.dart';
import 'package:sqlite_demo/sqlite/LessonDao.dart';
import 'package:sqlite_demo/ui/BaseController.dart';

class LessonController extends BaseController {
  static LessonController get to => Get.find();

  final lessons = <Lesson>[].obs;
  final isShowInfo = <int, bool>{}.obs;

  @override
  onInit(){
    super.onInit();
    getLessons();
  }

  Future<void> getLessons() async {
    lessons.clear();
    isShowInfo.clear();
    lessons.addAll( await LessonDao().getLessons(GlobalData.user!.id) );
    for (var lesson in lessons) {
      isShowInfo[lesson.id] = false;
    }
    lessons.refresh();
  }

  Future<bool> deleteLesson(Lesson lesson) async {
    int affect_rows = await LessonDao().delete(lesson.id);
    if( affect_rows == 0){
      return false;
    }

    lessons.removeWhere((element) => element.id == lesson.id);
    isShowInfo.remove(lesson.id);
    lessons.refresh();
    return true;
  }

  Future<bool> editLesson(Lesson lesson) async {
    int affect_rows = await LessonDao().update(lesson.id,
      title: lesson.title,
      description: lesson.description,
      time_json: lesson.timeJson
    );
    if( affect_rows == 0){
      return false;
    }
    int index = lessons.indexWhere((element) => element.id == lesson.id);
    lessons[index] = lesson;
    lessons.refresh();
    return true;
  }

  Future<bool> addLesson(Lesson lesson) async {
    int lesson_id = await LessonDao().insert(
      title: lesson.title,
      description: lesson.description,
      time_json: lesson.timeJson,
      teacher_id: GlobalData.user!.id
    );
    if( lesson_id == 0){
      return false;
    }
    final row = lesson.toJson();
    row["id"] = lesson.id;
    lesson = Lesson.fromJson(row);

    lessons.add(lesson);
    isShowInfo[lesson.id] = false;
    lessons.refresh();
    return true;
  }
}