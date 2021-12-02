

class Address{

  int? id;
  String? cep;
  String? city;
  String? state;
  String? district;
  String? street;
  int? number;
  String? complement;


  Address();

  Address.fromJson(Map<String,dynamic> json):
        id = json['id'],
        cep = json["cep"],
        city = json["city"],
        state = json['state'],
        district = json['district'],
        street = json['street'],
        number = json['number'],
        complement = json['complement'];


  Map<String,dynamic> toJson(){
    return {
      'id' : id,
      "cep" : cep,
      "city" : city,
      'state' : state,
      'district' : district,
      'street' : street,
      'number' : number,
      'complement' : complement
    };
  }

}