import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
import 'package:lustore/app/theme/style.dart';
import 'categories_controller.dart';
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
          sidebar.side("category"),
          Expanded(
            child: body(context),
          ),
        ],
      ),
    );
  }

  Widget body(context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 20, top: 20, bottom: 10),
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              buttonActionAdd(context),
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

  Widget buttonActionAdd(context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          controller.nameCategory.text = "";
          action(context);
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            minimumSize: const Size(10, 55),
            primary: const Color.fromRGBO(0, 103, 254, 1)),
        icon: const Icon(Icons.add_circle_outline),
        label: const Text("Adicionar Categoria"),
      ),
    );
  }

  Widget categories() {
    return Obx(
      () {
        if (controller.inLoading.isTrue) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(0, 103, 254, 1),
            ),
          );
        }
        return StaggeredGridView.countBuilder(
          mainAxisSpacing: 10,
          crossAxisCount: 8,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 8,
          itemCount: controller.categories.length,
          itemBuilder: (BuildContext context, int index) {
            var _category = controller.categories[index];
            return Container(
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
                        _category["category"]
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
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buttonAction(Icons.edit, _category,context,actionButton: 'update',index: index),
                        buttonAction(Icons.delete, _category,context),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          staggeredTileBuilder: (int index) => const StaggeredTile.count(1, 1),
        );
      },
    );
  }

  Widget buttonAction(icon,_category,context,{actionButton,index}){
    return InkWell(
      onTap: (){
          if(actionButton != null){
              controller.nameCategory.text = _category['category'];
              action(context,category: _category,index: index);
          }else{
            defaultDialogDelete(_category,context);
          }
      },
      mouseCursor: SystemMouseCursors.click,
      child: Container(
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          color: actionButton != null ? Colors.green : Colors.red,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Icon(icon),
      ),
    );
  }

  void defaultDialogDelete(_category,context) {
    Get.defaultDialog(
      title: "Excluir Categoria",
      textCancel: "Cancelar",
      middleText: "Desejar excluir a categoria?",
      radius: 5,
      cancel: buttonActionDialogDestroy(Colors.black,'Cancelar', context,color: Colors.white),
      confirm: buttonActionDialogDestroy(Colors.white, "Confirmar",context,category: _category),
    );
  }

  Widget buttonActionDialogDestroy(Color colorText,String text,context,{category,color}){
    return  ElevatedButton(
      onPressed: () async{
        Get.back();
        if(category != null){
            loadingDesk();
            var _response = await controller.destroy(category['id'].toString());
            if(_response != true){
              dismiss();
              error(context, _response['error']);
              return;
            }

            controller.categories.remove(category);
            dismiss();
            success('Categoria removida com sucesso',context);
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(30,50),
        padding: const EdgeInsets.all(5),
        primary: color,
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      child: Text(text,style: TextStyle(color: colorText),),
    );
  }

  void action(context,{index, category}) {
    Get.dialog(
      AlertDialog(
        content: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const Text("Categoria"),
              TextField(
                controller: controller.nameCategory,
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
                Get.back();
                loadingDesk();
                if (category == null) {
                  controller.typeAction = 'create';
                  var _response = await controller.categoryActionSubmit();
                  if(_response == true){
                      controller.createResponse();
                  }else{
                    error(context, 'Error ao criar a categoria');
                  }
                  dismiss();
                } else {
                  controller.typeAction = 'update';
                  var _response = await controller.categoryActionSubmit(id: category['id']);
                  if(_response == true){
                    controller.updateResponse(category,context,index);
                  }else{
                    error(context, 'Error ao modificar a categoria');
                  }
                  dismiss();
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
