import 'package:rhy_basis/rhy_basis.dart';
part 'user.jser.dart';

class UserBean{
  int id;
  String username;
  String password;
  String address;
  int age;
  String phone;
  String email;
}

class UserProvider extends RhyBasisProvider<UserBean,UserSerializer>{
  static const String columnUsername='username';
  static const String columnPassword='password';
  static const String columnAge='age';
  static const String columnPhone='phone';
  static const String columnEmail='email';
  static const String columnAddress='address';

  @override
  String get createTable => '''create table IF NO EXISTS $tableName(
  $columnId integer primary key autoincrement,
  $columnUsername text,
  $columnPassword text,
  $columnPhone text,
  $columnEmail text,
  $columnAddress text,
  $columnAge integer)''';

  @override
  Serializer<UserBean> get serializer => UserSerializer();

}

//  run "flutter packages pub run build_runner build" in the terminal.
//  or watch file run "flutter packages pub run build_runner watch" in the terminal
//  add "part 'user.jser.dart'" in this file.
@GenSerializer()
class UserSerializer extends Serializer<UserBean> with _$UserSerializer {
}