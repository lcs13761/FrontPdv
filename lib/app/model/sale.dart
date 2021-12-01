import 'package:lustore/app/api/model.dart';
import 'package:lustore/app/model/product.dart';

class Sale extends Model{

  String? client;
  double discount = 0.0;
  int? qts;
  String? salesman;
  Product product = Product();

  Sale(){
    actionApi('sale');
  }

  Sale.fromJson(Map<String,dynamic> json):
        client = json["client"],
        salesman = json['salesman'],
        qts = json['qts'],
        product = json["product"],
        discount = json["discount"];


  Map<String,dynamic> toJson(){
    return {
      "client" : client,
      'salesman' : salesman,
      'qts' : qts,
      "product" : product,
      "discount" : discount,
    };
  }
}