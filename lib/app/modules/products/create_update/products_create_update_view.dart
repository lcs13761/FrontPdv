import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
import 'package:lustore/app/routes/app_pages.dart';
import 'package:lustore/app/theme/style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'products_create_update_controller.dart';

class ProductsCreateUpdateView extends GetView<ProductsCreateUpdateController> {
  const ProductsCreateUpdateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sidebar sidebar = Sidebar();
    return Scaffold(
      backgroundColor: backgroundColorDark,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          sidebar.side("product"),
          Expanded(child: Obx(() {
            if (controller.onLoadingFinalized.isFalse) {
              return const Center(
                child: CircularProgressIndicator(
                  color: styleColorBlue,
                ),
              );
            }
            return body(context);
          })),
        ],
      ),
    );
  }

  Widget body(context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, right: 10, left: 10, top: 20),
      padding: const EdgeInsets.only(bottom: 5, right: 10, left: 10, top: 20),
      child: StaggeredGridView.count(
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 8,
        children: [
          Container(
              alignment: Alignment.center,
              child: const Text("Adicionar Produtos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ))),
          buttonImage(),
          image(),
          inputProduct("Código do Produto", controller.cod,'code',
              filter: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))]),
          inputProduct("Nome do Produto", controller.productName,'product'),
          inputProduct("Descrição (opicional)", controller.description,'description'),
          inputProduct("Quantidade", controller.qts,'qts',
              filter: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))]),
          dropDowCategory(),
          inputProduct("Valor de custo", controller.cost,'costValue'),
          inputProduct("Valor de venda", controller.value,'saleValue'),
          inputProduct("Tamanho", controller.size,'size'),
          buttonSave(context)
        ],
        staggeredTiles: const [
          StaggeredTile.fit(2),
          StaggeredTile.fit(1),
          StaggeredTile.fit(2),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
        ],
      ),
    );
  }

  Widget buttonImage() {
    return Container(

      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: const Size(40, 50)),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom, allowedExtensions: ["jpg", "png", "jpeg"]);

          if (result != null && controller.fileImage.length < 4) {
            controller.fileImage.add(
                {'id': null, 'image': result.files.single.path.toString()});
          }
        },
        child: const Text("Adicionar Imagem"),
      ),
    );
  }

  Widget image() {
    return Obx(
      () {
        if (controller.fileImage.isEmpty) {
          return const Text("");
        }
        return Container(
          margin: const EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Row(
            children: controller.fileImage.map((element) {
              if (element['image'] != null) {
                if (File(element['image']).isAbsolute) {
                  return GestureDetector(
                    onSecondaryTap: () {
                      removeImage(element, type: 'local');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image.file(
                        File(element['image'].toString()),
                        height: 130,
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Image.network(
                      element['image'].toString(),
                      height: 130,
                    ),
                  ),
                );
              } else {
                return const Text('');
              }
            }).toList(),
          ),
        );
      },
    );
  }

  void removeImage(element, {type}) {
    Get.dialog(AlertDialog(
      content: ListTile(
        onTap: () {
          Get.back();
          if (type == 'local') {
            controller.fileImage.remove(element);
          } else {
            element['image'] = null;
            var _imageRemove = element;
            controller.fileImage.remove(element);
            controller.fileImage.add(_imageRemove);
          }
        },
        title: const Text("Remove Imagem."),
      ),
    ));
  }

  Widget inputProduct(String text, type, key,{filter}) {
    return Container(
        margin: const EdgeInsets.only(right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(text),
            TextField(
              controller: type,
              inputFormatters: filter,
            ),
            Obx(() {
              if (controller.errors.containsKey(key)) {
                return Container(
                  margin: const EdgeInsets.only(),
                  child: Text(
                    controller.errors[key][0].toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return const Text('');
            }),
          ],
        ));
  }

  Widget dropDowCategory() {
    return Container(
        margin: const EdgeInsets.only(right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Categoria'),
            Obx(
              () {
                return DropdownButtonFormField(
                  onChanged: (newValue) {
                    controller.stringCategory.value = newValue.toString();
                  },
                  value: controller.stringCategory.toString(),
                  items: controller.categoryList.map((value) {
                    return DropdownMenuItem(
                      value: value["id"].toString(),
                      child: Text(value["category"].toString().toUpperCase()),
                    );
                  }).toList(),
                );
              },
            ),
            const Text(''),
          ],
        ));
  }

  Widget buttonSave(context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        alignment: Alignment.topCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 50),
              ),
              onPressed: () async{
                  loadingDesk();
                  var _response = await controller.submitTypeAction();
                  await 1.delay();
                  if (_response == true) {
                    dismiss();
                    success("sucesso", context, route: Routes.PRODUCTS);
                  } else {
                    controller.errors.clear();
                    controller.errors.addAll(_response);
                    dismiss();
                  }

              },
              child: const Text(
                "Salvar",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50), primary: Colors.red),
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Cancelar",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ));
  }
}
