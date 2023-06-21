import 'package:alfread_demo/db_model.dart';
import 'package:alfread_demo/sevices/database_service.dart';
import 'package:alfread_demo/sevices/services.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends DBModel<User> {
  String email;
  late String password;
  String firstName;
  String lastName;

  User({required this.email, required this.firstName, required this.lastName})
      : super(database.users) {
    password = DBCrypt().hashpw('pass12345', DBCrypt().gensalt());
  }

  setPassword(String newPassword) {
    password = DBCrypt().hashpw(newPassword, DBCrypt().gensalt());
    print(password);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User fromJson(Map<String, dynamic> json) => User.fromJson(json);
}
