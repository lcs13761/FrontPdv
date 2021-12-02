import 'package:lustore/app/api/model.dart';
import 'package:lustore/app/model/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product extends Model{
    int? id;
    String? code;
    String? product;
    double? saleValue;
    double? costValue;
    String? description;
    String? size;
    int? qts;
    Category? category;
    List? image;

    Product({this.id,this.code, this.product, this.costValue,
      this.saleValue, this.description,
      this.size, this.category,
      this.image,this.qts}){
      actionApi('product');
    }

    Product.fromJson(Map<String,dynamic> json):
        id = json["id"],
        code = json["code"],
        product = json["product"],
        saleValue = json["saleValue"],
        costValue = json["costValue"],
        description = json["description"],
        size = json["size"],
        qts = json["qts"],
        image = json["image"],
        category = json["category"];

    Map<String,dynamic> toJson(){
      return {
        "id" : id,
        "code" : code,
        "product" : product,
        "saleValue" : saleValue,
        "costValue" : costValue,
        "description" : description,
        "size" : size,
        "qts" : qts,
        "image" : image,
        "category" : category
      };
    }


    Future nextProduct(_page) async{
      String token = await auth.refreshJwt();
      final response = await http.get(
        Uri.parse(_page),
        headers: <String, String>{
          'Accept' : 'application/json',
          'Authorization': 'Bearer ' + token
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return false;
      }
    }

}