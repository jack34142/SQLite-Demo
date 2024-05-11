import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MsgDialogButton {
  final String text;
  final void Function() onTap;
  MsgDialogButton(this.text, this.onTap);
}

class MsgDialog extends StatelessWidget {
  final String msg;
  final List<MsgDialogButton> buttons;

  MsgDialog(this.msg, {this.buttons = const []});

  @override
  Widget build(BuildContext context) {

    final buttonWidget = <Widget>[];
    buttonWidget.add(_buildButton(
      MsgDialogButton("關閉", () {
        Get.back();
      })
    ));
    for (var myButton in buttons) {
      buttonWidget.add(_buildButton(myButton));
    }

    return PopScope(
        canPop: true,
        child: Dialog(
          clipBehavior: Clip.hardEdge,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18))
          ),
          // insetPadding: EdgeInsets.all(0),  //margin
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 1),
                child: Text("訊息", style: Get.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold
                )),
              ),
              Flexible(child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 4),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 58,
                    ),
                    child:Center(
                      child: Text(msg),
                    ),
                  )
                ),
              )),
              Row(
                children: buttonWidget,
              )
            ],
          ),
        )
    );
  }

  _buildButton(MsgDialogButton myButton){
    return Expanded(child: MaterialButton(
      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        height: 45,
        onPressed: myButton.onTap,
        child: Text(myButton.text)
    ));
  }

}