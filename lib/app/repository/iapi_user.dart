
abstract class IApiUser{

  Future<dynamic> loginAdmin();
  Future<dynamic> refreshJwt();
  Future<dynamic> logout();

}