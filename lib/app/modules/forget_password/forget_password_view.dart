import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:get/get.dart';
import 'forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  ForgetPasswordView({Key? key}) : super(key: key);


  final _formKeyForget = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 80),
              alignment: Alignment.topCenter,
              child: Image.asset(
                "images/logo.png",
                width: 300,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  width: 350,
                  child: Form(
                    key: _formKeyForget,
                    child: Column(
                      children: <Widget>[
                        textFieldLogin("example@mail.com", Icons.email,
                            controller.email, TextInputType.emailAddress,
                            autocorrect: true,
                            enableSuggestions: true,
                            obscureText: false),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                    Get.offAllNamed("/login");
                              },
                              child: Text(
                                "Volta para Login?",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKeyForget.currentState!.validate()) {
                              loading(context);
                              var _response = await controller.forget();
                              if(_response["result"].length != 0){
                                await 1.delay();
                                success(context,_response["result"]);
                                return;
                              }
                              if(_response["error"].toString().isNotEmpty){
                                await 1.delay();
                                Get.back();
                                error(context,_response["error"]);
                                return;
                              }

                            }
                          },
                          child: buttonSubmit(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget buttonSubmit() {
    return Container(
      width: 350,
      height: 45,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 103, 254, 1),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        "Enviar por Email",
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 16,
        ),
      ),
    );
  }

  void loading(context) {
    CoolAlert.show(
        context: context,
        width: 400,
        type: CoolAlertType.loading,
        text: 'Carregando....',
        animType: CoolAlertAnimType.scale,
        barrierDismissible: false);
  }

  void error(context,String text) {
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

  void success(context,String text) {
    CoolAlert.show(
        context: context,
        width: 400,
        type: CoolAlertType.success,
        text: text,
        title: "Sucesso!!",
        animType: CoolAlertAnimType.scale,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        barrierDismissible: false,
        onConfirmBtnTap: (){
          Get.offAllNamed("/login");
        }
    );

  }

  Widget textFieldLogin(String text, IconData icon, controller, type,
      {obscureText, enableSuggestions, autocorrect}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Preencha esse campo";
          }
          return null;
        },
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        autocorrect: autocorrect,
        keyboardType: type,
        controller: controller,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
        ),
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(254, 0, 0, 0.6),
              )),
          focusedErrorBorder: borderColorFocus,
          focusedBorder: borderColorFocus,
          enabledBorder: borderColor,
          hintText: text,
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }

  final borderColorFocus = const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(0, 103, 254, 1),
      ));

  final borderColor = const OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.9)));
}