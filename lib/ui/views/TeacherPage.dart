import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_demo/models/Schedule.dart';
import 'package:sqlite_demo/models/Teacher.dart';
import 'package:sqlite_demo/ui/components/MyAvatar.dart';
import 'package:sqlite_demo/ui/components/MyPopScope.dart';
import 'package:sqlite_demo/ui/components/bottomSheets/LessonBottomSheet.dart';
import 'package:sqlite_demo/ui/components/dialog/ScheduleDialog.dart';
import 'package:sqlite_demo/ui/controllers/TeacherController.dart';
import 'package:sqlite_demo/utils/MyUtil.dart';

class TeacherBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherController());
  }
}

class TeacherPage extends GetView<TeacherController>{
  @override
  Widget build(context) {
    final myUtil = MyUtil();
    return Scaffold(
      appBar: AppBar(
        title: const Text("講師清單"),
        leading: BackButton(
          onPressed: controller.logout
        ),
        actions: [
          IconButton(
            onPressed: _showScheduleDialog,
            icon: const Icon(Icons.schedule)
          )
        ],
      ),
      body: MyPopScope(
        child: Obx(() => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          itemCount: controller.teachers.length,
          itemBuilder: (context, index){
            final teacher = controller.teachers[index];
            final isInfo = controller.isShowInfo[teacher.id]!;
            return Container(
              margin: const EdgeInsets.only(bottom: 17),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(5))
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: MyAvatar(imageUrl: teacher.avatar),
                    trailing: Icon(isInfo ? Icons.remove : Icons.add),
                    title: Text(teacher.job, style: Get.textTheme.bodyMedium),
                    subtitle: Text(teacher.name, style: Get.textTheme.titleMedium),
                    onTap: (){
                      controller.isShowInfo[teacher.id] = !isInfo;
                      controller.teachers.refresh();
                    },
                  ),
                  isInfo && teacher.lessons.isNotEmpty? Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 17),
                    color: Colors.grey,
                  ) : Container(),
                  isInfo ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: teacher.lessons.length,
                    itemBuilder: (context, index){
                      Lesson lesson = teacher.lessons[index];
                      return ListTile(
                        leading: const Icon(Icons.calendar_month_outlined),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        title: Text(lesson.title, style: Get.textTheme.titleMedium),
                        subtitle: Text(myUtil.getLessonTime(lesson.timeJson), style: Get.textTheme.bodyMedium),
                        onTap: () => _showLessonBottomSheet(teacher, lesson),
                      );
                    }
                  ) : Container()
                ],
              ),
            );
          }
        ))
      ),
    );
  }

  void _showLessonBottomSheet(Teacher teacher, Lesson lesson) async {
    Lesson? data = await Get.bottomSheet(
        LessonBottomSheet(teacher, lesson, isTimeUsed: controller.isTimeUsed(lesson))
    );
    if(data != null){
      bool isAdd = await controller.addSchedule(data);
      controller.showMsg(isAdd ? "選修成功" : "已選修");
    }
  }

  void _showScheduleDialog() async {
    Schedule? data = await Get.dialog(ScheduleDialog(controller.schedules));
    if(data != null){
      bool isRemove = await controller.removeSchedule(data);
      controller.showMsg(isRemove ? "退選成功" : "已退選");
    }
  }
}