import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lustore/app/model/product.dart';
import 'package:lustore/app/model/sale.dart';



class HomeController extends GetxController {
  TextEditingController codeSaleOrClient = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController client = TextEditingController();
  TextEditingController qts = TextEditingController();
  TextEditingController valueDiscount = TextEditingController();
  NumberFormat formatter = NumberFormat.simpleCurrency();
  Sale sale = Sale();
  MoneyMaskedTextController discount = MoneyMaskedTextController(
    initialValue: 0,
    decimalSeparator: "",
    thousandSeparator: "",
    precision: 1,
  );
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
  RxString nameProduct = "".obs;
  RxString codeProduct = "".obs;
  RxString sizeProduct = "".obs;
  RxMap productSelectExchange = {}.obs;
  RxInt updateQts = 1.obs;



  @override
  void onInit() async{
    super.onInit();
    await getSales();
    qts.text = "1";
  }

  @override
  void onClose() async{
    super.onClose();
    closeSale();

  }

  Future getSales() async{

    Map _product = await sale.index();

    allProductSales.clear();
    allProductSales.addAll(_product["data"]);
    //listSale(_product["data"]);
  }

  closeSale() async{
    if(store.read("sales") != null){
      var verified = await sale.destroy(sale);
      if (verified == true) {
        store.remove("sales");
        store.remove("client");
      }else{
        throw Exception("error ao excluir os dados");
      }
    }
  }

  void getAllSalesNow() async {
    await store.remove("sales");
    store.write("sales", allProductSales);
    discountProductView(allProductSales);
  }
  valueDiscountAll(String value, String valueCost, {calc}){
    var calcDiscount = double.parse(value) / 100;
    calcDiscount = (double.parse(valueCost)) * calcDiscount;
    if(calc == true){
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
      _value =
          _value + calcDiscount;
      _qts = _qts + index["qts"] as int ;
      if (i == 0) {
        subTotal.value = calcDiscount;
      }
      i++;
    }
    total.value = _value;
  }

  discountProductView(_product){

    var value = _product["saleValue"] * _product["qts"];
    var calcDiscount = _product['discount'] / 100;
    calcDiscount = value * calcDiscount;
    return (value - calcDiscount);
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
    var response = await sale.store(sale);

    // if (response["result"].length != 0) {
    //   store.remove("sales");
    //   store.write("sales", response["result"]);
    //   allProductSales.clear();
    //   allProductSales.addAll(response["result"]);
    //   store.write("client", client.text);
    //   calcSaleNow();
    // }else{
    //   dialogSearch(response["error"]);
    // }
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
    sale.discount = double.parse(discount.text);
    if(idSales.isEmpty){
      await EasyLoading.dismiss();
      return;
    }
    var response = await sale.update(sale,idSales);
    if (response["result"].toString().isNotEmpty) {
      store.remove("sales");
      store.write("sales", response["result"]);
      allProductSales.clear();
      allProductSales.addAll(response["result"]);
     // calcSaleNow();
    }else{
      dialogSearch(response["error"]);
    }
    await EasyLoading.dismiss();
  }

  void confirmSales() async{

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

  void discountAll() async{
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );

    sale.discount = double.parse(discount.text);
    var response = await sale.update(sale,1);
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

  void deleteProduct(index,String id) async {
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

  void removeAll() async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );

    var verified = await sale.destroy(sale);
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