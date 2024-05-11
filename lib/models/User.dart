/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        required this.name,
        required this.id,
        required this.avatar,
        required this.job,
    });

    String name;
    int id;
    String avatar;
    String job;

    factory User.fromJson(Map<dynamic, dynamic> json) => User(
        name: json["name"],
        id: json["id"],
        avatar: json["avatar"],
        job: json["job"],
    );

    Map<dynamic, dynamic> toJson() => {
        "name": name,
        "id": id,
        "avatar": avatar,
        "job": job,
    };
}
