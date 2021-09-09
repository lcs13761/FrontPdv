import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'categories_controller.dart';
import '../../sidebar/sidebar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sidebar sidebar = Sidebar();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 204, 204, 1),
      body: Row(
        children: <Widget>[
          sidebar.side("product"),
          Expanded(
            child: body(),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 20, top: 20, bottom: 10),
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              buttonActionAdd("Adicionar Categoria", true, true,
                  textAction: "Adicione a categoria",
                  controllerAction: controller.nameCategory,
                  actionType: "category"),
              buttonActionAdd("Adicionar Custo Mensal", false, true,
                  textAction: "Adicione o Custo mensal",
                  controllerAction: controller.costMonth,
                  actionType: "cost"),
              buttonActionAdd("Adicionar Produto", false, false),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(1, 3), // changes position of shadow
                ),
              ],
            ),
            child: categories(),
          ),
        ),
      ],
    );
  }

  Widget categories() {
    return Obx(
      () {
        if (controller.categoryIsEmpty.isTrue) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(0, 103, 254, 1),
            ),
          );
        }
        return StaggeredGridView.countBuilder(
          mainAxisSpacing: 10,
          crossAxisCount: 4,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 8,
          itemCount: controller.listCategories.length,
          itemBuilder: (BuildContext context, int index) => MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Get.offNamed("/products",
                    arguments: {"id": controller.listCategories[index]["id"]});
              },
              child: Container(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.cyanAccent : Colors.amberAccent,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(1, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          controller.listCategories[index]["category"]
                              .toString()
                              .toUpperCase(),
                          style: TextStyle(
                            locale: const Locale("pt-BR"),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            wordSpacing: 1,
                            shadows: [
                              Shadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: const Offset(1, 3),
                                  blurRadius: 1)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(bottom: 50, left: 10),
                        child: FutureBuilder(
                          future: controller.product.getProductsByCategory(
                              controller.listCategories[index]["id"]
                                  .toString()),
                          builder:
                              (BuildContext build, AsyncSnapshot snapshot) {
                            var qtsProducts = "";
                            if (snapshot.hasData) {
                              qtsProducts =
                                  snapshot.data["result"].length.toString();
                            }
                            return Text(
                              "Qts: " + qtsProducts,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            );
                          },
                        )),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: () {
                              controller.nameCategory.text =
                                  controller.listCategories[index]["category"];
                              create("Adicione a categoria",
                                  controller.nameCategory, "category",
                                  update: true,
                                  id: controller.listCategories[index]["id"]);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              minimumSize: const Size(10, 40),
                            ),
                            icon: const Icon(Icons.edit),
                            label: const Text(
                              "Editar",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                defaultDialogDelete(index);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  minimumSize: const Size(10, 40)),
                              icon: const Icon(Icons.delete),
                              label: const Text(
                                "Excluir",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          staggeredTileBuilder: (int index) => const StaggeredTile.count(1, 1),
        );
      },
    );
  }

  void defaultDialogDelete(index) {
    Get.defaultDialog(
      title: "Excluir Categoria",
      textCancel: "Cancelar",
      middleText: "Desejar excluir a categoria?",
      radius: 5,
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
        child: const Text(
          "Cancelar",
          style: TextStyle(color: Colors.black),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          controller.categoryDelete(
              controller.listCategories[index]["id"].toString(), index);
        },
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.grey.withOpacity(0.5),
        ),
        child: const Text("Confirmar"),
      ),
    );
  }

  Widget buttonActionAdd(String text, cleanCategory, action,
      {textAction, controllerAction, actionType}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          if (cleanCategory) {
            controller.nameCategory.text = "";
          }
          if (action) {
            create(textAction, controllerAction, actionType);
          } else {
            Get.offNamed("/add-product");
          }
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            minimumSize: const Size(10, 55),
            primary: const Color.fromRGBO(0, 103, 254, 1)),
        icon: const Icon(Icons.add_circle_outline),
        label: Text(text),
      ),
    );
  }

  void create(String text, controllerField, type, {update, id}) {
    Get.dialog(
      AlertDialog(
        content: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text(text),
              TextField(
                controller: controllerField,
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(60, 45),
              ),
              onPressed: () async {
                if (type == "cost") {
                  Get.back();
                  controller.monthCost();
                }
                if (type == "category") {
                  Get.back();
                  if (update != true) {
                    controller.categoryCreate();
                  } else {
                    controller.categoryUpdate(id.toString());
                  }
                }
              },
              child: const Text(
                "Salvar",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
