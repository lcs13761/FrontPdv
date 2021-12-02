import 'package:get/get.dart';

import 'login_forget_password_controller.dart';

class LoginForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginForgetPasswordController>(
      () => LoginForgetPasswordController(),
    );
  }
}
