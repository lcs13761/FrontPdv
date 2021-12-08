import 'dart:async';
import 'dart:convert';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lustore/app/model/product.dart';
import 'package:lustore/app/model/sale.dart';
import 'package:lustore/app/theme/style.dart';

class HomeController extends GetxController {
  TextEditingController product = TextEditingController();
  TextEditingController client = TextEditingController();
  TextEditingController qts = TextEditingController();
  TextEditingController valueDiscount = TextEditingController();
  NumberFormat formatter = NumberFormat.simpleCurrency();
  Product products = Product();
  Sale sale = Sale();
  MoneyMaskedTextController discount = MoneyMaskedTextController(
    initialValue: 0,
    decimalSeparator: "",
    thousandSeparator: "",
    precision: 1,
  );
  int? productId;
  final store = GetStorage();
  RxList allProductSales = [].obs;
  RxList resultSearchProductSaleExchangeAndReturn = [].obs;
  RxDouble subTotal = 0.0.obs;
  RxDouble total = 0.0.obs;
  String idSales = "";
  RxBool productSelect = false.obs;
  RxDouble saleValuesFinal = 0.0.obs;
  RxDouble valueProduct = 0.0.obs;
  RxString image = "".obs;
  RxMap infoProduct = {}.obs;
  RxMap productSelectExchange = {}.obs;
  RxInt updateQts = 1.obs;

  @override
  void onInit() async {
    super.onInit();
    qts.text = "1";
    await getSales();
    await saveProducts();
    Timer.periodic(
        const Duration(minutes: 5), (Timer t) async => await saveProducts());
  }

  @override
  void onClose() async {
    super.onClose();
    closeSale();
  }

  saveProducts() async {
    Map _response = await products.index(search: "all=true");
    store.write('product', _response['data']);
  }

  Future productCreateSale() async {
    sale.client = client.text;
    sale.salesman = store.read('email') ?? 'system';
    sale.qts = int.parse(qts.text) < 1 ? 1 : int.parse(qts.text);
    sale.product = Product(id: productId);
    return await sale.store(sale);
  }

  Future getSales() async {
    Map _product = await sale.index();
    allProductSales.clear();
    allProductSales.addAll(_product["data"]);
    listSale(_product["data"]);
  }

  closeSale() async {
    if (store.read("sales") != null) {
      var verified = await sale.destroy(sale);
      if (verified == true) {
        store.remove("sales");
        store.remove("client");
      } else {
        throw Exception("error ao excluir os dados");
      }
    }
  }

  void getAllSalesNow() async {
    await store.remove("sales");
    store.write("sales", allProductSales);
    discountProductView(allProductSales);
  }

  valueDiscountAll(String value, String valueCost, {calc}) {
    var calcDiscount = double.parse(value) / 100;
    calcDiscount = (double.parse(valueCost)) * calcDiscount;
    if (calc == true) {
      return (double.parse(valueCost) - calcDiscount);
    }
    saleValuesFinal.value = (double.parse(valueCost) - calcDiscount);
  }

  void listSale(_product) {
    int _qts = 0;
    var i = 0;
    double _value = 0.0;
    for (var index in _product) {
      var calcDiscount = discountProductView(index);
      _value = _value + calcDiscount;
      _qts = _qts + index["qts"] as int;
      if (i == 0) {
        subTotal.value = calcDiscount;
      }
      i++;
    }
    total.value = _value;
  }

  discountProductView(_product) {
    var value = _product["saleValue"] * _product["qts"];
    var calcDiscount = _product['discount'] / 100;
    calcDiscount = value * calcDiscount;
    return (value - calcDiscount);
  }

  Future<List<Product>> searchProduct(String _suggest) async {
    List listProduct = store.read('product');
    return listProduct.map((json) => Product.fromJson(json)).where((_product) {
      final query = _suggest.toLowerCase();
      return _product.product!.toLowerCase().contains(query);
    }).toList();
  }

  void dialogSearch(response) {
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
        child: const Text(
          "Confirmar",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future addDiscountInProduct() async {
    allProductSales.forEach((element) async {
      int index = 0;
      qts.text = element['qts'].toString();
      await actionProductSale(element,index);
      index++;
    });
    discount.text = '';
  }

  Future updateSale(element,index) async{
      return await actionProductSale(element,index);
  }

  Future actionProductSale(element,index) async {
    sale.discount = double.parse(discount.text);
    sale.salesman = store.read('email') ?? 'system';
    sale.qts = updateQts.value < 1 ? 1 : updateQts.value;
    sale.product = Product(id: element["id"]);
    var _response =  await sale.update(sale, element["id"]);
    if (_response == true) {
      var _update = element;
      _update["qts"] = updateQts.value;
      _update['discount'] = sale.discount;
      allProductSales[index] = _update;
    }
    return;
  }

  Future destroy(_product) async{
    var _response = await sale.destroy(_product['id']);
    if(_response == true){
      allProductSales.remove(_product);
      listSale(allProductSales);
    }
  }

  void confirmSales() async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );
    sale.client = client.text;
    var verified = await sale.store(sale);
    if (verified == true) {
      store.remove("sales");
      allProductSales.clear();
      getAllSalesNow();
    }
    await EasyLoading.dismiss();
  }

  void discountAll() async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );

    sale.discount = double.parse(discount.text);
    var response = await sale.update(sale, 1);
    if (response["result"].length != 0) {
      store.remove("sales");
      store.write("sales", response["result"]);
      allProductSales.clear();
      allProductSales.addAll(response["result"]);
      // discount.value = double.parse(discount.text);
      //calcSaleNow();
    }
    await EasyLoading.dismiss();
  }

  void deleteProduct(index, String id) async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );

    var verified = await sale.destroy(id);
    if (verified == true) {
      allProductSales.removeAt(index);
      getAllSalesNow();
    }
    await EasyLoading.dismiss();
  }

  Future removeAll() async {
    allProductSales.forEach((element) async {
      await loadingDesk();
      var _response = await sale.destroy(element["id"]);
      allProductSales.remove(element);
      if (allProductSales.isEmpty) {
        await dismiss();
      }
    });
      }

  distributeInformation(_info) {
    infoProduct.clear();
    infoProduct.addAll(_info);
    subTotal.value = valueDiscountAll(_info["discount"].toString(),
        (_info["saleValue"] * _info["qts"]).toString(),
        calc: true);
    // if(controller.allProductSales[index]["image"] != null){
    //   controller.image.value =
    //       controller.allProductSales[index]["image"].toString();
    // }
  }
}
// void exchangeAndReturn() async{
//     await EasyLoading.show(
//       maskType: EasyLoadingMaskType.custom,
//     );
//
//     var data = {
//       "codeSales" : codeSaleOrClient.text,
//     };
//
//     var response = await sale.getProductForExchangeAndReturn(data);
//
//     if(response["result"].length != 0){
//       resultSearchProductSaleExchangeAndReturn.clear();
//       resultSearchProductSaleExchangeAndReturn.addAll(response["result"]);
//     }
//     await EasyLoading.dismiss();
//   }
