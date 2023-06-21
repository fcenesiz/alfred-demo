import '../modules/user.dart';

class UsersService {
  final _users = <User>[
    User(email: 'test@email.com', firstName: "Ahmet", lastName: "Çenesiz")
  ];

  Future<User?> findUserByEmail({required email}) async {
    return _users.firstWhere((user) => user.email == email);
  }
}
