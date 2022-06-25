import 'package:flutter/material.dart';
import 'package:kitago/view/home_view.dart';
import 'package:kitago/view/login_view.dart';
import 'package:kitago/view/register_view.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Login Register Page",
    initialRoute: "/",
    routes: {
      Home.routeName : (context) => Home(),
      '${Home.routeName}traveller' : (context) => Home(user: "traveller"),
      '${Home.routeName}agent' : (context) => Home(user: "agent"),
      LoginPage.routeName : (context) => LoginPage(),
      "${RegisterPage.routeName}/traveller" : (context) => RegisterPage(userType: "traveller"),
      "${RegisterPage.routeName}/agent" : (context) => RegisterPage(userType: "agent"),
    },
  ));
}