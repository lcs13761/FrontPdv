import 'package:get/get.dart';

import 'config_admin_controller.dart';

class ConfigAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConfigAdminController>(
      ConfigAdminController(),
    );
  }
}
