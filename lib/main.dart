import 'package:book/pages/addcard.dart';
import 'package:book/pages/bookdetail.dart';
import 'package:book/pages/buy.dart';
import 'package:book/pages/login.dart';
import 'package:book/pages/mainmenu.dart';
import 'package:book/pages/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookDD',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const SplashScreen(),
        '/': (context) => const MainMenu(),
        '/BookDetail': (context) => const BookDetail(),
        '/add': (context) => const AddPay(),
        '/profile': (context) => const Profile(),
        '/buy': (context) => const Buy()
      },
    );
  }
}
