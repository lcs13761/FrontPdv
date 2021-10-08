import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lustore/app/Api/jwt.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:flutter_masked_text/flutter_masked_text.dart";
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lustore/model/category.dart';
import 'package:lustore/model/product.dart';
import 'package:lustore/model/user.dart';


class AddProductController extends GetxController {
  final ImagePicker image = ImagePicker();
  final TextEditingController cod = TextEditingController();
  final TextEditingController nameProduct = TextEditingController();
  final TextEditingController qts = TextEditingController();
  final store = GetStorage();
  MoneyMaskedTextController saleValue = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', precision: 2);
  RxString description = "".obs;
  RxString sizeProduct = "P".obs;
  RxString file = "".obs;
  RxString imageProduct = "".obs;
  RxString idCategory = "1".obs;
  RxBool updatePrt = false.obs;
  RxBool fileUpload = false.obs;
  RxList listCategories = [].obs;
  Category category = Category();
  Product product = Product();
  User user = User();
  Jwt jwt = Jwt();


  dynamic pickImageError;

  @override
  void onInit() async {
    super.onInit();

   await getCategories();

   if (Get.arguments != null) {
     var valueSale = Get.arguments["saleValue"].toString().contains(".")
         ? Get.arguments["saleValue"]
         : double.parse(Get.arguments["saleValue"].toString());

      cod.text = Get.arguments["code"];
      nameProduct.text = Get.arguments["product"];
      qts.text = Get.arguments["qts"].toString();
      saleValue.updateValue(valueSale);
      description.value = Get.arguments["description"].toString();
      sizeProduct.value = Get.arguments["size"].toString();
      idCategory.value =  Get.arguments["id_category"].toString();
      updatePrt.value = true;
      if(Get.arguments["image"].toString().isNotEmpty){
        imageProduct.value =  Get.arguments["image"];
        fileUpload.value = true;
      }
    }
    if (store.read("token") == null) {
      var response = await user.loginAdmin();
      store.write("token", response["token"]);
    }
  }
  getCategories() async {
    var getAll = await category.getAllCategories();
    if (getAll["result"].toString().isEmpty) {
      return;
    }
    listCategories.addAll(getAll["result"]);
  }

  void createProduct() async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );

    var image = file.value;
    if(file.isNotEmpty){
      image = await product.upload(file.value);
      image = image.replaceAll("\\", "").split(",")[1].split('"')[3];
    }
    await EasyLoading.dismiss();
    product.code = cod.text;
    product.product = nameProduct.text;
    product.qts = int.parse(qts.text);
    product.saleValue = saleValue.text.contains(".")
        ? double.parse(saleValue.text.replaceAll(".", "").replaceAll(",", '.'))
        : double.parse(saleValue.text.replaceAll(",", "."));
    product.size = sizeProduct.toString();
    product.category = Category(id: int.parse(idCategory.toString()));
    product.image = image;

    var response = await product.create(product);

    await 1.delay();
    await EasyLoading.dismiss();
    if (response == true) {
      messageDialog("Produto criado com sucesso\nDeseja continua?");
    }
  }

  void updateProduct() async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
    );

    var image = file.value;
    if(file.isNotEmpty){
      image = await product.upload(file.value);
      image = image.replaceAll("\\", "").split(",")[1].split('"')[3];
    }else{
      image = imageProduct.value;
    }
    await EasyLoading.dismiss();
    product.code = cod.text;
    product.product = nameProduct.text;
    product.qts = int.parse(qts.text);
    product.saleValue = saleValue.text.contains(".")
        ? double.parse(saleValue.text.replaceAll(".", "").replaceAll(",", '.'))
        : double.parse(saleValue.text.replaceAll(",", "."));
    product.size = sizeProduct.toString();
    product.category = Category(id: int.parse(idCategory.toString()));
    product.image = image;
    var response = await product.update(product);
    await 1.delay();
    await EasyLoading.dismiss();
    if (response == true) {
      messageDialog("Produto editado com sucesso\nDeseja continua?");
    }
  }

  void messageDialog(String text) {
    Get.dialog(
      AlertDialog(
        content: SingleChildScrollView(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(60, 45),
              ),
              onPressed: () {
                cod.text = "";
                nameProduct.text = "";
                qts.text = "";
                saleValue.text = "0.0";
                sizeProduct.value = "";
                idCategory.value = "1";
                Get.offAllNamed("/categories");
              },
              child: const Text(
                "OK",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
