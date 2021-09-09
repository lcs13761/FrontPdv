import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:lustore/model/product.dart';
import 'package:lustore/model/sale.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:lustore/model/user.dart';


class HomeController extends GetxController {
  TextEditingController client = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController qts = TextEditingController();
  TextEditingController valueDiscount = TextEditingController();
  NumberFormat formatter = NumberFormat.simpleCurrency();
  User user = User();
  Sale sale = Sale();
  MoneyMaskedTextController discountGroup = MoneyMaskedTextController(
    initialValue: 0,
    decimalSeparator: "",
    thousandSeparator: "",
    precision: 1,
  );
  MoneyMaskedTextController allDiscount = MoneyMaskedTextController(
    initialValue: 0,
    decimalSeparator: "",
    thousandSeparator: "",
    precision: 1,
  );
  final store = GetStorage();
  RxList allProductSales = [].obs;
  RxDouble subTotal = 0.0.obs;
  RxDouble total = 0.0.obs;
  String idSales = "";
  RxBool productSelect = false.obs;
  RxDouble discount = 0.0.obs;
  RxDouble saleValuesFinal = 0.0.obs;
  RxDouble valueProduct = 0.0.obs;
  RxString image = "".obs;
  RxString nameProduct = "".obs;
  RxString codeProduct = "".obs;
  RxString sizeProduct = "".obs;
  RxInt updateQts = 1.obs;



  @override
  void onInit() {
    super.onInit();
    if (store.read("sales").length != 0) {
      allProductSales.addAll(store.read("sales"));
      calcSaleNow();
    }
    if(store.read("client") != null){
        client.text = store.read("client");
    }
    qts.text = "1";
  }

  void getAllSalesNow() async {
    await store.remove("sales");
    store.write("sales", allProductSales);
    calcSaleNow();
  }
  valueDiscountAll(String value, String valueCost, {calc}){
    var calcDiscount = double.parse(value) / 100;
    calcDiscount = (double.parse(valueCost)) * calcDiscount;
    if(calc == true){
      return (double.parse(valueCost) - calcDiscount);
    }
    saleValuesFinal.value = (double.parse(valueCost) - calcDiscount);
  }

  void calcSaleNow() {
    if (allProductSales.isEmpty) {
      subTotal.value = 0.0;
      image.value = "";
      nameProduct.value = "";
      codeProduct.value = "";
      sizeProduct.value = "";
      productSelect.value = false;
    }
    List values = store.read("sales");
    total.value = 0.0;
    for (var i = 0; i < values.length; i++) {
      var calcDiscount =  double.parse(values[i]["discount"].toString()) / 100;

      calcDiscount = (double.parse(values[i]["saleValue"].toString()) * values[i]["qts"]) * calcDiscount;
      calcDiscount = (double.parse(values[i]["saleValue"].toString()) * values[i]["qts"]) - calcDiscount ;
      if (i == 0) {
        subTotal.value = calcDiscount;
      }
      total.value = total.value + calcDiscount;
    }
  }

  void searchProduct() async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );
    if (code.text.isEmpty || qts.text.isEmpty) {
      await EasyLoading.dismiss();
      return;
    }
    sale.product = Product(code: code.text,qts: int.parse(qts.text));
    sale.client = client.text.toString();
    var response = await sale.getSaleProduct(sale);
    if (response["result"].length != 0) {
      store.remove("sales");
      store.write("sales", response["result"]);
      allProductSales.clear();
      allProductSales.addAll(response["result"]);
      store.write("client", client.text);
      calcSaleNow();
    }else{
      dialogSearch(response["error"]);
    }
    await EasyLoading.dismiss();
  }

  void dialogSearch(response){
    Get.defaultDialog(
      radius: 5,
      title: "Alerta",
      middleText: response,
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.grey.withOpacity(0.5),
          minimumSize: const Size(10, 40),
        ),
        child: const Text("Confirmar",style: TextStyle(fontSize: 16),),
      ),
    );
  }

  void addDiscountInProduct() async{
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );

    sale.product = Product(qts: updateQts.value);
    sale.discount = double.parse(discountGroup.text);
    if(idSales.isEmpty){
      await EasyLoading.dismiss();
      return;
    }

    var response = await sale.update(sale,idSales);
    if (response["result"].length != 0) {
      store.remove("sales");
      store.write("sales", response["result"]);
      allProductSales.clear();
      allProductSales.addAll(response["result"]);
      calcSaleNow();
    }else{
      dialogSearch(response["error"]);
    }
    await EasyLoading.dismiss();
  }
  
  void confirmSales() async{
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );
    var verified = await sale.saveSales(sale);
    if (verified == true) {
      store.remove("sales");
      allProductSales.clear();
      getAllSalesNow();
    }
    await EasyLoading.dismiss();
  }
  
  void discountAll() async{
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );

    sale.discount = double.parse(allDiscount.text);
    var response = await sale.discountAll(sale);
    if (response["result"].length != 0) {
      store.remove("sales");
      store.write("sales", response["result"]);
      allProductSales.clear();
      allProductSales.addAll(response["result"]);
      discount.value = double.parse(allDiscount.text);
      calcSaleNow();
    }
    await EasyLoading.dismiss();
  }
  
  void deleteProduct(index,String id) async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );

    var verified = await sale.deleteOne(id);
    if (verified == true) {
      allProductSales.removeAt(index);
      getAllSalesNow();
    }
    await EasyLoading.dismiss();
  }

  void removeAll() async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );

    var verified = await sale.deleteAll(sale);
    if (verified == true) {
      store.remove("sales");
      store.remove("client");
      client.text = "";
      allProductSales.clear();
      getAllSalesNow();
    }
    await EasyLoading.dismiss();
  }


}
