import 'package:lustore/app/api/api_auth.dart';

class Auth extends ApiAuth{
  String? email;
  String? password;


  Auth();

  Auth.fromJson(Map<String,dynamic> json):
        email = json["email"],
        password = json["password"];


  Map<String,dynamic> toJson(){
    return {
      "email" : email,
      "password" : password,
    };
  }
}