import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_demo/models/Teacher.dart';
import 'package:sqlite_demo/ui/components/MyAvatar.dart';

class LessonBottomSheet extends StatelessWidget {

  final Teacher teacher;
  final Lesson lesson;
  final bool isTimeUsed;

  LessonBottomSheet(this.teacher, this.lesson, {this.isTimeUsed = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Get.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                MyAvatar(imageUrl: teacher.avatar),
                Text(teacher.name, style: Get.textTheme.titleMedium),
                Text(teacher.job, style: Get.textTheme.bodySmall),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    children: [
                      Text(teacher.introduction),
                      Container(
                        height: 0.9,
                        color: Get.theme.primaryColor,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      Text(lesson.title, style: Get.textTheme.titleLarge),
                      const SizedBox(height: 7),
                      Text(lesson.description)
                    ],
                  ),
                ),
              ],
            ),
          )),
          SizedBox(
            width: double.infinity,
            child: MaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              height: 50,
              color: Get.theme.primaryColor,
              onPressed: isTimeUsed ? null : (){
                Get.back(result: lesson);
              },
              child: Text(isTimeUsed ? "時間不允許" : "選修")
            ),
          )
        ],
      ),
    );
  }
}