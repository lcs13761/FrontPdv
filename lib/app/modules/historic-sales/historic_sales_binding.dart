import 'package:get/get.dart';

import 'historic_sales_controller.dart';

class HistoricSalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoricSalesController>(
      () => HistoricSalesController(),
    );
  }
}
