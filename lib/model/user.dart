import 'package:lustore/app/Api/api_user.dart';

class User extends ApiUser{
  String? email;
  String? password;


  User();

  User.fromJson(Map<String,dynamic> json):
        email = json["email"],
        password = json["password"];


  Map<String,dynamic> toJson(){
    return {
      "email" : email,
      "password" : password,
    };
  }

}