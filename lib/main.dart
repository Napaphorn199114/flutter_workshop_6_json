import 'package:flutter/material.dart';
import 'package:workshop_6_json/home.dart';
import 'package:workshop_6_json/login.dart';
import 'package:workshop_6_json/services/AuthService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthService authService = AuthService();

  Widget page = Login();

  final _route = <String, WidgetBuilder>{
    '/login': (context) => Login(),
    '/home': (context) => Home(),
  };
  if(await authService.isLogin()){
      page = Home();   // ถ้า login แล้วให้ไปที่หน้า Home

  }
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "JSON",
      home: page,   //page = Home()
      routes: _route,
    ),);

}


