import 'package:get/get.dart';

import 'products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductsController>(
      ProductsController(),
    );
  }
}
