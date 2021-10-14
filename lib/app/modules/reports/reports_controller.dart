import 'package:get/get.dart';
import 'package:lustore/model/report.dart';
import 'package:lustore/model/sale.dart';


class ReportsController extends GetxController {
  Sale sale = Sale();
  Report report = Report();
  final bool animate = false;
  final RxList costValue = [].obs;
  RxList<OrdinalSales> data = <OrdinalSales>[].obs;
  RxList<ChartData> categorySales = <ChartData>[].obs;
  RxList<SalesProduct> salesProduct = <SalesProduct>[].obs;
  RxList<YearSales> yearSales = <YearSales>[].obs;
  Map monthSales = {};
  Map costMonth = {};

  @override
  void onInit() async {
    super.onInit();
    await salesAndCost();
    await getCategoriesAndProductsBestSelling();
    await salesYear();
  }

  salesAndCost() async {

    var resultGetSales = await report.getReportsSales();
    var resultGetCost = await report.getReportsCost();
    if (resultGetCost["result"].length == 0 || resultGetCost["result"].length == 0) {
      return;
    }
    monthSales = resultGetSales["result"];
    costMonth = resultGetCost["result"];

      monthSales.forEach((key, value) {
        data.add(OrdinalSales(key,double.parse(value.toString()),double.parse(costMonth[key].toString())));
      });

  }

  getCategoriesAndProductsBestSelling() async {

    var result = await report.getCategoriesAndProductsBestSelling();
    if(result["result"].length == 0){
      return;
    }

    Map categories = result["result"]["categories"];
    var orders = categories.entries.toList()..sort((a,b) => b.value.compareTo(a.value));
    categories..clear()..addEntries(orders);

    Map products = result["result"]["products"];
    orders = products.entries.toList()..sort((a,b) => b.value.compareTo(a.value));
    products..clear()..addEntries(orders);
    var i = 0;
    categories.forEach((key, value) {
       if(i < 5){
        categorySales.add(ChartData(key,value));
       }
       i++;
     });
     i = 0;
     products.forEach((key, value) {
       if(i < 5){
         salesProduct.add(SalesProduct(key, value));
       }
     });
  }

  salesYear() async{
      var listSales =  await report.annualProfit();
      if (listSales["result"].length == 0) {}
      Map yearList = listSales["result"];
      var yearMin = DateTime.now().year - 5;
      yearList.forEach((key, value) {
        if(int.parse(key) >= yearMin){
            yearSales.add(YearSales(key.toString(),double.parse(value.toString())));
        }
     });
  }
}

class YearSales{
  final String year;
  final double sales;

  YearSales(this.year,this.sales);
}

class ChartData {
  final String category;
  final int percentage;

  ChartData(this.category, this.percentage);
}
class SalesProduct{
    final String products;
    final int percentage;
    SalesProduct(this.products,this.percentage);

}

class OrdinalSales {
  final String year;
  final double sales;
  final double cost;

  OrdinalSales(this.year, this.sales, this.cost);
}
