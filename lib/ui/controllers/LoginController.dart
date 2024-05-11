import 'package:get/get.dart';
import 'package:sqlite_demo/configs/GlobalData.dart';
import 'package:sqlite_demo/models/Account.dart';
import 'package:sqlite_demo/sqlite/UserDao.dart';
import 'package:sqlite_demo/ui/BaseController.dart';

class LoginController extends BaseController {
  static LoginController get to => Get.find();

  final loginEnable = false.obs;
  final accounts = <Account>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAccount();
  }

  // for test use
  Future<bool> getAccount() async {
    accounts.clear();
    accounts.addAll( await UserDao().getAccount() );
    accounts.refresh();
    return true;
  }

  Future<bool> login(String account, String password) async {
    final user = await UserDao().login(account, password);
    if(user == null){
      return false;
    }else{
      GlobalData.user = user;
      if(user.job == UserDao.ENUM_STUDENT){
        Get.offAllNamed('/teacher');
      }else{
        Get.offAllNamed('/lesson');
      }
      return true;
    }
  }
}