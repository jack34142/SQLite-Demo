class MyUtil {
  String getLessonTime(List<String> timeJson){
    String str = timeJson.first;
    String week = str.substring(0, 1);
    String time_start = str.substring(1) + ":00";

    str = timeJson.last;
    String time_end = (int.parse(str.substring(1)) + 1).toString() + ":00";

    switch(week){
      case "1":
        week = "每週一";
        break;
      case "2":
        week = "每週二";
        break;
      case "3":
        week = "每週三";
        break;
      case "4":
        week = "每週四";
        break;
      case "5":
        week = "每週五";
        break;
      case "6":
        week = "每週六";
        break;
      case "7":
        week = "每週日";
        break;
    }
    return "$week, $time_start~$time_end";
  }
}