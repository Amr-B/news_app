import 'package:flutter/material.dart';
import 'package:news_app/news/news_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter news',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black,
          elevation: 0,
          surfaceTintColor: Colors.white,
        ),
      ),
      home: NewsHome(),
    );
  }
}
