import 'package:flutter/material.dart';
import 'home.dart';
import 'package:rhy_basis/rhy_basis.dart';
import 'custom/MyNetWork.dart';
void main()async{
  await baseConfig.initDataBase('example.db', 1);


  baseConfig.initNetWork(MyNetWork());

  runApp(MyApp());

}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
