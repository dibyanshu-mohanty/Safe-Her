import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:safe_her/methods/fetch_location.dart';
import 'package:safe_her/methods/send_help.dart';
import 'package:safe_her/providers/help_provider.dart';
import 'package:timer_snackbar/timer_snackbar.dart';

class SOSButton extends StatefulWidget {
  const SOSButton({Key? key}) : super(key: key);

  @override
  _SOSButtonState createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> {
  bool _isLoading = false;
  bool _isUndo = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(
      builder: (context,contact,ch) {
        return InkWell(
          onTap: () async{
            setState(() {
              _isLoading = true;
            });
            final response = await LocationFinder().getLocation();
            final latitude = response.latitude;
            final longitude = response.longitude;
            final data = await LocationFinder().getCityName(context);
            final addRess = data[0];
            final String message =
                "Your Loved ones are in Danger ! He/She wants your help! \n \n"
                "Address : ${addRess.street}, ${addRess.subLocality}, ${addRess.locality} \n \n"
                "Location: https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
            final recipients = await contact.getNumbers();
            Platform.isAndroid
                ? timerSnackbar(
              context: context,
              contentText: "We hope you aren't in much danger !",
              buttonPrefixWidget: TextButton(
                  onPressed: () {
                    setState(() {
                      _isUndo = true;
                    });
                  },
                  child: Text("Undo")),
              afterTimeExecute: () {
                if (_isUndo == true) {
                  Fluttertoast.showToast(
                      msg: "SOS Stopped",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 12.0);
                  return;
                }
                SeekHelp().sendSOS(message, recipients, context);
              },
              second: 5,
              buttonLabel: '',
            )
                : SeekHelp().sendHelp(message, recipients, context);
            setState(() {
              _isUndo=false;
            });
            setState(() {
              _isLoading = false;
            });
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.55,
            alignment: Alignment.center,
            child: Column(
              children: [
                Lottie.network(
                    "https://assets10.lottiefiles.com/packages/lf20_EOl7yZ.json",
                    repeat: true,
                    reverse: true,
                    width: 300,
                    height: 300),
                Visibility(
                    visible: _isLoading,
                    child: SizedBox(width: 80,child: LinearProgressIndicator(color: Colors.white,backgroundColor: Colors.black,))
                )
              ],
            ),
          ),
        );
      },
      child: CircularProgressIndicator()
    );
  }
}
