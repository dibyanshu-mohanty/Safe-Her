import 'dart:convert';
import 'dart:io';

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_her/methods/fetch_location.dart';
import 'package:safe_her/methods/send_help.dart';
import 'package:safe_her/providers/help_provider.dart';
import 'package:timer_snackbar/timer_snackbar.dart';


class VoiceButton extends StatefulWidget {
  final ContactProvider contact;
  const VoiceButton({Key? key,required this.contact}) : super(key: key);

  @override
  _VoiceButtonState createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {

  bool _isUndo = false;

  setVoiceCommands(){
    AlanVoice.addButton(
        "8cfd0d54f14029de39bfddd88d8140c82e956eca572e1d8b807a3e2338fdd0dc/stage",
        bottomMargin: 40,
      buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT
    );
    AlanVoice.callbacks.add((command) => _handleCmd(command.data));
  }

  _handleCmd(Map<String, dynamic> res) async{
    switch(res["command"]){
      case "Help":
        final response = await LocationFinder().getLocation();
        final latitude = response.latitude;
        final longitude = response.longitude;
        final data = await LocationFinder().getCityName(context);
        final addRess = data[0];
        final String message =
            "Your Loved ones are in Danger ! He/She wants your help! \n \n"
            "Address : ${addRess.street}, ${addRess.subLocality}, ${addRess.locality} \n \n"
            "Location: https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
        final recipients = await widget.contact.getNumbers();
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
        break;
      case "Close" :
        setState(() {
          _isUndo = true;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    setVoiceCommands();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
