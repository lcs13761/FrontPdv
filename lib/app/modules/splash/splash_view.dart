import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

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
         Container(
           margin: const EdgeInsets.only(top: 100),
           child: const Center(
             child: CircularProgressIndicator(
               color: Color.fromRGBO(0, 103, 254, 1),
             ),
           ),
         ),
        ],
      ),
    );
  }
}
