import 'package:desktop_window/desktop_window.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lustore/model/user.dart';
import 'dart:ui' as ui;


class SplashController extends GetxController {

  final store = GetStorage();
  User user = User();

  @override
  void onInit() async{
    super.onInit();

    await DesktopWindow.setMinWindowSize(ui.window.physicalSize);
    await 1.delay();
    if(store.read("token") != null){
      await user.refreshJwt();
      Get.offNamed("/home");
    }else{
      Get.offNamed("/login");
    }

  }

}
