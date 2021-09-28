import 'package:lustore/app/Api/jwt.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lustore/app/repository/IApi_user.dart';

class ApiUser implements IApiUser{
  final store = GetStorage();
  static String url = "http://127.0.0.1:8000/api/";
  Jwt jwt = Jwt();


  Future<dynamic> loginAdmin() async {
    var token = jwt.senderCreatesJwt();
    var data = {"token": token};
    final response = await http.post(Uri.parse(url + "loginAdmin"),
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

  Future<dynamic> refreshJwt() async {
    var token = store.read("token");
    if (token == null) {
      var response = await loginAdmin();
      await store.write("token", response["token"]);
      token = response["token"];
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
      throw Exception("error na gercao do token");
    }
  }

  Future<dynamic> logout() async {
    String token = await refreshJwt();
    final response = await http.post(
      Uri.parse(url + "logout"),
      headers: <String, String>{'Authorization': 'Bearer ' + token},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }
}
