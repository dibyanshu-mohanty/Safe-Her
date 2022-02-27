import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:safe_her/providers/help_provider.dart';
import 'package:safe_her/providers/location_provider.dart';
import 'package:safe_her/screens/help_screen.dart';
import 'package:safe_her/screens/live_loc_screen.dart';
import 'package:safe_her/screens/map_screen.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:safe_her/utils/sos_button.dart';
import 'package:safe_her/utils/voice_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset("assets/images/main_screen_bg.png",fit: BoxFit.cover,),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(user!.photoURL.toString()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 6),
                      child: Text("Hi, ${user!.displayName}",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.white),),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Your Current Location ",style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w400,color: Colors.white),),
                    Row(
                      children: [
                        FutureBuilder(
                          future: Provider.of<Locations>(context, listen: false)
                              .setLocation(context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SpinKitPianoWave(
                                  color: Colors.black,
                                  size: 20.0,
                                );
                              }
                              return Consumer<Locations>(
                                  builder: (context, value, child) =>
                                      Text(value.location, style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold),)
                              );
                            }
                        ),
                        SizedBox(width: 5.0,),
                        IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
                        }, icon: FaIcon(FontAwesomeIcons.map)),
                      ],
                    ),
                  ],
                ),
                Consumer<ContactProvider>(
                    builder: (context,contact,ch) {
                      return VoiceButton(contact: contact,);
                    }
                ),
                SOSButton(),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PeopleScreen()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey,width: 2.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            children: [
                              Icon(Icons.person_add,size: 30.0,),
                              Text("Add Saviours",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LiveLocCard()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey,width: 2.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            children: [
                              Icon(Icons.location_pin,size: 30.0,),
                              Text("Live Tracking",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
