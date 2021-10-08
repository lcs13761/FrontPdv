import 'dart:math';

import 'package:jaguar_jwt/jaguar_jwt.dart';

const String sharedSecret = 's3cr3t1s';

class Jwt {

  String senderCreatesJwt() {
    // Create a claim set
    final claimSet = JwtClaim(
      issuer: 'teja',
      subject: 'kleak',
      jwtId: _randomString(32),
      otherClaims: <String, dynamic>{
        "user": "admin",
        'typ': 'authnresponse',
      },
      maxAge: const Duration(minutes: 5),
    );

    final token = issueJwtHS256(claimSet, sharedSecret);
    return token;
  }
}



String _randomString(int length) {
  const chars =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  final rnd = Random(DateTime.now().millisecondsSinceEpoch);
  final buf = StringBuffer();

  for (var x = 0; x < length; x++) {
    buf.write(chars[rnd.nextInt(chars.length)]);
  }
  return buf.toString();
}
