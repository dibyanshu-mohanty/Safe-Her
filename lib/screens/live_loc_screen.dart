import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_her/providers/location_provider.dart';
import 'package:safe_her/providers/set_status.dart';
import 'package:safe_her/screens/g_map_screen.dart';
import 'package:share_plus/share_plus.dart';

final kInputDecoration = InputDecoration(
    labelText: "Add the unique User ID",
    labelStyle: TextStyle(color: Colors.purple.withOpacity(0.5)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide(color: Colors.purple)),
    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.purple)));

class LiveLocCard extends StatefulWidget {
  static const routeName = "/LiveLocCard";
  LiveLocCard({Key? key}) : super(key: key);

  @override
  State<LiveLocCard> createState() => _LiveLocCardState();
}

class _LiveLocCardState extends State<LiveLocCard> {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  bool status = false;

  Future<bool> setLocPref() async {
    DocumentSnapshot _docSnap = await FirebaseFirestore.instance
        .collection("locPreference")
        .doc(userID)
        .get();
    bool _status = (_docSnap.data() as Map<String, dynamic>)["status"];
    return _status;
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('location');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    setLocPref().then((value) {
      setState(() {
        status = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = userID;
    final locData = Provider.of<Locations>(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Set your location status",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: FlutterSwitch(
                    width: 80.0,
                    height: 45.0,
                    valueFontSize: 16.0,
                    toggleSize: 35.0,
                    inactiveIcon: Icon(
                      Icons.location_off,
                      color: Colors.white,
                    ),
                    inactiveColor: Colors.white30,
                    inactiveTextColor: Colors.black,
                    inactiveToggleColor: Colors.redAccent,
                    inactiveSwitchBorder: Border.all(color: Colors.redAccent),
                    activeIcon: Icon(
                      Icons.location_pin,
                      color: Colors.white,
                    ),
                    activeColor: Colors.white30,
                    activeTextColor: Colors.black,
                    activeSwitchBorder: Border.all(color: Colors.green),
                    activeToggleColor: Colors.green,
                    value: status,
                    borderRadius: 30.0,
                    padding: 8.0,
                    showOnOff: true,
                    onToggle: (val) async {
                      setState(() {
                        status = val;
                      });
                      if (val == false) {
                        locData.stopListening(context);
                        await LocationPreferences().setLocationPreference(val);
                      } else {
                        await locData.listenLocation(context);
                        await LocationPreferences().setLocationPreference(val);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25.0,
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2.0, color: Colors.purple),
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Your shareable ID !",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 50,
                          alignment: Alignment.center,
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: _controller,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold),
                            enabled: false,
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: _controller.text));
                              Fluttertoast.showToast(
                                  msg: "Copied to Clipboard",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 12.0);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.copy,
                              size: 20,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Share.share('Hey! I know you care for me. \n'
                            ' I want you to save me from being a victim of corpus delicti'
                            'Here is my Surakshaan ID : \n $userID \n');
                      },
                      icon: Icon(
                        Icons.share,
                        size: 15.0,
                      ),
                      label: Text("Share"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.purple),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)))),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              child: FutureBuilder(
                  future: Future.value(userID),
                  builder: (context, futureSnapshot) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("acquaintances")
                            .doc(userID)
                            .collection("lovedOnes")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SpinKitFadingCube(
                              color: Colors.black,
                            );
                          }
                          if (!snapshot.hasData) {
                            return Image.asset(
                                "assets/images/Users added.png");
                          } else {
                            final userData = snapshot.data!.docs.length;
                            if (userData == 0) {
                              return Center(
                                child: Image.asset(
                                    "assets/images/Users added.png"),
                              );
                            }
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) => Column(
                                      children: [
                                        Card(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 6.0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          elevation: 3.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              title: Text(snapshot
                                                  .data!.docs[index]["name"]),
                                              subtitle: Text(
                                                snapshot.data!.docs[index]
                                                    ["userId"],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: IconButton(
                                                onPressed: () async {
                                                  bool _doExists =
                                                      await checkIfDocExists(
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ["userId"])
                                                          .catchError(
                                                              (onError) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Unable To fetch data")));
                                                  });
                                                  if (_doExists == false) {
                                                    CoolAlert.show(
                                                        context: context,
                                                        type:
                                                            CoolAlertType.error,
                                                        title: "OOPS",
                                                        text:
                                                            "No such User Data exists");
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              GoogleMapScreen(
                                                                  userId: snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      "userId"])));
                                                },
                                                icon: Icon(Icons.gps_fixed),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                          }
                        });
                  }),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => Dialog(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: TextField(
                              decoration: kInputDecoration,
                              controller: _userIdController,
                              cursorColor: Colors.purple,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: TextField(
                              decoration: kInputDecoration.copyWith(
                                  labelText:
                                      "Give your him/her a sweet name !"),
                              controller: _nameController,
                              cursorColor: Colors.purple,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.purple),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    if (_userIdController.text.isEmpty &&
                                        _nameController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Invalid Data Input"),
                                        backgroundColor:
                                            Theme.of(context).errorColor,
                                      ));
                                      return;
                                    }
                                    bool _exists = await checkIfDocExists(
                                            _userIdController.text)
                                        .catchError((onError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Unable To fetch data")));
                                    });
                                    if (_exists == false) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          title: "OOPS",
                                          text: "No such user exists");
                                      return;
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection("acquaintances")
                                          .doc(userID)
                                          .collection("lovedOnes")
                                          .add({
                                        "userId": _userIdController.text,
                                        "name": _nameController.text,
                                      });
                                      FocusScope.of(context).unfocus();
                                      Navigator.pop(context);
                                      _nameController.clear();
                                      _userIdController.clear();
                                    }
                                  },
                                  child: Text(
                                    "Save",
                                    style: TextStyle(color: Colors.purple),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
        },
        elevation: 5.0,
        backgroundColor: Colors.purple,
        child: FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
