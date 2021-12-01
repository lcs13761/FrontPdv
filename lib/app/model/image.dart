

class ImageController {
  int? id;
  String? image;

  ImageController({this.id,this.image});

  ImageController.fromJson(Map<String,dynamic> json):
        id = json["id"],
        image = json["image"];

  Map<String,dynamic> toJson(){
    return {
      "id" : id,
      "image" : image,
    };
  }
}