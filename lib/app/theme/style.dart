import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



const whiteConstColor = Color.fromRGBO(255, 255, 255, 0.8);
const grayColor =  Color.fromRGBO(204, 204, 204, 0.8);
const styleColorBlue = Color.fromRGBO(0, 103, 254, 1);
final colorStyleInput =  TextStyle(
  color: Colors.white.withOpacity(0.8),
);


final showPassword =
Icon(Icons.remove_red_eye_sharp, color: Colors.white.withOpacity(0.9));

final hiddenPassword =
Icon(Icons.visibility_off, color: Colors.white.withOpacity(0.9));

const borderColorFocus = OutlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromRGBO(0, 103, 254, 1),
    ));

const borderColor = OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.9)));


const errorBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromRGBO(254, 0, 0, 0.6),
    ));

void loading(context) {
  CoolAlert.show(
      context: context,
      width: 400,
      type: CoolAlertType.loading,
      text: 'Carregando....',
      animType: CoolAlertAnimType.scale,
      barrierDismissible: false);
}

void error(context, String text) {
  CoolAlert.show(
      context: context,
      width: 400,
      loopAnimation: false,
      type: CoolAlertType.error,
      text: text,
      title: "Error!",
      animType: CoolAlertAnimType.scale,
      backgroundColor: const Color(0xCD000000),
      barrierDismissible: false);
}

void success(String text,context,{action}) {
  CoolAlert.show(
      onConfirmBtnTap: () {
        if (action == "back") {
          Get.back();
          Get.back();
        }else{
          Get.back();
        }
      },
      context: context,
      text: text,
      width: 400,
      type: CoolAlertType.success,
      animType: CoolAlertAnimType.scale,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      barrierDismissible: false);
}
