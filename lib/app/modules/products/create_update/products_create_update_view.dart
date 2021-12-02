import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
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
            return body();
          })),
        ],
      ),
    );
  }

  Widget body() {
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
          inputProduct("Código do Produto", controller.cod,
              filter: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))]),
          inputProduct("Nome do Produto", controller.productName),
          inputProduct("Quantidade", controller.qts,
              filter: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))]),
          dropDowCategory(),
          inputProduct("Valor de custo", controller.cost),
          inputProduct("Valor de venda", controller.value),

          // // image(),
          // buttonSave()
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
          controller.fileImage.add(result.files.single.path.toString());
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
              if(File(element).isAbsolute){
                return GestureDetector(
                  onSecondaryTap: (){
                    Get.dialog(AlertDialog(
                      content: ListTile(
                        onTap: () {
                          Get.back();
                          controller.fileImage.remove(element);
                        },
                        title: const Text("Remove Imagem."),
                      ),
                    ));
                  },
                  child: Image.file(File(element.toString()), height: 130,),
                );
              }
              return GestureDetector(
                child: Image.network(element.toString(), height: 130,),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget inputProduct(String text, type, {filter}) {
    return Container(
        margin: const EdgeInsets.only(right: 30, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(text),
            TextField(
              controller: type,
              inputFormatters: filter,
            ),
          ],
        ));
  }

  Widget dropDowCategory() {
    return Container(
      margin: const EdgeInsets.only(right: 30, top: 10, bottom: 10),
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
        ],
      )
    );
  }




// Widget buttonSave() {
//   return Container(
//     padding: const EdgeInsets.only(top: 15.0),
//     alignment: Alignment.centerLeft,
//     child: ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         minimumSize: const Size(100, 50),
//       ),
//       onPressed: () {
//         if (controller.updatePrt.isFalse) {
//           controller.createProduct();
//         }
//         if (controller.updatePrt.isTrue) {
//           controller.updateProduct();
//         }
//       },
//       child: const Text(
//         "Salvar",
//         style: TextStyle(fontSize: 16),
//       ),
//     ),
//   );
// }
}
