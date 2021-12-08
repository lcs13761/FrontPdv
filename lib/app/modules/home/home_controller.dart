import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lustore/app/model/historic.dart';
import 'package:lustore/app/model/product.dart';
import 'package:lustore/app/model/sale.dart';
import 'package:lustore/app/theme/style.dart';

class HomeController extends GetxController {
  TextEditingController product = TextEditingController();
  TextEditingController client = TextEditingController();
  TextEditingController qts = TextEditingController();
  TextEditingController valueDiscount = TextEditingController();
  TextEditingController discount = TextEditingController();
  NumberFormat formatter = NumberFormat.simpleCurrency();
  Product products = Product();
  Historic historic = Historic();
  Sale sale = Sale();
  int? productId;
  final store = GetStorage();
  RxBool inLoading = true.obs;
  RxList allProductSales = [].obs;
  RxDouble subTotal = 0.0.obs;
  RxDouble total = 0.0.obs;
  RxDouble saleValuesFinal = 0.0.obs;
  RxString image = "".obs;
  RxMap infoProduct = {}.obs;
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

  // @override
  // void onClose() async {
  //   super.onClose();
  //   closeSale();
  // }

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
    inLoading.value = false;
    listSale(_product["data"]);
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
      client.text = index['client'];
      var calcDiscount = discountProductView(index);
      _value = _value + calcDiscount;
      _qts = _qts + index["qts"] as int;
      if (i == 0) {
        subTotal.value = calcDiscount;
        discount.text = index['discount'].round().toString();
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
    loadingDesk();
    for(var i = 0; i < allProductSales.length; i++){
      sale.qts =  allProductSales[i]['qts'];
      await actionProductSale(allProductSales[i],i);
    }
    dismiss();
    discount.text = '';
  }

  Future updateSale(element,index) async{
    sale.qts = updateQts.value < 1 ? 1 : updateQts.value;
    return await actionProductSale(element,index);
  }

  Future actionProductSale(element,index) async {
    sale.discount = double.parse(discount.text);
    sale.salesman = store.read('email') ?? 'system';
    sale.product = Product(id: element["id"]);
    var _response =  await sale.update(sale, element["id"]);
    if (_response == true) {
      var _update = element;
      _update["qts"] =  sale.qts;
      _update['discount'] = sale.discount;
      allProductSales[index] = _update;
    }
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

  Future destroy(_product) async{
    var _response = await sale.destroy(_product['id']);
    if(_response == true){
      allProductSales.remove(_product);
      listSale(allProductSales);
    }
  }

  Future finishSale() async {
    sale.client = client.text;
    return await historic.store(sale);
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
