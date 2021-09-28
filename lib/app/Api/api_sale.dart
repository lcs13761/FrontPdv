import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:lustore/app/Api/api_user.dart';
import 'package:lustore/model/sale.dart';

abstract class ApiSales extends ApiUser {


  Future<dynamic> getSales(String token) async {
    final response = await http.get(
      Uri.parse(ApiUser.url + "sales"),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }
  Future<dynamic> getSalesFinalised() async {
    String token = await refreshJwt();
    final response = await http.get(
      Uri.parse(ApiUser.url + "allSalesYear"),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }
  Future<dynamic> getHistoric() async {
    String token = await refreshJwt();
    final response = await http.get(
      Uri.parse(ApiUser.url + "allSalesFinalised"),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> getSaleProduct(Sale data) async {
    String token = await refreshJwt();
    final response = await http.post(
      Uri.parse(ApiUser.url + "sale"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> update(Sale data, String id) async{
    String token = await refreshJwt();
    final response = await http.put(
      Uri.parse(ApiUser.url + "sale/update/" + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> discountAll(Sale data) async{
    String token = await refreshJwt();
    final response = await http.put(
      Uri.parse(ApiUser.url + "sale/discountAll"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(jsonEncode(response.body));
    }
  }

  Future<dynamic> deleteOne(String id) async {
    String token = await refreshJwt();
    final response = await http.delete(
      Uri.parse(ApiUser.url + "sale/delete/" + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> deleteAll(Sale data) async {
    String token = await refreshJwt();
    final response = await http.delete(
      Uri.parse(ApiUser.url + "sale/deleteAll"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
        body: jsonEncode(data)
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return jsonDecode(response.body);
    }
  }
  Future<dynamic> saveSales(Sale data) async {
    String token = await refreshJwt();
    final response = await http.post(
        Uri.parse(ApiUser.url + "sale/finalizeSale"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        },
        body: jsonEncode(data)
    );

    if (response.statusCode == 200) {
      return  true;
    } else {
      return jsonDecode(response.body);
    }
  }
}
