import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_her/screens/auth_screen.dart';
import 'package:safe_her/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context){
              if(user !=null){
                return HomeScreen();
              }
              else {
                return AuthScreen();
              }
          })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Center(child: Image.asset("assets/images/main_logo.png",fit: BoxFit.cover,)),
      ),
    );
  }
}
