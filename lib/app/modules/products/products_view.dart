import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
import '../../sidebar/sidebar.dart';
import 'products_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sidebar sidebar = Sidebar();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 204, 204, 1),
      body: Row(
        children: <Widget>[
          sidebar.side("product"),
          Expanded(
            child: searchContainer(),
          ),
        ],
      ),
    );
  }

  Widget searchContainer() {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 5, right: 10, left: 10, top: 20),
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: const Color.fromRGBO(248, 248, 248, 1),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  searchProduct("Produto", "Produto"),
                ],
              ),
            ],
          ),
        ),
        titleListProduct(),
        Container(
            margin: const EdgeInsets.only(right: 10, left: 10),
            child: const Divider(
              height: 1,
              color: Colors.black12,
            )),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5)),
              color: const Color.fromRGBO(248, 248, 248, 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(1, 3), // changes position of shadow
                ),
              ],
            ),
            child: Obx(() {
              if (controller.isNotEmpty.isTrue) {
                return ListView.separated(
                    itemCount: controller.allProducts.length,
                    separatorBuilder: (context, index) => const Divider(
                          color: Colors.black12,
                          height: 1,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: bodyProductList(index)
                      );
                    });
              }

              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(0, 103, 254, 1),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  void dialogGet(String text, String confirm, index) {
    Get.dialog(
      AlertDialog(
        content: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
        ),
        actions: <Widget>[
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
                controller.deleteProduct(
                    controller.allProducts[index]["code"].toString(), index);
              },
              child: Text(
                confirm,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchProduct(String text, String description) {
    return Container(
      width: 450,
      padding: const EdgeInsets.only(right: 20, top: 20),
      child: TextField(
        controller: controller.searchProduct,
        onChanged: (text) {
          controller.searchDd(text);
        },
        decoration: InputDecoration(
          hintText: description,
          prefixIcon: Container(
            margin: const EdgeInsets.only(top: 10, right: 15),
            child: Text(text),
          ),
        ),
      ),
    );
  }

  Widget titleListProduct() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            // changes position of shadow
          ),
        ],
      ),
      height: 60,
      padding: const EdgeInsets.only(left: 10),
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: StaggeredGridView.count(
        crossAxisCount: 6,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        children: <Widget>[
          valuesBodySearch("Código"),
          valuesBodySearch("Produto"),
          valuesBodySearch("Quantidade"),
          valuesBodySearch("Tamanho"),
          valuesBodySearch("Preço"),
        ],
        staggeredTiles: const [
          StaggeredTile.extent(1, 60),
          StaggeredTile.extent(1, 60),
          StaggeredTile.extent(1, 60),
          StaggeredTile.extent(1, 60),
          StaggeredTile.extent(1, 60),
        ],
      ),
    );
  }
  Widget bodyProductList(index){
    return  SizedBox(
      height: 60,
      child: StaggeredGridView.count(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 6,
        mainAxisSpacing: 10,
        crossAxisSpacing: 0,
        children: <Widget>[
          valuesBodySearch(controller.allProducts[index]["code"].toString()),
          valuesBodySearch(controller.allProducts[index]["product"].toString()),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: valuesBodySearch(controller.allProducts[index]["qts"].toString()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: valuesBodySearch(controller.allProducts[index]["size"]),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(controller.formatter.format(controller.allProducts[index]["saleValue"])),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    Get.offNamed("/add-product",
                        arguments: controller.allProducts[index]);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green.withOpacity(0.8),
                      minimumSize: const Size(40, 45)),
                  child: const Icon(Icons.edit),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  dialogGet("Deseja excluir o produto?",
                      "Confirmar", index);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.red, minimumSize: const Size(40, 45)),
                child: const Icon(Icons.delete),
              ),
            ],
          )
        ],
        staggeredTiles: const [
          StaggeredTile.extent(1, 60),
          StaggeredTile.extent(1, 60),
          StaggeredTile.extent(1, 60),
          StaggeredTile.extent(1, 60),
          StaggeredTile.extent(1, 60),
          StaggeredTile.extent(1, 60),
        ],
      ),
    );
  }

  Widget valuesBodySearch(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}
