import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_demo/models/Teacher.dart';

class LessonDialog extends StatelessWidget {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _week = 1;
  int _timeStart = 8;
  int _timeEnd = 10;

  final _weekItem = const <DropdownMenuItem<int>>[
    DropdownMenuItem(value: 1, child: Text("每週一")),
    DropdownMenuItem(value: 2, child: Text("每週二")),
    DropdownMenuItem(value: 3, child: Text("每週三")),
    DropdownMenuItem(value: 4, child: Text("每週四")),
    DropdownMenuItem(value: 5, child: Text("每週五")),
    DropdownMenuItem(value: 6, child: Text("每週六")),
    DropdownMenuItem(value: 7, child: Text("每週日")),
  ];

  final _timeItem = const <DropdownMenuItem<int>>[
    DropdownMenuItem(value: 8, child:  Text("08:00")),
    DropdownMenuItem(value: 9, child:  Text("09:00")),
    DropdownMenuItem(value: 10, child: Text("10:00")),
    DropdownMenuItem(value: 11, child: Text("11:00")),
    DropdownMenuItem(value: 12, child: Text("12:00")),
    DropdownMenuItem(value: 13, child: Text("13:00")),
    DropdownMenuItem(value: 14, child: Text("14:00")),
    DropdownMenuItem(value: 15, child: Text("15:00")),
    DropdownMenuItem(value: 16, child: Text("16:00")),
    DropdownMenuItem(value: 17, child: Text("17:00")),
    DropdownMenuItem(value: 18, child: Text("18:00")),
  ];

  final Lesson? lesson;

  LessonDialog({this.lesson}){
    if(lesson != null){
      _titleController.text = lesson!.title;
      _descriptionController.text = lesson!.description;
      var str = lesson!.timeJson.first;
      _week = int.parse(str.substring(0,1));
      _timeStart = int.parse(str.substring(1));

      str = lesson!.timeJson.last;
      _timeEnd = int.parse(str.substring(1)) + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18))
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Text(_getButtonText(), style: Get.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold
                  )),
                ),
                _buildTextField("課程名稱", _titleController),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  child: _buildTextField("課程簡介", _descriptionController, maxLines: 9),
                ),
                Row(
                  children: [
                    DropdownButton<int>(
                        value: _week,
                        items: _weekItem,
                        onChanged: (value){
                          setState((){
                            _week = value!;
                          });
                        }
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                        value: _timeStart,
                        items: _timeItem,
                        onChanged: (value){
                          if(value! < _timeEnd){
                            setState((){
                              _timeStart = value;
                            });
                          }
                        }
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 10),
                      child: const Text("~"),
                    ),
                    DropdownButton<int>(
                        value: _timeEnd,
                        items: _timeItem,
                        onChanged: (value){
                          if(value! > _timeStart){
                            setState((){
                              _timeEnd = value;
                            });
                          }
                        }
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: (){
                        Get.back();
                      },
                      child: const Text("關閉")
                    ),
                    FilledButton(onPressed: (){
                      if(_titleController.text.isEmpty || _descriptionController.text.isEmpty){
                        return;
                      }
                      String timeStart = "$_week$_timeStart";
                      String timeEnd = "$_week${_timeEnd-1}";

                      final data = Lesson(
                          id: lesson!=null ? lesson!.id : 0,
                          title: _titleController.text,
                          description: _descriptionController.text,
                          timeJson: [timeStart, timeEnd]
                      );
                      Get.back(result: data);
                    }, child: Text(_getButtonText()))
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  String _getButtonText(){
    return lesson==null ? "新增" : "編輯";
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, void Function(String)? onChange}){
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        )
      ),
      onChanged: onChange,
    );
  }
}