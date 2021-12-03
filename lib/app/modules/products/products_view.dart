import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
import 'package:lustore/app/routes/app_pages.dart';
import 'package:lustore/app/theme/style.dart';
import 'products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sidebar sidebar = Sidebar();
    return Scaffold(
      backgroundColor: backgroundColorDark,
      body: Row(
        children: <Widget>[
          sidebar.side("product"),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                  bottom: 5, right: 10, top: 20, left: 10),
              child: Column(
                children: <Widget>[
                  searchProductContainer(),
                  titleProduct(),
                  const Divider(
                    height: 1,
                  ),
                  productsList()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchProductContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: colorBackgroundCard,
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
              const Expanded(child: Text('Produtos')),
              searchProduct(),
              buttonAddProduct()
            ],
          ),
        ],
      ),
    );
  }

  Widget searchProduct() {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 10, top: 20),
      child: TextField(
        controller: controller.searchProduct,
        onChanged: (text) {
          controller.searchDd(text);
        },
        decoration: const InputDecoration(
            hintText: 'Pesquisar',
            enabledBorder: borderDark,
            focusedErrorBorder: borderColorFocus,
            focusedBorder: borderFocusGray,
            prefixIcon: Icon(Icons.youtube_searched_for)),
      ),
    );
  }

  Widget buttonAddProduct() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              Get.offAllNamed(Routes.PRODUCTS_CREATE_UPDATE);
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                minimumSize: const Size(10, 55),
                primary: const Color.fromRGBO(0, 103, 254, 1)),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text("Adicionar Produto"),
          ),
        ],
      ),
    );
  }

  Widget titleProduct() {
    return Container(
      decoration: BoxDecoration(
        color: colorBackgroundCard,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(1, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Row(
          children: <Widget>[
            fieldTitle('id'),
            fieldImageTitle(),
            fieldTitle('Produto'),
            fieldTitle('Quantidade'),
            fieldTitle('Valor'),
            fieldTitle('Categoria'),
            fieldTitle('Action')
          ],
        ),
      ),
    );
  }

  Widget fieldTitle(text) {
    return Expanded(
        child: Text(
      text,
      textAlign: TextAlign.center,
    ));
  }

  Widget fieldImageTitle() {
    return const SizedBox(
      width: 50,
      child: Text(''),
    );
  }

  Widget productsList() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
          color: colorBackgroundCard,
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
          if (controller.inLoading.isTrue) {
            return const Center(
              child: CircularProgressIndicator(
                color: styleColorBlue,
              ),
            );
          }
          return PagedListView.separated(
              pagingController: controller.allProducts,
              separatorBuilder: (context, index) => const Divider(
                    color: Colors.black12,
                    height: 1,
                  ),
              builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (BuildContext context, item, index) {
                    index = index + 1;
                return bodyProductList(item, index,context);
              }));
        }),
      ),
    );
  }

  Widget bodyProductList(_product, index,context) {
    return Row(
      children: <Widget>[
        expandedFieldBody(index.toString()),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: const Color.fromRGBO(31, 31, 31, 1.0),
          ),
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          child: _product["image"].length != 0 &&
                  _product['image'][0]['image'] != null
              ? Image.network(
                  _product["image"][0]["image"],
                  fit: BoxFit.fill,
                )
              : Align(
                  alignment: Alignment.center,
                  child: Text(
                    _product['product'].toString().substring(0, 2),
                    style: colorAndSizeWhite,
                  )),
        ),
        expandedFieldBody(_product["product"].toString()),
        expandedFieldBody(_product["qts"].toString()),
        expandedFieldBody(_product["saleValue"].toString()),
        expandedFieldBody(_product["category"]['category'].toString()),
        expandedActionButton(_product, index,context),
      ],
    );
  }

  Widget expandedFieldBody(text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget expandedActionButton(_product, index,context) {
    return Expanded(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
            onPressed: () async {
              Get.offNamed(Routes.PRODUCTS_CREATE_UPDATE, arguments: _product);
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.green.withOpacity(0.8),
                minimumSize: const Size(40, 45)),
            child: const Icon(Icons.edit),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            dialogDestroy(_product,context);
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.red, minimumSize: const Size(40, 45)),
          child: const Icon(Icons.delete),
        ),
      ],
    ));
  }

  void dialogDestroy(_product,context) {
    Get.dialog(
      AlertDialog(
        content: const SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Text(
            "Deseja excluir o produto?",
            style: TextStyle(
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
                Get.back();
                loadingDesk();
                await 1.delay();
                var _response = await controller.deleteProduct(_product['id']);
                if (_response != true) {
                  dismiss();
                  error(context, _response["error"]);
                } else {
                  controller.allProducts.value.itemList!.remove(_product);
                  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                  controller.allProducts.notifyListeners();
                  dismiss();
                }
              },
              child: const Text(
                "Confirmar",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
