import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:lustore/app/boot/config.dart';
import 'package:lustore/app/model/auth.dart';
import 'dart:convert';
import 'package:lustore/app/repository/iapi_auth.dart';

class ApiAuth implements IApiAuth{


  final store = GetStorage();


  @override
  Future login(Auth data) async {
    final response = await http.post(Uri.parse(url + "login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      var _response = jsonDecode(response.body);
      store.write('name', _response['name']);
      store.write('id',_response['id']);
      store.write("token", _response['token']);
      if(int.parse(_response['level']) != 5){
        logout();
        return false;
      }
      return true;
    } else {
      return jsonDecode(response.body)["error"];
    }
  }

  @override
  Future forget(Auth data) async{
    final response = await http.post(Uri.parse(url + "forget"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  @override
  Future refreshJwt() async {
    var token = store.read("token");
    if (token == null) {
      return;
    }
    final expirationDate = JwtDecoder.getExpirationDate(token);
    if (!DateTime.now().isAfter(expirationDate)) {
      return token;
    }
    final response = await http.post(
      Uri.parse(url + "refresh"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Authorization': 'Bearer ' + token.toString()
      },
    );
    if (response.statusCode == 200) {
      var _token = jsonDecode(response.body)["result"];
      await store.write("token",_token);
      return _token;
    } else {
      Get.offNamed("/login");
      store.remove("remember");
      throw Exception( jsonDecode(response.body)["error"]);
    }
  }

  @override
  Future logout() async {
    String token = await refreshJwt();
    final response = await http.post(
      Uri.parse(url + "logout"),
      headers: <String, String>{'Authorization': 'Bearer ' + token},
    );
    if (response.statusCode == 200) {
      store.remove("token");
      Get.offNamed("/login");
      return;
    } else {
      return jsonDecode(response.body);
    }
  }
}