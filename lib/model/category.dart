import 'package:lustore/app/api/api_categories.dart';

class Category extends ApiCategories{
    int? id;
    String? category;

  Category({this.id,this.category});

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