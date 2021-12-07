import 'package:get/get.dart';
import 'package:lustore/app/model/user.dart';

class ConfigController extends GetxController {

  User user = User();
  RxBool inLoading = true.obs;
  RxList administrators =  [].obs;


  @override
  void onInit() async {
    super.onInit();
    await adminList();
  }

  Future adminList() async{
    inLoading.value = true;
    List _response = await user.index();
    _response.forEach((element) {
      if(element['level'] == '5'){
        administrators.add(element);
      }
    });

    inLoading.value = false;
  }

  Future destroy(_id) async{
      return await user.destroy(_id.toString());
  }


}
