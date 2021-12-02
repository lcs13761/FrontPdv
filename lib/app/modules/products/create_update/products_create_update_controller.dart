import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lustore/app/api/api_upload.dart';
import 'package:lustore/app/model/category.dart';
import 'package:lustore/app/model/product.dart';

class ProductsCreateUpdateController extends GetxController {

  TextEditingController cod = TextEditingController();
  TextEditingController productName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController size = TextEditingController();
  MoneyMaskedTextController cost = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', precision: 2,leftSymbol: 'R\$ ');
  MoneyMaskedTextController value = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', precision: 2,leftSymbol: 'R\$ ');
  TextEditingController qts = TextEditingController();
  Category category = Category();
  Product product = Product();
  ApiUpload upload = ApiUpload();
  RxList fileImage = [].obs;
  RxList categoryList = [].obs;
  int id = 0;
  RxString stringCategory = "1".obs;
  RxString typeAction = "create".obs;
  RxBool onLoadingFinalized = false.obs;
  RxMap errors = {}.obs;


  @override
  void onInit() async {
    super.onInit();
    if(Get.arguments != null){
      typeAction.value = "update";
      updateType(Get.arguments);
    }
    await getAllCategories();
    onLoadingFinalized.value = true;
  }

  getAllCategories() async {
    var _categories = await category.index();
    categoryList.addAll(_categories["data"]);
  }

  updateType(_product){
    var valueSale = _product["saleValue"].toString().contains(".")
        ? _product["saleValue"]
        : double.parse(_product["saleValue"].toString());

    var costValue =  _product["costValue"].toString().contains(".")
        ? Get.arguments["costValue"]
        : double.parse(_product["costValue"].toString());

    if(_product["image"].isNotEmpty){
      fileImage.addAll(_product["image"]);
    }
    id = _product["id"];
    stringCategory.value = _product["category"]["id"].toString();
    cod.text = _product["code"].toString();
    productName.text = _product["product"].toString();
    description.text = _product["description"].toString();
    cost.updateValue(costValue);
    value.updateValue(valueSale);
    qts.text = _product["qts"].toString();
    size.text = _product["size"].toString();

  }

}
