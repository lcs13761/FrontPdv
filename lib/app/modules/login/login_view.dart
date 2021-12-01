import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lustore/app/routes/app_pages.dart';
import 'package:lustore/app/theme/style.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

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
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        textFieldEmail(),
                        textFieldPassword(),
                        forgetPasswordOrRemember(),
                        buttonSubmit(context),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }


  Widget textFieldEmail() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: (value) {
          return controller.validationEmail(value);
        },
        enableSuggestions: true,
        autocorrect: true,
        keyboardType: TextInputType.emailAddress,
        controller: controller.email,
        style: colorStyleInput,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
          errorBorder: errorBorder,
          focusedErrorBorder: borderColorFocus,
          focusedBorder: borderColorFocus,
          enabledBorder: borderColor,
          hintText: "example@mail.com",
          prefixIcon: Icon(
            Icons.email,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }

  Widget textFieldPassword() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Preencha esse campo";
            }
            return null;
          },
          obscureText: controller.show.isTrue ? false : true,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.visiblePassword,
          controller: controller.password,
          style: colorStyleInput,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
            ),
            errorBorder: errorBorder,
            focusedErrorBorder: borderColorFocus,
            focusedBorder: borderColorFocus,
            enabledBorder: borderColor,
            hintText: 'Senha',
            suffixIcon: InkWell(
              onTap: () {
                if (controller.show.isTrue) {
                  controller.show.value = false;
                } else {
                  controller.show.value = true;
                }
              },
              child: controller.show.isTrue ? hiddenPassword : showPassword,
            ),
            prefixIcon: Icon(
              Icons.password,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
      );
    });
  }


  Widget forgetPasswordOrRemember() {
    return Container(
        margin: const EdgeInsets.only(  bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Obx(
                  () => Row(
                children: <Widget>[
                  Checkbox(
                      checkColor: Colors.white,
                      side: BorderSide(
                          color: Colors.white.withOpacity(0.8)
                      ),
                      activeColor: const Color.fromRGBO(0, 103, 254, 1),
                      value: controller.rememberMe.isTrue,
                      onChanged: (value) {
                        if (value != null) {
                          controller.rememberMe.value = value;
                        }
                      }),
                  GestureDetector(
                    onTap: (){
                      if(controller.rememberMe.isTrue){
                        controller.rememberMe.value = false;
                      }else{
                        controller.rememberMe.value = true;
                      }
                    },
                    child: Text(
                      "Lembrar-me?",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.LOGIN_FORGET_PASSWORD);
              },
              child: Text(
                "Esqueceu a senha?",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ));
  }


  Widget buttonSubmit(context) {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          loading(context);
          var _response = await controller.login();
          if (_response == true) {
            await 1.delay();
            Get.offAllNamed("/home");
            return;
          } else {
            print(_response);
            await 1.delay();
            Get.back();
            error(context, _response);
            return;
          }
        }
      },
      child: Container(
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
          "ENTRAR",
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
