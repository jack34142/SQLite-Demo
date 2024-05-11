import 'package:get/get.dart';
import 'package:sqlite_demo/ui/BaseController.dart';

class OverlayController extends BaseController {
  static OverlayController get to => Get.find();

  final isToast = false.obs;
  final toastString = "".obs;

  @override
  void showToast(String msg) {
    isToast.value = true;
    toastString.value = msg;

    Future.delayed(const Duration(milliseconds: 1500), () {
      isToast.value = false;
    });
  }
}