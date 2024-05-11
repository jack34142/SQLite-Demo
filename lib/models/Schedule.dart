class Schedule {
  Schedule({
    required this.id,
    required this.title,
    required this.timeJson,
  });
  late final int id;
  late final String title;
  late final List<String> timeJson;

  Schedule.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    timeJson = List.castFrom<dynamic, String>(json['time_json']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['time_json'] = timeJson;
    return _data;
  }
}