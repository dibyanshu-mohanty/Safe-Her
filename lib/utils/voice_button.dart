import 'dart:convert';
import 'dart:io';

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
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
  _callNumber() async{
    const number = '100';
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  _handleCmd(Map<String, dynamic> res) async{
    switch(res["command"]){
      case "Help":
        _isUndo == false ? _callNumber() : null;
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
