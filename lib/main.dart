import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'package:my_project/screens/homepage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,

      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
