import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lustore/app/api/api_user.dart';
import 'package:lustore/model/sale.dart';


class Sidebar {
  Sale sale = Sale();
  final store = GetStorage();
  RxBool sideOpen = false.obs;




  Widget side(String active) {
    return MouseRegion(
      onEnter: (event) => sideOpen.value = false,
      onExit: (event) => sideOpen.value = false,
      child: Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(194, 152, 95, 1)
              // gradient: LinearGradient(colors: [
              //   Color.fromRGBO(235, 235, 235, 1),
              //   Color.fromRGBO(194, 152, 95, 1)
              // ], begin: FractionalOffset(1, 0)),
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
                // containerSidebar(Icons.brightness_5_rounded, "Configuração",
                //     colorActive: active == "config" ? true : false,
                //     route: "/config"),
                containerSidebar(Icons.power_settings_new, "Sair"),
              ],
            ),
          )),
    );
  }

  Widget containerSidebar(IconData icon, String text, {route, colorActive}) {
    return InkWell(
      onTap: () async {

        if(store.read("sales") != null && text != "Vender"){
            Get.defaultDialog(
              title: "Alerta!",
              middleText: "Para proseguir e necessario finalizar a compra",
              confirm: ElevatedButton(onPressed: () async{

                Get.offAllNamed(route);
              }, child:  const Text("CONFIRMAR")),
              cancel: TextButton(onPressed: (){Get.back();},child:  const Text("CANCELAR")),
            );
            return;
        }
        if (text == "Sair") {
          await EasyLoading.show(
            maskType: EasyLoadingMaskType.custom,
          );
          await ApiUser().logout();
          store.erase();
          await EasyLoading.dismiss();
          Get.offAllNamed("/login");
        } else {
          Get.offAllNamed(route);
        }
      },
      child: Obx(
        () => Container(
          padding: const EdgeInsets.only(top: 20, bottom: 15),
          width: 1000,
          color: colorActive == true && sideOpen.isTrue
              ? const Color.fromRGBO(194, 132, 0, 1)
              : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
              size: 30
              ,
                color: colorActive == true && sideOpen.isFalse
                    ? const Color.fromRGBO(36, 33, 26, 1.0)
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
