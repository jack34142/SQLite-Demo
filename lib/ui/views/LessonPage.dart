import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_demo/models/Student.dart';
import 'package:sqlite_demo/models/Teacher.dart';
import 'package:sqlite_demo/ui/components/MyAvatar.dart';
import 'package:sqlite_demo/ui/components/MyPopScope.dart';
import 'package:sqlite_demo/ui/components/dialog/LessonDialog.dart';
import 'package:sqlite_demo/ui/components/dialog/MsgDialog.dart';
import 'package:sqlite_demo/ui/controllers/LessonController.dart';
import 'package:sqlite_demo/utils/MyUtil.dart';

class LessonBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LessonController());
  }
}

class LessonPage extends GetView<LessonController>{
  @override
  Widget build(context) {
    final myUtil = MyUtil();
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的課表"),
        leading: BackButton(
          onPressed: controller.logout,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLessonDialog,
        child: const Icon(Icons.add),
      ),
      body: MyPopScope(
        child: Obx(() => ListView.builder(
            itemCount: controller.lessons.length,
            padding: const EdgeInsets.symmetric(horizontal: 17),
            itemBuilder: (context, index){
              final lesson = controller.lessons[index];
              final isInfo = controller.isShowInfo[lesson.id]!;
              return Container(
                margin: const EdgeInsets.only(bottom: 17),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.5),
                    borderRadius: const BorderRadius.all(Radius.circular(5))
                ),
                child: Column(
                  children: [
                    ListTile(
                      trailing: Icon(isInfo ? Icons.remove : Icons.add),
                      title: Text(lesson.title, style: Get.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold
                      )),
                      subtitle: Text(myUtil.getLessonTime(lesson.timeJson), style: Get.textTheme.bodyMedium),
                      onTap: (){
                        controller.isShowInfo[lesson.id] = !isInfo;
                        controller.lessons.refresh();
                      },
                    ),
                    isInfo ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lesson.description),
                          Row(
                            children: [
                              Expanded(child: MaterialButton(
                                  onPressed: () => onDeleteClick(lesson),
                                  child: const Icon(Icons.delete)
                              )),
                              Expanded(child: MaterialButton(
                                onPressed: () => _editLessonDialog(lesson),
                                child: const Icon(Icons.edit)
                              )),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 1, top: 0),
                            child: Text("學生(${lesson.students.length})", style: Get.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold
                            )),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 3),
                              itemCount: lesson.students.length,
                              itemBuilder: (context, index){
                                Student student = lesson.students[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      MyAvatar(imageUrl: student.avatar),
                                      const SizedBox(width: 8),
                                      Text(student.name)
                                    ],
                                  ),
                                );
                              }
                          )
                        ],
                      ) ,
                    ): Container()
                  ],
                ),
              );
            }
        ))
      ),
    );
  }

  void onDeleteClick(Lesson lesson) async {
    bool? data = await Get.dialog(MsgDialog("請問是否要刪除課程【${lesson.title}】", buttons: [
      MsgDialogButton("刪除", () {
        Get.back(result: true);
      })
    ]));

    if(data != null && data){
      bool isDelete = await controller.deleteLesson(lesson);
      controller.showMsg(isDelete ? "課程刪除成功" : "課程已刪除");
    }
  }

  void _addLessonDialog() async {
    Lesson? data = await Get.dialog(LessonDialog());
    if(data != null){
      bool isAdd = await controller.addLesson(data);
      controller.showMsg(isAdd ? "課程新增成功" : "課程新增失敗");
    }
  }

  void _editLessonDialog(Lesson lesson) async {
    Lesson? data = await Get.dialog(LessonDialog(lesson: lesson));
    if(data != null){
      if(lesson == data){
        controller.showMsg("課程沒有變化");
      }else{
        bool isEdit = await controller.editLesson(data);
        controller.showMsg(isEdit ? "課程修改成功" : "課程沒有變化");
      }
    }
  }
}