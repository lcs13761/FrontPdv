import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lustore/model/user.dart';

class ForgetPasswordController extends GetxController {
  User user = User();
  TextEditingController email = TextEditingController();



    Future<dynamic>forget() async{

      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.text);
    if(!emailValid){
      return "adf";
    }
      user.email = email.text;
      var response = await user.forget(user);
      return response;

    }

}
