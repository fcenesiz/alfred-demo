import 'package:alfread_demo/modules/user.dart';
import 'package:alfred/alfred.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:dbcrypt/dbcrypt.dart';

import '../sevices/services.dart';

class UsersRoute {

  static currentUser(HttpRequest req, HttpResponse res) async{
    final userToken = req.store.get('token') as JWT;

    if(userToken != null){
      final data = userToken.getClaim('data') as Map;
      final userEmail = data['email'];
      final foundUser = await services.users.findUserByEmail(email: userEmail);
      if(foundUser != null){
        return foundUser;
      }else{
        throw AlfredException(401, {"message": "user not found"});
      }
    }

  }

  static login(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final user = await services.users.findUserByEmail(email: body['email']);

    if (user == null) {
      throw AlfredException(401, {'message', 'Invalid user'});
    }

    // validate username & password
    try {
      final isCorrect = DBCrypt().checkpw(body['password'], user.password);
      if (isCorrect == false) {
        throw AlfredException(401, {'message', 'Invalid password'});
      }

      // generate a jwt
      var token = JWTBuilder()
        ..issuer = 'https://api.alfreaddemo.com'
        ..expiresAt = DateTime.now().add(Duration(hours: 3))
        ..setClaim('data', {'email': user.email})
        ..getToken();

      var signedToken = token.getSignedToken(services.jwtSigner);

      return {'token': signedToken.toString()};
    } catch (e) {
      throw AlfredException(401, {'message': 'Invaild salt version'});
    }
  }

  static createAccount(HttpRequest req, HttpResponse res) async{
    final body = await req.bodyAsJsonMap;
    final newUser = User.fromJson(body)
      ..setPassword(body['password']);
    await newUser.save();
    return newUser;
  }
  
}
