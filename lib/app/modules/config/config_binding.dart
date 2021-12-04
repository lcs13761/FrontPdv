import 'package:get/get.dart';

import 'config_controller.dart';

class ConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConfigController>(
      ConfigController(),
    );
  }
}
