import 'package:get/get.dart';

import 'products_create_update_controller.dart';

class ProductsCreateUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductsCreateUpdateController>(
        ProductsCreateUpdateController(),
    );
  }
}
