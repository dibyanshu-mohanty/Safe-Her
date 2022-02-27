import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:safe_her/providers/help_provider.dart';
import 'package:safe_her/providers/location_provider.dart';
import 'package:safe_her/screens/auth_screen.dart';
import 'package:safe_her/screens/home_screen.dart';
import 'package:safe_her/screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final Future<FirebaseApp> _initialization = Firebase.initializeApp();

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: SpinKitDoubleBounce(color: Colors.yellow,));
        }
        if(snapshot.connectionState == ConnectionState.done){
          return  MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => ContactProvider()),
              ChangeNotifierProvider(create: (context) => Locations()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SafeHer',
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                fontFamily: "Montserrat",
              ),
              home: SplashScreen(),
            ),
          );
        } else {
          return Center(child: Text("Something Went Wrong"),);
        }
      },
    );
  }
}
