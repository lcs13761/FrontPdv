import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
import 'package:lustore/app/routes/app_pages.dart';
import 'package:lustore/app/theme/style.dart';
import 'config_controller.dart';

class ConfigView extends GetView<ConfigController> {
  const ConfigView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sidebar sidebar = Sidebar();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 204, 204, 1),
      body: Row(
        children: <Widget>[
          sidebar.side("config"),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: <Widget>[
                        buttonActionAdd(context),
                        buttonChangePassword(context),
                      ],
                    ),
                  ),
                  Expanded(child: bodySelectRegister(context))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonChangePassword(context){
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Get.toNamed(Routes.CONFIG_CHANGE_PASSWORD, arguments: controller.administrators);
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            minimumSize: const Size(10, 55),
            primary: const Color.fromRGBO(0, 103, 254, 1)),
        icon: const Icon(Icons.password),
        label: const Text("Modificar Senha"),
      ),
    );
  }

  Widget buttonActionAdd(context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
            Get.toNamed(Routes.CONFIG_ADMIN);
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            minimumSize: const Size(10, 55),
            primary: const Color.fromRGBO(0, 103, 254, 1)),
        icon: const Icon(Icons.add_circle_outline),
        label: const Text("Adicionar Administrado"),
      ),
    );
  }

  Widget bodySelectRegister(context) {
    return Obx(() {
      if (controller.inLoading.isTrue) {
        return const Center(
          child: CircularProgressIndicator(
            color: styleColorBlue,
          ),
        );
      }

      return StaggeredGridView.countBuilder(
        staggeredTileBuilder: (int index) => const StaggeredTile.count(1, 1),
        mainAxisSpacing: 5,
        crossAxisCount: 5,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 5,
        itemCount: controller.administrators.length,
        itemBuilder: (BuildContext context, int index) {
          var _admin = controller.administrators[index];

          return Container(
            child: adminInformation(_admin, context, index),
          );
        },
      );
    });
  }

  Widget adminInformation(_admin, context, index) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: _admin['photo'] != null
                      ? NetworkImage(_admin['photo'])
                      : const AssetImage('images/avatar.jpg') as ImageProvider,
                )
                // child: _admin['photo'] != null ? Image.network(_admin['photo'].toString()) : Image.asset('images/avatar.jpg'),
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(_admin['name']),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(_admin['email']),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buttonAction(Icons.edit, _admin, context,
                    actionButton: 'update', index: index),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: buttonAction(Icons.delete, _admin, context),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonAction(icon, _admin, context, {actionButton, index}) {
    return InkWell(
      onTap: () {
        if (actionButton != null) {
                Get.toNamed(Routes.CONFIG_ADMIN,arguments: _admin);
        } else {
            defaultDialogDelete(_admin,context);
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
      title: "Excluir Administrado",
      textCancel: "Cancelar",
      middleText: "Desejar excluir o Administrado?",
      radius: 5,
      cancel: buttonActionDialogDestroy(Colors.black,'Cancelar', context,color: Colors.white),
      confirm: buttonActionDialogDestroy(Colors.white, "Confirmar",context,admin: _category),
    );
  }

  Widget buttonActionDialogDestroy(Color colorText,String text,context,{admin,color}){
    return  ElevatedButton(
      onPressed: () async{
        Get.back();
        if(admin != null){
          loadingDesk();
          var _response = await controller.destroy(admin['id'].toString());
          if(_response != true){
            dismiss();
            error(context, 'Administrado não pode ser removido');
            return;
          }

          controller.administrators.remove(admin);
          dismiss();
          success('Administrado removida com sucesso',context);
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
}
