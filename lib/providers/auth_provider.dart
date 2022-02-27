
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static Future<User?> signInwithGoogle({required BuildContext context}) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if(googleSignInAccount != null){
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try{
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);
        user = userCredential.user;
        assert(!user!.isAnonymous);
        assert(user !=null);
        await FirebaseFirestore.instance.collection('user').doc(user?.uid).set({
          "username" : user?.displayName,
        });
      } on FirebaseAuthException catch(e){
        if (e.code == 'account-exists-with-different-credential') {
          CoolAlert.show(
            context : context,
            type: CoolAlertType.error,
            text: "Account Already Exists with Same Google Id",
          );
        }
        else if (e.code == 'invalid-credential') {
          CoolAlert.show(
            context : context,
            type: CoolAlertType.error,
            text: "Oops Something Went Wrong !",
          );
        }
      } catch (e) {
        CoolAlert.show(
          context : context,
          type: CoolAlertType.error,
          text: "Error 404 ! 😕",
        );
      }
    }
  }
}