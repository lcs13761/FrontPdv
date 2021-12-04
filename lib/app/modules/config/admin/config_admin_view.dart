import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
import 'package:lustore/app/theme/style.dart';

import 'config_admin_controller.dart';

class ConfigAdminView extends GetView<ConfigAdminController> {
  final _formKey = GlobalKey<FormState>();

  ConfigAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sidebar sidebar = Sidebar();
    return Scaffold(
      backgroundColor: backgroundColorDark,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          sidebar.side("config"),
          Expanded(child: Obx(() {
            if (controller.onLoadingFinalized.isFalse) {
              return const Center(
                child: CircularProgressIndicator(
                  color: styleColorBlue,
                ),
              );
            }
            return Form(
              key: _formKey,
              child: body(context),
            );
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
              child: Text(
                  controller.typeAction == 'create'
                      ? "Adicionar Administrado"
                      : "Editar Administrado",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ))),
          inputProduct("Nome*", controller.name, 'name', required: true),
          inputProduct("E-mail*", controller.email, 'email', required: true),
          inputProduct("Telefone Celular", controller.phone, 'phone'),
          passwordField("Senha", controller.password, 'phone'),
          passwordField("Confirmar Senha", controller.passwordConfirmation, 'phone'),
          const Text(
            "Endereço (Opicional)",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          inputProduct("CEP", controller.cep, 'cep'),
          inputProduct("Estado", controller.state, 'state'),
          inputProduct("Cidade", controller.city, 'city'),
          inputProduct("Bairro", controller.district, 'district'),
          inputProduct("Rua", controller.street, 'street'),
          inputProduct("Nº", controller.number, 'number'),
          inputProduct("Complemento", controller.complement, 'complement'),
          buttonSave(context)
        ],
        staggeredTiles: const [
          StaggeredTile.fit(2),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(2),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(2),
        ],
      ),
    );
  }

  Widget inputProduct(String text, type, key, {filter, required}) {
    return Container(
        margin: const EdgeInsets.only(right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (required == true) {
                  if (value == null || value.isEmpty) {
                    return "Preencha esse campo";
                  }
                  return null;
                }
              },
              decoration: InputDecoration(
                label: Text(
                  text,
                  style: const TextStyle(color: colorDark, fontSize: 16),
                ),
              ),
              controller: type,
              inputFormatters: filter,
            ),
// Obx(() {
//   // if (controller.errors.containsKey(key)) {
//     return Container(
//       margin: const EdgeInsets.only(),
//       child: Text('',
//         // controller.errors[key][0].toString(),
//         style: const TextStyle(color: Colors.red),
//       ),
//     );
//   // }
//   return const Text('');
// }),
          ],
        ));
  }

  Widget passwordField(String text, controllerName, key) {

    return Obx(() {
      if (controller.typeAction.value == "create") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 30),
              child: Obx(
                () => TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Preencha esse campo";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: controller.visiblePassword[key] ? false : true,
                  autocorrect: false,
                  enableSuggestions: true,
                  controller: controllerName,
                  style: const TextStyle(color: colorDark),
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        if (controller.visiblePassword[key] == true) {
                          controller.visiblePassword[key] = false;
                        } else {
                          controller.visiblePassword[key] = true;
                        }
                      },
                      child: controller.visiblePassword[key]
                          ? hiddenPasswordDark
                          : showPasswordDark,
                    ),
                    label: Text(
                      text,
                      style: const TextStyle(color: colorDark, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() {
              if (controller.errors.containsKey('errors') &&
                  controller.errors['errors'].toString().contains(key) &&
                  controller.errors['errors'][key] != null) {
                return Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5, left: 15),
                  child: Text(
                    controller.errors['errors'][key][0].toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return const Text('');
            }),
          ],
        );
      }
      return const Text('');
    });
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {}
                // loadingDesk();
                // var _response = await controller.submitTypeAction();
                //
                // await 1.delay();
                // Get.back();
                // if (_response == true) {
                //   success("sucesso", context, route: Routes.PRODUCTS);
                // } else {
                //   controller.errors.clear();
                //   controller.errors.addAll(_response);
                // }
                // dismiss();
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
                  // Get.offAllNamed(Routes.PRODUCTS);
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
