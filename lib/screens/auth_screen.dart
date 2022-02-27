import 'package:flutter/material.dart';
import 'package:safe_her/utils/sign_in_btn.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text("Welcome to",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w600),),
                Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    child: Image.asset("assets/images/main_logo.png",fit: BoxFit.cover,)),
              ],
            ),
            SizedBox(height: 10.0,),
            GoogleSignInButton(),
          ],
        ),
      ),
    );
  }
}
