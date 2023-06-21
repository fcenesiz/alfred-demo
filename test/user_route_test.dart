import 'dart:convert';
import 'dart:io';

import 'package:alfread_demo/server.dart';
import 'package:alfread_demo/sevices/database_service.dart';
import 'package:alfread_demo/sevices/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() async {
  var server = Server();

  setUp(() async {
    final db = await Db.create(
        "mongodb+srv://ahmetfatihcenesiz:kC76dF5aV7ROdory@alfred-demo.lmwgdc8.mongodb.net/testdb?retryWrites=true&w=majority");
    GetIt.instance.registerSingleton(DatabaseService(db: db));
    await database.open();
    GetIt.instance.registerSingleton(Services());
    final envPort = Platform.environment['PORT'];
    await server.start(port: envPort != null ? int.parse(envPort) : 3000);
  });

  tearDown(() async{
    await database.close();
    GetIt.instance.unregister<DatabaseService>();
    GetIt.instance.unregister<Services>();
    server.stop();
  });

  test('it should login a user', () async {
    final response = await http.post(
        Uri.parse('http://localhost:3000/users/login'),
        body: {'email': 'test@email.com', 'password': 'pass12345'});
    final data = jsonDecode(response.body);
    expect(data['token'] != null, true);
  });

  test('it should get the current user', () async {
    final loginResponse = await http.post(
        Uri.parse('http://localhost:3000/users/login'),
        body: {'email': 'test@email.com', 'password': 'pass12345'});

    final loginData = jsonDecode(loginResponse.body);
    final token = loginData['token'];

    final response = await http
        .get(Uri.parse("http://localhost:3000/users/currentUser"), headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      "Authorization": "Bearer$token"
    });

    expect(response.statusCode, 200);
  });

  test('it should create account', () async {
    final createResponse = await http
        .post(Uri.parse('http://localhost:3000/users/createAccount'), body: {
      "firstName": "Test1",
      "lastName": "",
      "email": "test@email.com",
      "password": "pass12345"
    });
    print(createResponse.body);
    expect(createResponse.statusCode, 200);
  });
}
