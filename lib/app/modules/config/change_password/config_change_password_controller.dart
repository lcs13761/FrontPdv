import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lustore/app/model/address.dart';
import 'package:lustore/app/model/user.dart';

class ConfigChangePasswordController extends GetxController {
  TextEditingController currentPassword = TextEditingController();
  TextEditingController passwordConfirmation = TextEditingController();
  TextEditingController password = TextEditingController();
  final store = GetStorage();
  User user = User();
  Address address = Address();
  RxMap visiblePassword = {}.obs;
  RxMap errors = {}.obs;

  Future change() async{
    var _id = store.read('id');
    List _user = Get.arguments;
    List _result = _user.where((element) =>
    element["id"].toString().contains(_id.toString()))
        .toList();
    User _userChange = await updateUser(_result[0]);
    user.current_password = currentPassword.text;
    user.password = password.text;
    user.password_confirmation = passwordConfirmation.text;
    return await user.update(_userChange, _id.toString());
  }


  Future<User> updateUser(_user) async{

    user.name = _user['name'];
    user.email = _user['email'];
    user.phone = _user['phone'];

    if(_user['address'].isNotEmpty){
      address.id =  _user['address'][0]['id'];
      address.cep = _user['address'][0]['cep'];
      address.city = _user['address'][0]['city'];
      address.state = _user['address'][0]['state'];
      address.district =_user['address'][0]['district'];
      address.street = _user['address'][0]['street'];
      address.number =_user['address'][0]['number'];
      address.complement =_user['address'][0]['complement'];
      user.address = address;
    }else{
      user.address = null;
    }

    return user;

  }

}
