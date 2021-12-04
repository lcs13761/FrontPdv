import 'package:get/get.dart';

import 'config_change_password_controller.dart';

class ConfigChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfigChangePasswordController>(
      () => ConfigChangePasswordController(),
    );
  }
}
