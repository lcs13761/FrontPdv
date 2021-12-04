import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'config_change_password_controller.dart';

class ConfigChangePasswordView extends GetView<ConfigChangePasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ConfigChangePasswordView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ConfigChangePasswordView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
