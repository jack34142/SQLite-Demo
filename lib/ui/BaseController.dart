import 'package:get/get.dart';
import 'package:sqlite_demo/configs/GlobalData.dart';
import 'package:sqlite_demo/ui/components/dialog/MsgDialog.dart';
import 'package:sqlite_demo/ui/controllers/OverlayController.dart';

abstract class BaseController extends GetxController{
  void showMsg(String msg){
    Get.dialog(MsgDialog(msg));
  }

  void logout(){
    Get.dialog(MsgDialog("是否要登出", buttons: [
      MsgDialogButton("登出", () {
        GlobalData.user = null;
        Get.offAllNamed("/login");
      })
    ]));
  }

  void showToast(String msg){
    OverlayController.to.showToast(msg);
  }
}