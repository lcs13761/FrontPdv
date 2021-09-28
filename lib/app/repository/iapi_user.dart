
abstract class IApiUser{

  Future<dynamic> login();
  Future<dynamic> refreshJwt();
  Future<dynamic> logout();

}