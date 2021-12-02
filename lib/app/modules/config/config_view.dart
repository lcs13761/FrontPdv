import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
import '../../sidebar/sidebar.dart';
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
            child: Container(),
          ),
        ],
      ),
    );
  }
}
