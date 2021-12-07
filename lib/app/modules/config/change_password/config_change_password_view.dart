import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
import 'package:lustore/app/routes/app_pages.dart';
import 'package:lustore/app/theme/style.dart';

import 'config_change_password_controller.dart';

class ConfigChangePasswordView extends GetView<ConfigChangePasswordController> {
  final _formKey = GlobalKey<FormState>();

  ConfigChangePasswordView({Key? key}) : super(key: key);

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
          Expanded(
            child: Form(
              key: _formKey,
              child: body(context),
            ),
          ),
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
              child: const Text("Modificar Senha",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ))),
          passwordField(
              "Senha Atual", controller.currentPassword, 'current_password'),
          passwordField("Nova Senha", controller.password, 'password'),
          passwordField("Confirmar Senha", controller.passwordConfirmation,
              'password_confirmation'),
          buttonSave(context)
        ],
        staggeredTiles: const [
          StaggeredTile.fit(2),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(2),
        ],
      ),
    );
  }

  Widget passwordField(String text, controllerName, key) {
    if (!controller.visiblePassword.containsKey(key)) {
      controller.visiblePassword[key] = false;
    }
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
                  if (key == 'password_confirmation') {
                    return validatePassword(value);
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
              return Text(
                controller.errors['errors'][key][0].toString(),
                style: const TextStyle(color: Colors.red),
              );
            }
            return const Text('');
          }),
        ]);
  }

  dynamic validatePassword(_value) {
    if (controller.password.text != _value) {
      return 'As senhas não coincidem';
    }
    return null;
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
                if (_formKey.currentState!.validate()) {
                  loadingDesk();
                  var _response = await controller.change();
                  await 1.delay();
                  if (_response == true) {
                    success("sucesso", context, route: Routes.CONFIG);
                    dismiss();
                  } else {
                    controller.errors.clear();
                    controller.errors.addAll(_response);
                    dismiss();
                  }
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
