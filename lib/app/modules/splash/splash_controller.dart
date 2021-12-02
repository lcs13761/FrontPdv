import 'package:desktop_window/desktop_window.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:ui' as ui;

import 'package:lustore/app/routes/app_pages.dart';


class SplashController extends GetxController {

  final store = GetStorage();

  @override
  void onInit() async{
    super.onInit();

    await DesktopWindow.setMinWindowSize(ui.window.physicalSize);
    await 2.delay();
    if(store.read("remember") != null && store.read("remember") == true){
      Get.offAllNamed("/home");
    }else{
      Get.offAllNamed(Routes.LOGIN);
    }
  }

}
