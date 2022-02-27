import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<dynamic> showErrorBar({required String title,required String desc, required BuildContext context}) async{
  Flushbar(
    title: title,
    titleColor: Colors.white,
    message: desc,
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    backgroundColor: Colors.red,
    boxShadows: [BoxShadow(color: Colors.blue.shade800, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
    isDismissible: false,
    duration: Duration(seconds: 3),
  ).show(context);
}