class Student {
  Student({
    required this.name,
    required this.avatar,
  });
  late final String name;
  late final String avatar;

  Student.fromJson(Map<String, dynamic> json){
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['avatar'] = avatar;
    return _data;
  }
}