import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lustore/app/modules/sidebar/sidebar.dart';
import 'reports_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sidebar sidebar = Sidebar();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Row(
        children: <Widget>[
          sidebar.side("reports"),
          Expanded(
            child: bodyReports(),
          )
        ],
      ),
    );
  }

  Widget bodyReports() {
    return StaggeredGridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.all(4),
      children: <Widget>[
        monthlyMoney(),
        categoriesSales(),
        productSales(),
        yearMoney(),
      ],
      staggeredTiles: const [
        StaggeredTile.count(4, 1),
        StaggeredTile.count(2, 1.3),
        StaggeredTile.count(2, 1.3),
        StaggeredTile.count(4, 1),
      ],
    );
  }

  Widget monthlyMoney() {
    return Obx(() {
      return SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.simpleCurrency(locale: "pt-BR")),
          title: ChartTitle(
              text: "Estatistica Mensal " + DateTime.now().year.toString()),
          legend: Legend(isVisible: true),
          backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
          enableAxisAnimation: true,
          borderWidth: 1,
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<dynamic, String>>[
            ColumnSeries<dynamic, String>(
                width: 0.5,
                spacing: 0.2,
                dataSource: controller.data.toList(),
                xValueMapper: (dynamic sales, _) => sales.year,
                yValueMapper: (dynamic sales, _) => sales.cost,
                name: 'custo do mês',
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
            ColumnSeries<dynamic, String>(
                width: 0.5,
                spacing: 0.2,
                dataSource: controller.data.toList(),
                xValueMapper: (dynamic sales, _) => sales.year,
                yValueMapper: (dynamic sales, _) => sales.sales,
                name: 'vendas do mês',
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
    });
  }

  Widget yearMoney() {
    return Obx(() {
      return SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.simpleCurrency(locale: "pt-BR")),
          title: ChartTitle(text: "Estatistica Anual"),
          legend: Legend(isVisible: true),
          backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
          enableAxisAnimation: true,
          borderWidth: 1,
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<dynamic, String>>[
            ColumnSeries<dynamic, String>(
              width: 0.5,
              spacing: 0.2,
              dataSource: controller.yearSales.toList(),
              xValueMapper: (dynamic sales, _) => sales.year,
              yValueMapper: (dynamic sales, _) => sales.sales,
              name: 'custo do mês',
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ]);
    });
  }

  Widget categoriesSales() {
    return Obx(
      () => SfCircularChart(
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
        title: ChartTitle(text: "Porcentagem das categorias com mais venda"),
        tooltipBehavior: TooltipBehavior(enable: true),

        legend: Legend(
            isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
            enableTooltip: true,
            emptyPointSettings: EmptyPointSettings(
                mode: EmptyPointMode.average,
                borderColor: Colors.black,
                borderWidth: 10),
            dataSource: controller.categorySales.toList(),
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.percentage,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            radius: '100%',
            dataLabelMapper: (datum, index) =>
                datum.percentage.toString() + "%",
          ),
        ],
      ),
    );
  }

  Widget productSales() {
    return Obx(
      () => SfPyramidChart(
        legend: Legend(isVisible: true),
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
        title: ChartTitle(text: "Produtos mais vendidos"),
        tooltipBehavior: TooltipBehavior(enable: true),

        series: PyramidSeries<SalesProduct, String>(

          dataSource: controller.salesProduct.toList(),
          xValueMapper: (SalesProduct data, _) => data.products,
          yValueMapper: (SalesProduct data, _) => data.percentage,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          textFieldMapper: (datum, index) =>
              datum.percentage.toString() + "%",
        ),
      ),
    );
  }
}
