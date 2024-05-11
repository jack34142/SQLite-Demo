import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_demo/ui/controllers/OverlayController.dart';

// 自製 showToast overlay
class OverlayPage extends StatelessWidget{

  final Widget child;

  const OverlayPage(this.child, {super.key});

  @override
  Widget build(context) {
    final controller = Get.put(OverlayController());

    return Scaffold(
      body: Stack(
        alignment:Alignment.center,
        children: [
          child,
          Obx(() => Positioned(
            bottom: Get.height*0.1,
            child: AnimatedOpacity(
              opacity: controller.isToast.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                child: Container(
                  constraints: BoxConstraints(maxWidth: Get.width*0.8),
                  // margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  decoration: const BoxDecoration(
                      color: Color(0x88000000),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Text(controller.toastString.value, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}