import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lustore/app/model/category.dart';
import 'package:lustore/app/theme/style.dart';


class CategoriesController extends GetxController {

  TextEditingController nameCategory = TextEditingController();
  Category category = Category();
  RxList categories = [].obs;
  RxBool inLoading = true.obs;
  String typeAction = "create";

  @override
  void onInit() async {
    super.onInit();
    await getAllCategories();
  }


  getAllCategories() async {
    var _categories = await category.index();
    categories.addAll(_categories["data"]);
    inLoading.value = false;
  }

  Future categoryActionSubmit({id}) async{
    category.category = nameCategory.text;
    if(typeAction == 'create') return await category.store(category);
    if(typeAction == 'update') return await category.update(category, id.toString());
  }

  void createResponse(){
    inLoading.value = true;
    categories.clear();
    getAllCategories();
  }

  void updateResponse(_category,context,index){
    _category['category'] = nameCategory.text;
    var _update = _category;
    categories[index] = _update;
    success('Categoria modificada com sucessor',context);
  }

  Future destroy(String id) async{
      return await category.destroy(id);
  }
}
