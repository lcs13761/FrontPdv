import 'package:lustore/app/model/auth.dart';

abstract class IApiAuth{

  Future<dynamic> login(Auth data);
  Future<dynamic> forget(Auth data);
  Future<dynamic> refreshJwt();
  Future<dynamic> logout();

}