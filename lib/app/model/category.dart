import 'package:lustore/app/api/model.dart';

class Category extends Model{

  int? id;
  String? category;

  Category({this.id,this.category}){
    actionApi('category');
  }

  Category.fromJson(Map<String,dynamic> json):
        id = json["id"],
        category = json["category"];

  Map<String,dynamic> toJson(){
    return {
      "id" : id,
      "category" : category,
    };
  }
}