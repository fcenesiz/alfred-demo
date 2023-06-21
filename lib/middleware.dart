import 'dart:io';

import 'package:alfread_demo/sevices/services.dart';
import 'package:alfred/alfred.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

class Middleware{

  static isAuthenticated(HttpRequest req, HttpResponse res){
    final authHeader = req.headers.value("Authorization");
    if(authHeader != null){
      final token = authHeader.replaceAll("Bearer", "");
      if(token.isNotEmpty){
        final parsedToken = JWT.parse(token);
        final isValid = parsedToken.verify(services.jwtSigner);

        if(isValid == false){
          throw AlfredException(401, {"message":"invalid token"});
        }

        req.store.set("token", parsedToken);

      }else{
        throw AlfredException(401, {"message": "no token provided"});
      }
    }else{
      throw AlfredException(401, {"message" : "no auth header provided"});
    }
  }

}