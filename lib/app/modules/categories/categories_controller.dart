import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lustore/app/model/category.dart';
import 'package:lustore/app/model/product.dart';
import 'package:lustore/app/model/user.dart';


class CategoriesController extends GetxController {
  MoneyMaskedTextController costMonth = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', precision: 2);
  User user = User();
  Product product = Product();
  Category category = Category();
  TextEditingController nameCategory = TextEditingController();
  RxBool categoryIsEmpty = true.obs;
  RxList<dynamic> listCategories = <dynamic>[].obs;
  RxString test = "".obs;

  @override
  void onInit() async {
    super.onInit();
    await getCategories();
  }

  getCategories() async {
    var getAll = await category.index();
    if (getAll["result"].toString().isEmpty) {
      return;
    }
    nameCategory.text = "";
    listCategories.clear();
    categoryIsEmpty.value = false;
    listCategories.addAll(getAll["result"]);
  }

  void monthCost() async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );
    Map data = {
      "value": costMonth.text.contains(".")
          ? costMonth.text.replaceAll(".", "").replaceAll(",", ".")
          : costMonth.text.replaceAll(",", "."),
      "month": DateTime.now().month
    };
    await EasyLoading.dismiss();
    var verified = await product.store(data);
    if (verified) {
      costMonth.text = "0.0";
    } else {
      Get.defaultDialog(
        onConfirm: () => Get.back(),
        middleText: "Erro ao adicionar o produto",
      );
      await EasyLoading.dismiss();
    }
  }

  void categoryCreate() async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );
    category.category =  nameCategory.text;
    var verified = await category.store(category);
    await EasyLoading.dismiss();
    if (verified) {
      await getCategories();
    } else {
      Get.defaultDialog(
        onConfirm: () => Get.back(),
        middleText: "Erro ao adicionar",
      );

    }
  }

  void categoryUpdate(String id) async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );
    Get.back();
    category.category =  nameCategory.text;
    category.id = int.parse(id);

    var verified = await category.update(category,1);
    if (verified == true) {
      await getCategories();
      await EasyLoading.dismiss();
      return;
    }
    await EasyLoading.dismiss();
    Get.defaultDialog(
      onConfirm: () => Get.back(),
      middleText: "Erro ao adicionar",
    );
  }

  void categoryDelete(String id,int index) async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );
    var verified = await category.destroy(id);

    if (verified == true) {
      listCategories.removeAt(index);
      await EasyLoading.dismiss();
    } else {
      await EasyLoading.dismiss();
      Get.defaultDialog(
        onConfirm: () => Get.back(),
        middleText: "Erro ao excluir",
      );
    }

  }


}
