import 'package:flutter/material.dart';
import 'SplashScreen/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Beranda/beranda.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
