import 'package:lustore/model/user.dart';

abstract class IApiUser{

  Future<dynamic> login(User data);
  Future<dynamic> forget(User data);
  Future<dynamic> refreshJwt();
  Future<dynamic> logout();

}