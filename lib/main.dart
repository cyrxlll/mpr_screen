import 'package:flutter/material.dart';
import 'package:mpr_screen/home_screen.dart';
import 'package:mpr_screen/login_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        'home_screen': (context) => HomeScreen(),
      },
    );
  }
}
