import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lustore/app/model/auth.dart';

class LoginForgetPasswordController extends GetxController {
  TextEditingController email = TextEditingController();
  Auth auth = Auth();

  Future forget()async{


    auth.email = email.text;
    return await auth.forget(auth);


  }
}
