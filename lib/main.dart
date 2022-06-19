import 'package:flutter/material.dart';
import 'package:github_users/pages/home/home.page.dart';
import 'package:github_users/pages/users/users.pages.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/":(context)=>HomePage(),
        "/users":(context)=>UsersPage()
      },
      initialRoute: "/users",
    );
  }
  
}


