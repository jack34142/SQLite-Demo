import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sqlite_demo/ui/controllers/OverlayController.dart';

class MyPopScope extends StatelessWidget{

  final Widget child;

  int _lastBackPress = 0;

  MyPopScope({required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if( Get.global(null).currentState?.canPop() == true ){
          Get.back();
        }else{
          int now = DateTime.timestamp().millisecondsSinceEpoch;
          if(now - _lastBackPress < 1500){
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            }
          }else{
            _lastBackPress = now;
            OverlayController.to.showToast("再次返回退出應用");
          }
        }
      },
      child: child,
    );
  }
}