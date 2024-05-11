import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlite_demo/sqlite/UserDao.dart';
import 'package:sqlite_demo/ui/components/MyAvatar.dart';
import 'package:sqlite_demo/ui/components/MyPopScope.dart';
import 'package:sqlite_demo/ui/controllers/RegisterController.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}

class RegisterPage extends GetView<RegisterController>{
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _introductionController = TextEditingController();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: MyPopScope(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  color: Colors.grey,
                  child: InkWell(
                    onTap: getLostData,
                    child: Obx(() => MyAvatar(imageUrl: controller.imageUrl.value, size: 120)),
                  ),
                ),
                TextField(
                  controller: _accountController,
                  decoration: const InputDecoration(
                      label: Text("帳號")
                  ),
                  onChanged: updateCanRegister,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      label: Text("密碼")
                  ),
                  onChanged: (text){
                    controller.isPasswordSame.value = _password2Controller.text == _passwordController.text;
                    updateCanRegister(text);
                  },
                ),
                Obx(() => TextField(
                  controller: _password2Controller,
                  obscureText: true,
                  decoration: InputDecoration(
                      label: Text("密碼確認", style: TextStyle(
                          color: controller.isPasswordSame.value ? null : Colors.red
                      ))
                  ),
                  onChanged: (text){
                    controller.isPasswordSame.value = _password2Controller.text == _passwordController.text;
                    updateCanRegister(text);
                  },
                )),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      label: Text("姓名")
                  ),
                  onChanged: updateCanRegister,
                ),
                TextField(
                  controller: _introductionController,
                  decoration: const InputDecoration(
                      label: Text("自我介紹")
                  ),
                  onChanged: updateCanRegister,
                ),
                Row(
                  children: [
                    Text("身份"),
                    SizedBox(width: 17),
                    Obx(() => DropdownButton<String>(
                        value: controller.job.value,
                        items: const [
                          DropdownMenuItem(value: UserDao.ENUM_DEMONSTRATOR, child: Text(UserDao.ENUM_DEMONSTRATOR)),
                          DropdownMenuItem(value: UserDao.ENUM_SENIOR_LECTURER, child: Text(UserDao.ENUM_SENIOR_LECTURER)),
                          DropdownMenuItem(value: UserDao.ENUM_LECTURER, child: Text(UserDao.ENUM_LECTURER)),
                          DropdownMenuItem(value: UserDao.ENUM_PROFESSOR, child: Text(UserDao.ENUM_PROFESSOR)),
                          DropdownMenuItem(value: UserDao.ENUM_STUDENT, child: Text(UserDao.ENUM_STUDENT)),
                        ], onChanged: (value) => controller.job.value = value!
                    ))
                  ],
                ),
                Obx(() => FilledButton(
                    onPressed: controller.canRegister.value ? register : null,
                    child: const Text("註冊")
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------
  void updateCanRegister(String text){
    controller.canRegister.value = _introductionController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _password2Controller.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _introductionController.text.isNotEmpty &&
        controller.imageUrl.isNotEmpty &&
        controller.isPasswordSame.value;
  }

  Future<void> getLostData() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 200,
      maxHeight: 200,
      imageQuality: 90,
    );

    if( pickedFile != null ){
      final base64 = base64Encode(await pickedFile.readAsBytes());
      // final ext = pickedFile.name.split(".").last;
      controller.imageUrl.value = base64;
      // debugPrint(controller.imageUrl.value.length.toString());
      updateCanRegister("");
    }
  }

  void register() async {
    bool isRegister = await controller.register(_accountController.text,
        _passwordController.text,
        _nameController.text,
        _introductionController.text);
    if(isRegister){
      Get.back(result: true);
    }else{
      controller.showMsg("帳號已被註冊");
    }
  }
}