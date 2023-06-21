import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService{

  final Db _db;
  DbCollection get users => _db.collection('users');

  DatabaseService({required Db db}) : _db = db;

  Future open() async => _db.open();

  Future close() async => _db.close();

}

DatabaseService get database => GetIt.instance.get<DatabaseService>();