import 'package:lustore/app/Api/api_user.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ApiHistoricSales extends ApiUser{


  Future<dynamic> getAllhistoric() async {
    String token = await refreshJwt();
    final response = await http.get(
      Uri.parse(ApiUser.url + "historicSalesAll"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
    );
    if (response.statusCode == 200) {
      return  true;
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> getSalesYear() async {
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
}