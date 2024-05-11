// https://www.webinovers.com/web-tools/json-to-dart-convertor
import 'package:flutter/foundation.dart';
import 'package:sqlite_demo/models/Student.dart';

class Teacher {
  Teacher({
    required this.id,
    required this.name,
    required this.introduction,
    required this.avatar,
    required this.job,
    required this.lessons,
  });
  late final int id;
  late final String name;
  late final String introduction;
  late final String avatar;
  late final String job;
  late final List<Lesson> lessons;

  Teacher.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    introduction = json['introduction'];
    avatar = json['avatar'];
    job = json['job'];
    lessons = List.from(json['lessons']).map((e)=>Lesson.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['introduction'] = introduction;
    _data['avatar'] = avatar;
    _data['job'] = job;
    _data['lessons'] = lessons.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Lesson {
  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.timeJson,
    this.students = const []
  });
  late final int id;
  late final String title;
  late final String description;
  late final List<String> timeJson;
  late final List<Student> students;

  Lesson.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    description = json['description'];
    timeJson = List.castFrom<dynamic, String>(json['time_json']);
    students = json.containsKey('students') ? (json['students'] as List).map((e)=>Student.fromJson(e)).toList() : [];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['description'] = description;
    _data['time_json'] = timeJson;
    _data['students'] = students.map((e)=>e.toJson()).toList();
    return _data;
  }

  @override
  bool operator ==(Object other) {
    return (other is Lesson) &&
        other.id==id &&
        other.title==title &&
        other.description==description &&
        listEquals(other.timeJson, timeJson);
  }
}