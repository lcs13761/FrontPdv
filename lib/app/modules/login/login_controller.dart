import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lustore/model/user.dart';

class LoginController extends GetxController {


  User user = User();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool show = false.obs;

  login() async{
    user.email = email.text;
    user.password = password.text;

    var response = await user.login(user);
    return response;
  }


}
