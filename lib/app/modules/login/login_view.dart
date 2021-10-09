import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 50),
              alignment: Alignment.topCenter,
              child: Image.asset(
                "images/logo.png",
                width: 300,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  width: 300,
                  child: Column(
                    children: <Widget>[
                      textFieldLogin("example@mail.com", Icons.email,
                          controller.email, TextInputType.emailAddress,
                          autocorrect: true,
                          enableSuggestions: true,
                          obscureText: false),
                      textFieldLogin("Senha", Icons.password,
                          controller.password, TextInputType.visiblePassword,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false),
                      InkWell(
                        onTap: () {

                        },
                        child: Container(
                          width: 300,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 103, 254, 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "ENTRAR",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget textFieldLogin(String text, IconData icon, controller, type,
      {obscureText, enableSuggestions, autocorrect}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: (value) {
          if(value == null || value.isEmpty){
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
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Color.fromRGBO(0, 103, 254, 1),
          )),
          enabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color.fromRGBO(255, 255, 255, 0.9))),
          hintText: text,
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}
