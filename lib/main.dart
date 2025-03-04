import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'database_helper.dart';
import 'main_page.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(MyApp());
  await DatabaseHelper().resetDatabase();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        showLoading = true;
      });
    });
    Timer(Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE5E5), // Warna background sesuai gambar
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/FloofyLogo.png', // Pastikan gambar ada di folder assets
              width: 260, // Sesuaikan ukuran sesuai kebutuhan
            ),
          ),

          if (showLoading)
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
