// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lustore/app/model/product.dart';
import 'package:lustore/app/model/user.dart';


class ProductsController extends GetxController {
  Product product = Product();
  TextEditingController searchProduct = TextEditingController();
  NumberFormat formatter = NumberFormat.simpleCurrency();
  User user = User();
  RxList allProducts = [].obs;
  RxList copyAllProducts = [].obs;
  RxBool isNotEmpty = false.obs;
  RxBool resultSearch = false.obs;


  @override
  void onInit() async {
    super.onInit();
    await load();
  }

  Future load() async {
    await 1.delay();
    allProducts.clear();
    var result = await product.index();
    allProducts.addAll(result["result"]);
    isNotEmpty.value = true;
  }

  void deleteProduct(code, index) async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );
    Get.back();

    var id = allProducts[index]["code"].toString();
    var verified = await product.destroy(id);
    await EasyLoading.dismiss();
    if (verified == true) {
      allProducts.removeAt(index);
    } else {
      Get.defaultDialog(
        onConfirm: () => Get.back(),
        middleText: "Erro ao excluir o produto",
      );
    }
  }

  void searchDd(String text) {
    if (copyAllProducts.isEmpty) {
      copyAllProducts.addAll(allProducts);
    }
    if (searchProduct.text.isEmpty) {
      allProducts.clear();
      allProducts.addAll(copyAllProducts);
      return;
    }
    allProducts.clear();
    List result = copyAllProducts.value
        .where((element) => element["code"].toString().contains(text) || element["product"].toString().contains(text))
        .toList();
    allProducts.addAll(result);
  }


}
