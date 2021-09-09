import 'package:lustore/app/Api/api_products.dart';
import 'package:lustore/model/category.dart';

class Product extends ApiProducts{

  String? code;
  String? product;
  double? saleValue;
  String? description;
  String? size;
  Category? category = Category();
  int? qts;
  String? image;

  Product({this.code,this.product,this.saleValue,this.category,this.size,this.qts});

  Product.fromJson(Map<String,dynamic> json):
        code = json["code"],
        product = json["product"],
        saleValue = json["saleValue"],
        description = json["description"],
        size = json["size"],
        category = json["category"],
        qts = json["qts"],
        image = json["image"];

  Map<String,dynamic> toJson(){
    return {
      "code" : code,
      "product" : product,
      "saleValue" : saleValue,
      "description" : description,
      "category" : category,
      "size" : size,
      "qts" : qts,
      "image" : image
    };
  }

}