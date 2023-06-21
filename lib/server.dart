
import 'dart:io';

import 'package:alfread_demo/middleware.dart';
import 'package:alfread_demo/routes/users_route.dart';
import 'package:alfred/alfred.dart';

class Server {
  final app = Alfred();

  Future<void> start({int port = 3000}) async {
    app.get('/users/currentUser', UsersRoute.currentUser, middleware: [
      Middleware.isAuthenticated
    ]);
    app.post('/users/login', UsersRoute.login);
    app.post('/users/createAccount', UsersRoute.createAccount);



    await app.listen(port);
  }

  Future<void> stop() async {
    await app.close();
  }



}
