import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_demo/models/Schedule.dart';

class ScheduleDialog extends StatelessWidget {

  final Map<int, Schedule> _scheduleIndex = {};
  final List<String> _items = [];

  Schedule? _sehecule = null;

  ScheduleDialog(List<Schedule> schedule){
    for(int i=0; i<88; i++){
      _items.add("");
    }
    _items[1]  = "08:00";
    _items[2]  = "09:00";
    _items[3]  = "10:00";
    _items[4]  = "11:00";
    _items[5]  = "12:00";
    _items[6]  = "13:00";
    _items[7]  = "14:00";
    _items[8]  = "15:00";
    _items[9]  = "16:00";
    _items[10] = "17:00";
    _items[11] = "星期一";
    _items[22] = "星期二";
    _items[33] = "星期三";
    _items[44] = "星期四";
    _items[55] = "星期五";
    _items[66] = "星期六";
    _items[77] = "星期日";
    for (var lesson in schedule) {
      for (var str in lesson.timeJson) {
        final week = int.parse(str.substring(0,1)) * 11;
        final time = (int.parse(str.substring(1)) - 7);
        _items[time + week] = lesson.title;
        _scheduleIndex[time + week] = lesson;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, setState){
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(child: GridView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 11,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2
                      ),
                      itemCount: _items.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){
                            setState((){
                              if( _sehecule != _scheduleIndex[index] ){
                                _sehecule = _scheduleIndex[index];
                              }else{
                                _sehecule = null;
                              }
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)
                            ),
                            child: Text(_items[index], style: Get.textTheme.bodySmall),
                          ),
                        );
                      }
                  )),
                  _sehecule != null ? MaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    height: 40,
                    onPressed: (){
                      Get.back(result: _sehecule);
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text("退選【${_sehecule!.title}】"),
                    ),
                  ) : Container()
                ],
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.cancel, size: 36, color: Colors.black.withOpacity(0.3)),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),

            ],
          );
        }
      ),
    );
  }
}