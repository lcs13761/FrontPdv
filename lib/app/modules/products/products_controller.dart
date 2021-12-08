import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:lustore/app/model/product.dart';
import 'package:lustore/app/model/user.dart';


class ProductsController extends GetxController {
  Product product = Product();
  TextEditingController searchProduct = TextEditingController();
  NumberFormat formatter = NumberFormat.simpleCurrency();
  RxBool inLoading = true.obs;
  User user = User();
  PagingController  allProducts = PagingController(firstPageKey: 0);
  RxList copyAllProducts = [].obs;
  RxBool isNotEmpty = false.obs;
  RxBool resultSearch = false.obs;
  String? nextPageProduct = '';
  int total = 0;


  @override
  void onInit() async {
    super.onInit();
    await getProducts();
  }

  Future getProducts() async {
    inLoading.value = true;

    allProducts.addPageRequestListener((pageKey) {
      unawaited(productPagination(pageKey: pageKey));
    });
    inLoading.value = false;
  }

  Future productPagination({pageKey}) async {
    try {
      if (nextPageProduct != null) {
        Map _response;
        if (nextPageProduct!.isEmpty) {
          _response = await product.index(search: "product=" + searchProduct.text);
          nextPageProduct = _response.containsKey('links') ? _response['links']['next'] : null;
          total = _response.containsKey('met') ? _response['meta']['total'] : _response['data'].length;
        } else {
          _response = await product.nextProduct(nextPageProduct);
          nextPageProduct = _response['links']['next'];
        }
        bool isLastPage = false;
        if (allProducts.itemList == null) {
          isLastPage = _response['data'].length == total;
        } else {
          isLastPage = allProducts.itemList!.length == total;
        }
        if (isLastPage) {
          allProducts.appendLastPage(_response['data']);
        } else {
          final nextPageKey = pageKey ?? 1 + _response['data'].length;
          allProducts.appendPage(_response['data'], nextPageKey);
        }
      }
    } catch (error) {
      allProducts.error(error);
    }
  }

  Future deleteProduct(_id) async {
    return await product.destroy(_id.toString());
  }

  void searchDd(String text) {
    // if (copyAllProducts.isEmpty) {
    //   copyAllProducts.addAll(allProducts);
    // }
    // if (searchProduct.text.isEmpty) {
    //   allProducts.clear();
    //   allProducts.addAll(copyAllProducts);
    //   return;
    // }
    // allProducts.clear();
    // List result = copyAllProducts.value
    //     .where((element) => element["code"].toString().contains(text) || element["product"].toString().contains(text))
    //     .toList();
    // allProducts.addAll(result);
  }


}
