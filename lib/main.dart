import 'dart:async';
import 'dart:io';

import 'package:alfread_demo/server.dart';
import 'package:alfread_demo/sevices/database_service.dart';
import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'sevices/services.dart';

// pass: kC76dF5aV7ROdory

void main() async {
  final db = await Db.create(
      "mongodb+srv://ahmetfatihcenesiz:kC76dF5aV7ROdory@alfred-demo.lmwgdc8.mongodb.net/alfred-demo?retryWrites=true&w=majority");
  GetIt.instance.registerSingleton(DatabaseService(db: db));
  GetIt.instance.registerSingleton<Services>(Services());
  await database.open();

  final server = Server();
  final envPort = Platform.environment['PORT'];
  await server.start(port: envPort != null ? int.parse(envPort) : 3000);
}
