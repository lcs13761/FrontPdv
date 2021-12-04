import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lustore/app/api/api_brasil_address.dart';
import 'package:lustore/app/model/address.dart';
import 'package:lustore/app/model/user.dart';

class ConfigAdminController extends GetxController {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController cep = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController complement = TextEditingController();
  TextEditingController passwordConfirmation = TextEditingController();
  TextEditingController asdfsadf = TextEditingController();
  Address address = Address();
  User user = User();
  int id = 0;
  int addressId = 0;
  RxBool onLoadingFinalized = false.obs;
  RxString typeAction = "create".obs;
  RxMap errors = {}.obs;
  RxMap visiblePassword = {}.obs;


  @override
  void onInit() async {
    super.onInit();
    if(Get.arguments != null){
      typeAction.value = "update";
      updateType(Get.arguments);
    }
    onLoadingFinalized.value = true;
  }

  updateType(_admin){
    name.text = _admin['name'];
    email.text = _admin['email'];
    phone.text = _admin['phone'] ?? '';
    if(_admin['address'].isNotEmpty){
      addressId = _admin['address'][0]['id'];
      cep.text = _admin['address'][0]['cep'];
      city.text = _admin['address'][0]['city'];
      state.text = _admin['address'][0]['state'];
      district.text = _admin['address'][0]['street'];
      street.text = _admin['address'][0]['cep'];
      number.text = _admin['address'][0]['number'].toString();
      complement.text = _admin['address'][0]['complement'] ?? '';
    }
  }

  Future updateUser() async{

    user.name = name.text;
    user.email = email.text;
    user.phone = phone.text;

    if(cep.text.isNotEmpty){
      address.id = addressId > 0 ? addressId : null;
      address.cep = cep.text;
      address.city = city.text;
      address.state = state.text;
      address.district = district.text;
      address.street = street.text;
      address.number = int.tryParse(number.text);
      address.complement = complement.text;
      user.address = address;
    }else{
      user.address = null;
    }

    return await user.update(user, id);

  }

  Future apiCompleteAddress(String _value) async{

    if(_value.toString().contains('-')){
      _value = _value.toString().replaceAll('-', '');
    }

    if(_value.length != 8) return;

    var _response = await addressApiBrazil(_value);
    if(_response == false) return;
    state.text = _response['state'];
    city.text = _response['city'];
    district.text = _response['neighborhood'];
    street.text = _response['street'];

  }
}
