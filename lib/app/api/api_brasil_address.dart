import 'package:http/http.dart' as http;
import 'dart:convert';

Future addressApiBrazil(String cep) async{

  final response = await http.get(
    Uri.parse('https://brasilapi.com.br/api/cep/v2/' + cep),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return false;
  }

}