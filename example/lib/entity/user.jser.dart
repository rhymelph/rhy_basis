// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserSerializer implements Serializer<UserBean> {
  @override
  Map<String, dynamic> toMap(UserBean model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'username', model.username);
    setMapValue(ret, 'password', model.password);
    setMapValue(ret, 'address', model.address);
    setMapValue(ret, 'age', model.age);
    setMapValue(ret, 'phone', model.phone);
    setMapValue(ret, 'email', model.email);
    return ret;
  }

  @override
  UserBean fromMap(Map map) {
    if (map == null) return null;
    final obj = new UserBean();
    obj.id = map['id'] as int;
    obj.username = map['username'] as String;
    obj.password = map['password'] as String;
    obj.address = map['address'] as String;
    obj.age = map['age'] as int;
    obj.phone = map['phone'] as String;
    obj.email = map['email'] as String;
    return obj;
  }
}
