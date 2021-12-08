import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:lustore/app/model/product.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
import 'package:lustore/app/theme/style.dart';
import 'home_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sidebar sidebar = Sidebar();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 204, 204, 1),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event.runtimeType.toString() == 'RawKeyDownEvent') {
            if (event.isKeyPressed(LogicalKeyboardKey.f4)) {
              Get.back();
              dialogDiscount();
            }
            if (event.isKeyPressed(LogicalKeyboardKey.f2)) {
              Get.back();
              confirmSale(context);
            }
            if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
              Get.back();
              canceledSales();
            }
          }
        },
        child: Row(
          children: <Widget>[
            sidebar.side("sale"),
            Expanded(
              child: body(context),
            ),
            Container(
              height: 1000,
              width: 250,
              decoration: BoxDecoration(
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
              child: Container(
                color: const Color.fromRGBO(194, 152, 95, 1),
                child: priceSales(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void canceledSales() {
    Get.dialog(
      AlertDialog(
        content: const SingleChildScrollView(
          child: Text(
            "Deseja cancelar a venda?",
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
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(60, 45),
                  primary: const Color.fromRGBO(0, 103, 254, 1)),
              onPressed: () async {
                Get.back();
                await controller.removeAll();
              },
              child: const Text(
                "CONFIRMAR",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dialogDiscount() {
    Get.defaultDialog(
      title: "DESCONTO",
      content: SizedBox(
        width: 100,
        child: TextField(
          controller: controller.discount,
          textAlign: TextAlign.end,
          decoration: const InputDecoration(suffixText: "%"),
        ),
      ),
      radius: 5,
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ElevatedButton.styleFrom(
            primary: Colors.white, minimumSize: const Size(50, 40)),
        child: const Text(
          "Cancelar",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();

          await controller.addDiscountInProduct();
        },
        style: ElevatedButton.styleFrom(minimumSize: const Size(50, 40)),
        child: const Text(
          "Confirmar",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget body(context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          containerSearch(context),
          titleListProduct(),
          const Divider(height: 1),
          Expanded(child: productsSale()),
          footerSales(context),
        ]);
  }

  Widget containerSearch(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(1),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(1, 0.0), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 30, left: 20, right: 25, bottom: 20),
      child: Column(
        children: <Widget>[
          Container(
            child: textFieldSearch(
                "Consumidor final", const Text("Cliente"), controller.client),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SizedBox(
                  width: 130,
                  child: textFieldSearch("", const Text("Qts"), controller.qts,
                      filter: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ]),
                ),
              ),
              Expanded(
                child: autoComplete(context),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(10, 50),
                      primary: const Color.fromRGBO(0, 103, 254, 1)),
                  onPressed: () async {
                    loadingDesk();
                    var _response = await controller.productCreateSale();
                    if (_response == true) {
                      await controller.getSales();
                    } else {
                      error(context,
                          'Error, verifique ser o produto esta disponivel');
                    }
                    dismiss();
                  },
                  child: const Text("Adicionar"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget autoComplete(context) {
    return TypeAheadFormField<Product?>(
        textFieldConfiguration: TextFieldConfiguration(
            controller: controller.product,
            decoration: const InputDecoration(
              hintText: "Pesquisa",
              prefixIcon: Icon(Icons.search),
            )),
        onSuggestionSelected: (Product? suggestion) {
          final _product = suggestion!;
          controller.productId = _product.id!;
          controller.product.text = _product.product!;
        },
        itemBuilder: (context, Product? suggestion) {
          final _product = suggestion!;
          return ListTile(
            title: Text(_product.product!),
          );
        },
        suggestionsCallback: (suggestion) async {
          return await controller.searchProduct(suggestion);
        });
  }

  Widget textFieldSearch(String hint, type, searchController, {filter}) {
    return TextField(
      controller: searchController,
      inputFormatters: filter,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Container(
          margin: const EdgeInsets.only(top: 10, right: 15),
          child: type,
        ),
      ),
    );
  }

  Widget titleListProduct() {
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
            fieldTitle('ID'),
            fieldImageTitle(),
            fieldTitle('Produto'),
            fieldTitle('Quantidade'),
            fieldTitle('Valor'),
            fieldTitle('Tamanho'),
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

  Widget productsSale() {
    return Obx(
      () {
        if (controller.inLoading.isTrue) {
          return const Center(
            child: CircularProgressIndicator(
              color: styleColorBlue,
            ),
          );
        }
        return ListView.separated(
          itemCount: controller.allProductSales.length,
          controller: ScrollController(),
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            color: Colors.black12,
          ),
          itemBuilder: (BuildContext context, int index) {
            var _product = controller.allProductSales[index];
            return InkWell(
                highlightColor: Colors.white.withOpacity(0.8),
                focusColor: Colors.white.withOpacity(0.8),
                onTap: () {
                  controller.distributeInformation(_product);
                },
                child: _productInfoSale(_product, index, context));
          },
        );
      },
    );
  }

  Widget _productInfoSale(_product, index, context) {
    return Row(
      children: <Widget>[
        expandedFieldBody((index + 1).toString()),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: const Color.fromRGBO(31, 31, 31, 1.0),
          ),
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                _product['product']['product']
                    .toString()
                    .substring(0, 2)
                    .toUpperCase(),
                style: colorAndSizeWhite,
              )),
        ),
        expandedFieldBody(_product['product']['product']),
        expandedFieldBody(_product['qts'].toString()),
        Obx(() {
          if (controller.allProductSales[index]['discount'] > 0) {
            return valueProductInDiscount(_product);
          }
          return expandedFieldBody(controller.formatter
              .format(_product['saleValue'] * _product['qts']));
        }),
        expandedFieldBody(_product['product']['size'].toString()),
        expandedActionButton(_product, index, context),
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

  Widget valueProductInDiscount(_product) {
    var _subValue =
        controller.formatter.format(_product['saleValue'] * _product['qts']);
    var _total =
        controller.formatter.format(controller.discountProductView(_product));
    return Expanded(
        child: ListTile(
      title: Text(
        _subValue,
        style: const TextStyle(
            fontSize: 14,
            color: colorDark,
            decoration: TextDecoration.lineThrough),
        textAlign: TextAlign.center,
      ),
      subtitle: Text(
        _total,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    ));
  }

  Widget expandedActionButton(_product, index, context) {
    return Expanded(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
            onPressed: () async {
              controller.updateQts.value = _product['qts'];
              controller.discount.text =
                  _product['discount'].round().toString();
              controller.saleValuesFinal.value =
                  double.parse(_product['saleValue'].toString()) *
                      _product['qts'];
              updateSalesOneProduct(_product, index);
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.green.withOpacity(0.8),
                minimumSize: const Size(40, 45)),
            child: const Icon(Icons.edit),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            dialogDestroy(_product, context);
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.red, minimumSize: const Size(40, 45)),
          child: const Icon(Icons.delete),
        ),
      ],
    ));
  }

  void updateSalesOneProduct(_product, index) {
    Get.dialog(AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          style: TextButton.styleFrom(minimumSize: const Size(100, 50)),
          child: const Text(
            "Cancelar",
            style: TextStyle(fontSize: 16),
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              Get.back();
              loadingDesk();
              var _response = await controller.updateSale(_product, index);

              dismiss();
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 50)),
            child: const Text("Salvar"))
      ],
      title: const ListTile(
        title: Text("Detalhes"),
      ),
      content: SizedBox(
        width: 500,
        height: 140,
        child: StaggeredGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 5,
          staggeredTiles: const [
            StaggeredTile.extent(1, 70),
            StaggeredTile.extent(1, 70),
            StaggeredTile.extent(1, 70),
            StaggeredTile.extent(1, 70),
          ],
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(2))),
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: updateQtsSaleProduct(_product),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              color: Colors.black.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "VALOR DE VENDA",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 8.0, top: 10),
                    alignment: Alignment.centerRight,
                    child: Obx(
                      () => Text(
                        controller.formatter.format(
                            double.parse(_product['saleValue'].toString()) *
                                controller.updateQts.value),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 1),
              padding: const EdgeInsets.only(top: 2),
              color: Colors.black.withOpacity(0.1),
              child: discountUnit(_product['saleValue'].toString()),
            ),
            Container(
              padding: const EdgeInsets.only(top: 2, bottom: 5),
              margin: const EdgeInsets.only(top: 1),
              color: Colors.black.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "VALOR TOTAL COM DESCONTO",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 8.0, top: 10),
                    alignment: Alignment.centerRight,
                    child: Obx(() {
                      return Text(
                        controller.formatter
                            .format(controller.saleValuesFinal.value),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 14),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget discountUnit(valueQts) {
    return Column(
      children: <Widget>[
        const Text(
          "DESCONTO",
          style: TextStyle(fontSize: 14),
        ),
        Expanded(
          child: Container(
              height: 45,
              padding: const EdgeInsets.only(right: 8.0, left: 20, bottom: 10),
              alignment: Alignment.centerRight,
              child: TextField(
                textAlign: TextAlign.end,
                controller: controller.discount,
                onChanged: (value) {
                  controller.valueDiscountAll(
                      value,
                      (double.parse(valueQts) * controller.updateQts.value)
                          .toString());
                },
                decoration: const InputDecoration(suffixText: "%"),
              )),
        ),
      ],
    );
  }

  Widget updateQtsSaleProduct(_product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        buttonPlusLess(Icons.remove, _product),
        Container(
          height: 60,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                "QUANTIDADE",
                style: TextStyle(fontSize: 14),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Obx(() => Text(controller.updateQts.toString())),
              )
            ],
          ),
        ),
        buttonPlusLess(Icons.add, _product),
      ],
    );
  }

  Widget buttonPlusLess(IconData icon, _product) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (icon == Icons.add) {
            controller.updateQts.value++;
          }
          if (icon == Icons.remove && controller.updateQts > 1) {
            controller.updateQts.value--;
          }
          controller.valueDiscountAll(_product['discount'].toString(),
              (_product['saleValue'] * controller.updateQts.value).toString());
        },
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Icon(
              icon,
              size: 16,
            )),
      ),
    );
  }

  Widget footerSales(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(10, 0), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          footerButton("Cancelar venda (ESC)", const Icon(Icons.do_not_disturb),
              action: canceledSales),
          footerButton(
              "DESCONTO EM TODOS OS PRODUTOS (F4)",
              const Text(
                "%",
                style: TextStyle(fontSize: 20),
              ),
              action: dialogDiscount),
        ],
      ),
    );
  }

  void dialogDestroy(_product, context) {
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
                await controller.destroy(_product);
                dismiss();
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

  Widget footerButton(String text, Widget icon, {action, context}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 20, left: 25),
        padding: const EdgeInsets.only(top: 25, bottom: 25),
        child: TextButton.icon(
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(00, 50))),
          label: Text(text),
          icon: icon,
          onPressed: () {
            action();
          },
        ),
      ),
    );
  }

  Widget priceSales(context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            width: 1000,
            padding:
                const EdgeInsets.only(left: 20, bottom: 30, top: 20, right: 10),
            child: Obx(() {
              if (controller.infoProduct.isEmpty) {
                return const Text("");
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 250,
                    margin: const EdgeInsets.only(bottom: 25),
                    child: controller.image.toString().isEmpty
                        ? const Text("")
                        : Image.network(
                            controller.image.toString(),
                            fit: BoxFit.fill,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Produto: " +
                          controller.infoProduct['product']['product']
                              .toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Tamanho: " +
                        controller.infoProduct['product']['size'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        Obx(() {
          return Container(
            width: 250,
            padding:
                const EdgeInsets.only(left: 20, bottom: 30, top: 20, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Text(
                          "SubTotal:",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      Text(
                        controller.formatter.format(controller.subTotal.value),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Text(
                          "Desconto:",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      Text(
                        controller.infoProduct.containsKey('discount')
                            ? controller.infoProduct['discount']
                                    .round()
                                    .toString() +
                                ' %'
                            : controller.discount.text + " %",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Text(
                          "Total:",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      Text(
                        controller.formatter.format(controller.total.value),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10, top: 8),
                  child: ElevatedButton(
                      onPressed: () {
                        confirmSale(context);
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(500, 60),
                          primary: const Color.fromRGBO(0, 103, 254, 1)),
                      child: const Text("CONFIRMAR (F2)")),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void confirmSale(context) {
    Get.dialog(
      AlertDialog(
        content: const SingleChildScrollView(
          child: Text(
            "Deseja Finalizar a venda?",
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
                  primary: const Color.fromRGBO(0, 103, 254, 1)),
              onPressed: () async {
                Get.back();
                loadingDesk();
                var _response = await controller.finishSale();
                if (_response != true) {
                  dismiss();
                  error(context, _response);
                  return;
                }
                dismiss();
                success("Venda realizada com sucesso", context);
              },
              child: const Text(
                "CONFIRMAR",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget textFieldDialogExchangeAndReturn(String text, _controller) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: <Widget>[
//       Padding(
//         padding: const EdgeInsets.only(top: 8.0),
//         child: Text(
//           text,
//           textAlign: TextAlign.start,
//         ),
//       ),
//       TextField(
//         controller: _controller,
//       ),
//     ],
//   );
// }

// dataColumn(String _text) {
//   return DataColumn(
//     label: Text(
//       _text,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//     ),
//   );
// }
//
// dataRow(String _text) {
//   return DataCell(ConstrainedBox(
//     constraints: const BoxConstraints(maxWidth: 250),
//     child: Text(_text),
//   ));
// }

//void dialogExchangeAndReturn(context) {
//     Get.dialog(AlertDialog(
//       actionsPadding: const EdgeInsets.only(bottom: 10),
//       actions: [
//         ElevatedButton(
//             style: ElevatedButton.styleFrom(minimumSize: const Size(40, 50)),
//             onPressed: () {
//               controller.resultSearchProductSaleExchangeAndReturn.clear();
//               controller.codeSaleOrClient.text = "";
//               Get.back();
//             },
//             child: const Text("Cancelar")),
//         ElevatedButton(
//             style: ElevatedButton.styleFrom(minimumSize: Size(40, 50)),
//             onPressed: () {},
//             child: const Text("Troca")),
//         ElevatedButton(
//             style: ElevatedButton.styleFrom(minimumSize: Size(40, 50)),
//             onPressed: () {},
//             child: const Text("Devolver"))
//       ],
//       content: SizedBox(
//         width: 800,
//         child: Column(
//           children: <Widget>[
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 "TROCA/DEVOLUÇÃO",
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(
//               width: 800,
//               height: 90,
//               child: StaggeredGridView.count(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 5,
//                 crossAxisSpacing: 5,
//                 staggeredTiles: const [
//                   StaggeredTile.fit(2),
//                 ],
//                 children: [
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     child: textFieldDialogExchangeAndReturn(
//                         "COD.VENDA/CLIENTE", controller.codeSaleOrClient),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               alignment: Alignment.centerLeft,
//               padding: const EdgeInsets.only(top: 5, bottom: 10),
//               child: ElevatedButton.icon(
//                 label: const Text("Pesquisar"),
//                 onPressed: () {
//                   controller.exchangeAndReturn();
//                 },
//                 icon: const Icon(Icons.search),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(40, 50),
//                 ),
//               ),
//             ),
//             const Divider(height: 1),
//             Expanded(
//               child: resultSearchExchangeAndReturn(),
//             )
//           ],
//         ),
//       ),
//     ));
//   }

//  Widget resultSearchExchangeAndReturn() {
//     return Obx((){
//         if(controller.resultSearchProductSaleExchangeAndReturn.isEmpty){
//         return Text("");
//         }
//         return SingleChildScrollView(
//           primary: false,
//           child: DataTable(
//             columnSpacing: 30,
//             headingRowHeight: 40,
//             dataRowHeight: 60,
//             columns: <DataColumn>[
//               dataColumn("CÓDIGO"),
//               dataColumn("PRODUTO"),
//               dataColumn("QUANTIDADE"),
//               dataColumn("TAMANHO"),
//               dataColumn("VALOR"),
//             ],
//             rows: List<DataRow>.generate(
//                 controller.resultSearchProductSaleExchangeAndReturn.length,
//                     (int index) => DataRow(cells: <DataCell>[
//                   dataRow(controller
//                       .resultSearchProductSaleExchangeAndReturn[index]
//                   ["codeSales"]),
//                   dataRow(controller
//                       .resultSearchProductSaleExchangeAndReturn[index]
//                   ["product"]),
//                   dataRow(controller
//                       .resultSearchProductSaleExchangeAndReturn[index]
//                   ["qts"]
//                       .toString()),
//                   dataRow(controller
//                       .resultSearchProductSaleExchangeAndReturn[index]
//                   ["size"]),
//                   dataRow(controller.formatter.format(controller
//                       .resultSearchProductSaleExchangeAndReturn[index]
//                   ["saleValue"])),
//                 ],selected: controller.productSelectExchange[index] == true ? true : false,
//                     onSelectChanged: (value) {
//                       if(value == true){
//                         controller.productSelectExchange[index] = true;
//                       }else{
//                         controller.productSelectExchange[index] = false;
//                       }
//
//                     })),
//           ),
//         );
//
//     });
//   }
