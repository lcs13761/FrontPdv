import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../sidebar/sidebar.dart';
import 'add_product_controller.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sidebar sidebar = Sidebar();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 204, 204, 1),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          sidebar.side("product"),
          Expanded(child: bodyAddProduct()),
        ],
      ),
    );
  }

  Widget bodyAddProduct() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, right: 10, left: 10, top: 20),
      padding: const EdgeInsets.only(bottom: 5, right: 10, left: 10, top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
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
          inputProduct(
              "Código do Produto:", "Código do Produto", controller.cod),
          inputProduct(
              "Nome do Produto:", "Nome do Produto", controller.nameProduct),
          inputProduct("Quantidade:", "0", controller.qts,
              filter: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))]),
          dropDowCategory(),
          inputProduct("Valor de venda:", "", controller.saleValue),
          selectSize(),
          buttonImage(),
          image(),
          buttonSave()
        ],
        staggeredTiles: const [
          StaggeredTile.fit(2),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(2),
          StaggeredTile.fit(2),
          StaggeredTile.fit(2),
        ],
      ),
    );
  }

  Widget inputProduct(String text, String description, type, {filter}) {
    return Container(
      margin: const EdgeInsets.only(right: 30, top: 10, bottom: 10),
      child: TextField(
        controller: type,
        inputFormatters: filter,
        decoration: InputDecoration(
          hintText: description,
          prefixIcon: Container(
            margin: const EdgeInsets.only(top: 10, right: 15),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDowCategory() {
    return Container(
      margin: const EdgeInsets.only(right: 30, top: 10, bottom: 10),
      child: Obx(
        () {
          if (controller.listCategories.isNotEmpty) {
            return DropdownButtonFormField(
              decoration: const InputDecoration(
                prefix: Padding(
                  padding: EdgeInsets.only(top: 10, right: 15),
                  child: Text(
                    "Categoria:",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              onChanged: (newValue) {
                controller.idCategory.value = newValue.toString();
              },
              value: controller.idCategory.toString(),
              items: controller.listCategories.map((value) {
                return DropdownMenuItem(
                  value: value["id"].toString(),
                  child: Text(value["category"].toString().toUpperCase()),
                );
              }).toList(),
            );
          }
          return const Text("");
        },
      ),
    );
  }

  Widget selectSize() {
    return Container(
      margin: const EdgeInsets.only(right: 30, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          const Text(
            "Tamanho:",
            style: TextStyle(fontSize: 16),
          ),
          sizeProduct("P"),
          sizeProduct("M"),
          sizeProduct("G"),
        ],
      ),
    );
  }

  Widget sizeProduct(size) {
    return GestureDetector(
      onTap: () {
        controller.sizeProduct.value = size;
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: controller.sizeProduct != size
                  ? Colors.grey.withOpacity(0.5)
                  : Colors.green.withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(1, 3), // changes position of shadow
                ),
              ],
            ),
            width: 30,
            alignment: Alignment.center,
            height: 30,
            margin: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
            child: Text(size),
          ),
        ),
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

          if (result != null) {
            controller.file.value = result.files.single.path.toString();
            controller.fileUpload.value = true;
          } else {
            controller.file.value = "";
            controller.fileUpload.value = false;
          }
        },
        child: const Text("Adicionar Imagem"),
      ),
    );
  }

  Widget image() {
    return Obx(
      () {
        if (controller.fileUpload.isFalse) {
          return const Text("");
        }
        return Container(
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: controller.updatePrt.isFalse
              ? Image.file(
                  File(controller.file.value.toString()),
                  height: 150,
                )
              : Image.network(
                  controller.imageProduct.toString(),
                  height: 150,
                ),
        );
      },
    );
  }

  Widget buttonSave() {
    return Container(
      padding: const EdgeInsets.only(top: 15.0),
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(100, 50),
        ),
        onPressed: () {
          if (controller.updatePrt.isFalse) {
            controller.createProduct();
          }
          if (controller.updatePrt.isTrue) {
            controller.updateProduct();
          }
        },
        child: const Text(
          "Salvar",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
