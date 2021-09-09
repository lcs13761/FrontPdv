import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:lustore/app/modules/home/home_controller.dart';


class Sidebar {
  HomeController controller = HomeController();
  final store = GetStorage();
  RxBool sideOpen = false.obs;


  Widget side(String active) {
    return MouseRegion(
      onEnter: (event) => sideOpen.value = true,
      onExit: (event) => sideOpen.value = false,
      child: Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(235, 235, 235, 1),
                Color.fromRGBO(194, 152, 95, 1)
              ], begin: FractionalOffset(1, 0)),
            ),
            height: 1000,
            width: sideOpen.isFalse ? 50 : 100,
            child: Column(
              children: <Widget>[
                Container(
                 margin: const EdgeInsets.only(top: 60),
                  child: containerSidebar(Icons.shopping_cart_outlined, "Vender",
                      colorActive: active == "sale" ? true : false,
                      route: "/home"),
                ),
                containerSidebar(Icons.work_outline_outlined, "Produtos",
                    colorActive: active == "product" ? true : false,
                    route: "/categories"),
                containerSidebar(Icons.assessment_outlined, "Relatórios",
                    colorActive: active == "reports" ? true : false,
                    route: "/reports"),
                containerSidebar(Icons.access_time, "Histórico",
                    colorActive: active == "historic" ? true : false,
                    route: "/historic-sales"),
                containerSidebar(Icons.brightness_5_rounded, "Configuração",
                    colorActive: active == "config" ? true : false,
                    route: "/config"),
                containerSidebar(Icons.power_settings_new, "Sair"),
              ],
            ),
          )),
    );
  }

  Widget containerSidebar(IconData icon, String text, {route, colorActive}) {
    return InkWell(
      onTap: () async {
        if (text == "Sair") {
          if (store.read("sales") != null) {
            controller.removeAll();
            await 1.delay();
          }
          exit(0);
        } else {
          Get.offNamed(route);
        }
      },
      child: Obx(
        () => Container(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          width: 1000,
          color: colorActive == true && sideOpen.isTrue
              ? const Color.fromRGBO(194, 132, 0, 1)
              : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: colorActive == true && sideOpen.isFalse
                    ? const Color.fromRGBO(194, 132, 0, 1)
                    : Colors.white70,
              ),
              sideOpen.isFalse
                  ? const Text("")
                  : Text(
                      text,
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
