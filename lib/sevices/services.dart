import 'package:alfread_demo/sevices/database_service.dart';
import 'package:alfread_demo/sevices/users_service.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:get_it/get_it.dart';

const _JWT_SECRET = 'Q3A9K830AQ0K128C19C1H98A512';

class Services {
  UsersService users = UsersService();

  final jwtSigner = JWTHmacSha256Signer(_JWT_SECRET);

  Services();

}

Services get services => GetIt.instance.get<Services>();
