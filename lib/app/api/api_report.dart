import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:lustore/app/boot/config.dart';
import 'package:lustore/app/api/api_auth.dart';

class ApiReport  {

  ApiAuth user = ApiAuth();

  Future<dynamic> getReportsSales() async {
    String token = await user.refreshJwt();
    final response = await http.get(
      Uri.parse(url + "report/sale"),
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

  Future<dynamic> getCategoriesAndProductsBestSelling() async {
    String token = await user.refreshJwt();
    final response = await http.get(
      Uri.parse(url +  "report/product/category"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> annualProfit() async {
    String token = await user.refreshJwt();
    final response = await http.get(
      Uri.parse(url + "report/sale/annual"),
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
}