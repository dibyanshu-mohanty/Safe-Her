import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe_her/providers/auth_provider.dart';
import 'package:safe_her/screens/home_screen.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator()
          : OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0)),
        ),
        onPressed: () async {
          setState(() {
            _isSigningIn = true;
          });
          User? user = await Authentication.signInwithGoogle(context: context).catchError((onError){
            CoolAlert.show(
              context : context,
              type: CoolAlertType.error,
              text: "Please Select a Google Account",
            );
          });
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),);
          setState(() {
            _isSigningIn =false;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.google,
              color: Colors.black,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              "Sign In with Google",
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            )
          ],
        ),
      ),
    );
  }
}