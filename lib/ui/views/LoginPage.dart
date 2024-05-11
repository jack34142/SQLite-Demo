import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_demo/ui/components/MyPopScope.dart';
import 'package:sqlite_demo/ui/controllers/LoginController.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}

class LoginPage extends GetView<LoginController>{
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(context) {
    return MyPopScope(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => Wrap(
            children: controller.accounts.map((account) => TextButton(
                onPressed: () {
                  _accountController.text = account.account;
                  _passwordController.text = account.password;
                  _updateLoginEnable("");
                },
                child: Text("[${account.job}]${account.account}", style: const TextStyle(fontSize: 13))
            )).toList(),
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              children: [
                TextField(
                  controller: _accountController,
                  decoration: const InputDecoration(labelText: '帳號'),
                  onChanged: _updateLoginEnable,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '密碼',
                  ),
                  onChanged: _updateLoginEnable,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: register,
                      child: const Text("註冊")
                    ),
                    Obx(() => FilledButton(
                        onPressed: controller.loginEnable.value ? (){
                          controller.login(_accountController.text, _passwordController.text);
                        } : null,
                        child: const Text("登入")
                    ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _updateLoginEnable(String text){
    controller.loginEnable.value = _accountController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  }

  void register() async {
    final data = await Get.toNamed("/register");
    if(data != null && (data as bool) ){
      controller.showMsg("註冊成功");
      controller.getAccount();
    }
  }
}