import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../sidebar/sidebar.dart';
import 'historic_sales_controller.dart';

class HistoricSalesView extends GetView<HistoricSalesController> {
  const HistoricSalesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sidebar sidebar = Sidebar();
    return Scaffold(
      backgroundColor: Color.fromRGBO(204, 204, 204, 1),
      body: Row(
        children: <Widget>[
          sidebar.side("historic"),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
