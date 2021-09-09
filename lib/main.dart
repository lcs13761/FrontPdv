import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

void main() async {
  await GetStorage.init();
  Intl.defaultLocale = 'pt_BR';
  configLoading();
  runApp(
    GetMaterialApp(
      title: "Application",
      theme: ThemeData(
        backgroundColor: const Color.fromRGBO(204, 204, 204, 1),
        buttonTheme:
            const ButtonThemeData(buttonColor: Color.fromRGBO(0, 103, 254, 1)),
        textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.black)),
        primaryColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..backgroundColor = Colors.transparent
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = const Color.fromRGBO(93, 91, 91, 0.0)
    ..indicatorColor = const Color.fromRGBO(0, 103, 254, 1)
    ..textStyle = const TextStyle(color: Colors.transparent)
    ..textColor = const Color.fromRGBO(0, 0, 0, 1)
    ..dismissOnTap = false
    ..maskColor = const Color.fromRGBO(93, 91, 91, 0.0)
    ..userInteractions = false
    ..boxShadow = [const BoxShadow(color: Colors.transparent)];
}
