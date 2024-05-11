import 'package:get/get.dart';
import 'package:sqlite_demo/sqlite/UserDao.dart';
import 'package:sqlite_demo/ui/BaseController.dart';

class RegisterController extends BaseController {
  static RegisterController get to => Get.find();

  final imageUrl = "".obs;
  final job = UserDao.ENUM_STUDENT.obs;
  final canRegister = false.obs;
  final isPasswordSame = true.obs;

  Future<bool> register(String account, String password, String name, String introduction) async {
    int id = await UserDao().insert(
        name: name,
        introduction:
        introduction,
        avatar: imageUrl.value,
        account: account,
        password: password,
        job: job.value
    );
    return id > 0;
  }
}