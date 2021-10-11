import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:lustore/app/Api/api_user.dart' ;
import 'package:lustore/model/product.dart';

class ApiProducts extends ApiUser{

  Future<dynamic> getOneProduct(String code) async{
    final response = await http.get(
      Uri.parse(ApiUser.url + "product/" + code),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> getAllProducts() async{
    final response = await http.get(
      Uri.parse(ApiUser.url + "products"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> getProductsByCategory(String id) async{
    final response = await http.get(
      Uri.parse(ApiUser.url + "products/categories/" + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("error ao buscar os produtos");
    }
  }

  Future<dynamic> upload(String fileName) async{
    String token = await refreshJwt();
    final request = http.MultipartRequest('POST',Uri.parse(ApiUser.url + "upload"));
      request.headers.addAll({'Authorization': 'Bearer ' + token});
      request.files.add(
      http.MultipartFile(
          "image",
          File(fileName).readAsBytes().asStream(),
          File(fileName).lengthSync(),
          filename: fileName.split("/").last
      )
    );
    var response = await request.send();
    if (response.statusCode == 200) {
      return response.stream.transform(utf8.decoder).join();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<dynamic> getImage(String id) async{
    final response = await http.get(
        Uri.parse(ApiUser.url + "products/categories/" + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> create(Product data) async{
    String token = await refreshJwt();
    final response = await http.post(
      Uri.parse(ApiUser.url + "product/add"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return jsonDecode(jsonEncode(response.body));
    }
  }

  Future<dynamic> update(Product data) async{
    String token = await refreshJwt();
    final response = await http.put(
      Uri.parse(ApiUser.url + "product/update/" + data.code.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
      body: jsonEncode(data),
    );
     if (response.statusCode == 200) {
      return true;
    } else {
      return jsonDecode(jsonEncode(response.body));
    }
  }

  Future<dynamic> delete(String id) async{
    String token = await refreshJwt();
    final response = await http.delete(
      Uri.parse(ApiUser.url + "product/delete/" + id),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return jsonDecode(response.body);
    }
  }




  Future<dynamic> postCost(Map data) async {
    String token = await refreshJwt();
    final response = await http.post(
        Uri.parse(ApiUser.url + "monthCost/add"),
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

