import 'package:get/get.dart';
import 'package:lustore/app/api/api_historic_sales.dart';
import 'package:lustore/model/product.dart';
import 'package:lustore/model/sale.dart';


class ReportsController extends GetxController {
  Sale sale = Sale();
  Product product = Product();
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
    var getAllSales = await ApiHistoricSales().getSalesYear();
    await calcSales(getAllSales);
    await categoryMoreSales(getAllSales);
    await salesYear();
  }

  calcSales(getAllSales) async {

    var getCost = await product.getCost();

    if (getCost["result"] == null) {}
    if (getAllSales["result"] == null) {}
    var getSales = getAllSales["result"];
    getCost = getCost["result"];

    for (int i = 0; i < getSales.length; i++) {

      var month = DateTime.parse(getSales[i]["created_at"]).month;

      var value =  double.parse((getSales[i]["saleValue"] * getSales[i]["qts"]).toString());
      salesAndCost("sales", "janeiro", month,1,value);
      salesAndCost("sales", "fevereiro", month,2, value);
      salesAndCost("sales", "março", month,3,value);
      salesAndCost("sales", "abril", month,4, value);
      salesAndCost("sales", "maio", month,5,value);
      salesAndCost("sales", "junho", month,6,value);
      salesAndCost("sales", "julho", month,7, value);
      salesAndCost("sales", "agosto", month,8, value);
      salesAndCost("sales", "setembro",month, 9, value);
      salesAndCost("sales", "outubro", month,10, value);
      salesAndCost("sales", "novembro", month,11, value);
      salesAndCost("sales", "dezembro", month,12, value);
    }
    for (int i = 0; i < getCost.length; i++) {

      var monthCost = DateTime.parse(getCost[i]["created_at"]).month;
      var costVl = double.parse( getCost[i]["value"].toString());
      salesAndCost("cost", "janeiro", monthCost,1,costVl);
      salesAndCost("cost", "fevereiro", monthCost,2, costVl);
      salesAndCost("cost", "março", monthCost,3,costVl);
      salesAndCost("cost", "abril", monthCost,4, costVl);
      salesAndCost("cost", "maio", monthCost,5, costVl);
      salesAndCost("cost", "junho", monthCost,6, costVl);
      salesAndCost("cost", "julho", monthCost,7,costVl);
      salesAndCost("cost", "agosto", monthCost,8, costVl);
      salesAndCost("cost", "setembro",monthCost, 9, costVl);
      salesAndCost("cost", "outubro", monthCost,10,costVl);
      salesAndCost("cost", "novembro", monthCost,11,costVl);
      salesAndCost("cost", "dezembro", monthCost,12, costVl);
    }
      monthSales.forEach((key, value) {
        data.add(OrdinalSales(key,value,costMonth[key]));
      });

  }

  salesAndCost(type, String monthText,month, int numberMonth, valueCalc) {
    if ((type != "cost" && monthSales[monthText] == null)  &&  DateTime.now().month >= numberMonth) monthSales[monthText] = 0.0;
    if ((type != "sales" && costMonth[monthText] == null) &&  DateTime.now().month >= numberMonth) costMonth[monthText] = 0.0;
    if (month == numberMonth && DateTime.now().month >= numberMonth) {

      type != "cost" ? (monthSales[monthText] += valueCalc): (costMonth[monthText] += valueCalc);

    }

  }

  categoryMoreSales(getAllSales) async {
    if (getAllSales["result"] == null) {}
    List getSales = getAllSales["result"];
    Map categories = {};
    Map products = {};
    int allQts = 0;

    for(var i=0;i < getSales.length; i++){

      if(categories[getSales[i]["category"]] == null){
        categories[getSales[i]["category"]] = 0;
      }
      if(products[getSales[i]["product"]] == null){
        products[getSales[i]["product"]] = 0;
      }

      allQts += getSales[i]["qts"] as int;
      categories[getSales[i]["category"]] += getSales[i]["qts"];
      products[getSales[i]["product"]] += getSales[i]["qts"];

    }
    categories.forEach((key, value) {
        categories[key] = ((value/allQts)*100).round();
    });

    products.forEach((key, value) {

      products[key] = ((value/allQts)*100).round();
    });
    var orders = categories.entries.toList()..sort((a,b) => b.value.compareTo(a.value));
    categories..clear()..addEntries(orders);
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
      var listSales =  await ApiHistoricSales().getHistoric();
      if (listSales["result"] == null) {}
      List salesListYear = listSales["result"];
      Map yearList = {};
      for(var i = 0 ; i < salesListYear.length; i++){

        var year = DateTime.parse(salesListYear[i]["created_at"]).year;
            if(yearList[year] == null){
              yearList[year] = 0.0;
            }

            yearList[year] += double.parse((salesListYear[i]["saleValue"] * salesListYear[i]["qts"]).toString());
      }
      var yearMin = DateTime.now().year - 5;
     yearList.forEach((key, value) {
        if(key >= yearMin){
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
