import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
import 'package:lustore/app/routes/app_pages.dart';
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
                  controller.typeAction.value == 'create'
                      ? "Adicionar Administrado"
                      : "Editar Administrado",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ))),
          inputForm("Nome*", controller.name, 'name', required: true),
          inputForm("E-mail*", controller.email, 'email', required: true),
          inputForm("Telefone Celular", controller.phone, 'phone'),
          passwordField("Senha", controller.password, 'password'),
          passwordField("Confirmar Senha", controller.passwordConfirmation,
              'password_confirmation'),
          const Text(
            "Endereço (Opicional)",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          inputForm("CEP", controller.cep, 'cep'),
          inputForm("Estado", controller.state, 'state'),
          inputForm("Cidade", controller.city, 'city'),
          inputForm("Bairro", controller.district, 'district'),
          inputForm("Rua", controller.street, 'street'),
          inputForm("Nº", controller.number, 'number'),
          inputForm("Complemento", controller.complement, 'complement'),
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

  Widget inputForm(String text, type, key, {filter, required}) {
    return Container(
        margin: const EdgeInsets.only(right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              onChanged: (value) {
                if (key == 'cep') controller.apiCompleteAddress(value);
              },
              validator: (value) {
                if (required == true) {
                  if (value == null || value.isEmpty) {
                    return "Preencha esse campo";
                  }
                  if(key == 'email'){
                   return emailValidation(value);
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

  dynamic emailValidation(_value){
    bool _emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_value);
    if(!_emailValid){
      return "Email inválido";
    }

    return null;
  }

  Widget passwordField(String text, controllerName, key) {
    if (!controller.visiblePassword.containsKey(key)) {
      controller.visiblePassword[key] = false;
    }

    return Obx(() {
      if (controller.typeAction.value == "create") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 30),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Preencha esse campo";
                  }
                  if(key == 'password_confirmation'){
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

 dynamic validatePassword(_value){
    if(controller.password.text != _value){
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
                  var _response = await controller.actionUser();
                  print(_response);
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
