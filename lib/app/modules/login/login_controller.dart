import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lustore/app/model/auth.dart';


class LoginController extends GetxController {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Auth auth = Auth();
  final store = GetStorage();
  RxBool rememberMe = false.obs;
  RxBool show = false.obs;

  login() async{
    auth.email = email.text;
    auth.password = password.text;

    var _response = await auth.login(auth);
    if(_response == true && rememberMe.isTrue){
      store.write('email', email.text);
      store.write("remember", true);
    }
    return _response;
  }

  validationEmail(value){
    if (value == null || value.isEmpty) {
      return "Preencha esse campo";
    }
    bool _emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!_emailValid) {
      return "Email inválido";
    }
    return null;
  }


}
