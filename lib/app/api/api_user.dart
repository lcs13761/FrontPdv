import 'package:lustore/app/Api/jwt.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'package:lustore/app/repository/IApi_user.dart';
import 'package:lustore/model/user.dart';

class ApiUser implements IApiUser{
  final store = GetStorage();
  static String url = "";
  Jwt jwt = Jwt();


  @override
  Future login(User data) async {
    final response = await http.post(Uri.parse(url + "login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
     var level = jsonDecode(response.body)["level"];
     var _token = jsonDecode(response.body)["token"];
     store.write("token", _token);
     if(int.parse(level) != 5){
       logout();
       return false;
     }
      return true;
    } else {
      return jsonDecode(response.body);
    }
  }

  @override
  Future forget(User data) async{
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
      var newTokenResponse = jsonDecode(jsonEncode(response.body));
      if(newTokenResponse.toString().contains('"')){
        await store.write("token", newTokenResponse.toString().replaceAll('"', ""));
        return newTokenResponse.toString().replaceAll('"', "");
      }else{
        await store.write("token", newTokenResponse);
        return newTokenResponse;
      }
    } else {
      Get.offNamed("/login");
      throw Exception("error na gercao do token");

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
