
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_her/methods/fetch_location.dart';

class Locations with ChangeNotifier {
  String _location = "";

  String get location {
    return _location;
  }

  Future<void> setLocation(BuildContext context) async {
    final response = await LocationFinder().getCityName(context);
    _location = response[0].subLocality;
    if (_location.isEmpty) {
      _location = response[1].subLocality;
      if (_location.isEmpty) {
        _location = response[2].subLocality;
      }
      if (_location.isEmpty) {
        _location = response[4].name;
      } else {
        _location = "Not Found";
      }
    }
    notifyListeners();
  }
  final userID = FirebaseAuth.instance.currentUser!.uid;
  StreamSubscription<Position>? _locationSubscription;

  Future<void>
   listenLocation(BuildContext context) async {
    _locationSubscription = Geolocator.getPositionStream(
        locationSettings:
        LocationSettings(accuracy: LocationAccuracy.bestForNavigation))
        .handleError((error) {
      _locationSubscription!.cancel();
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error in Fetching location"),
          backgroundColor: Colors.redAccent,
        ));
      });
    }).listen((position) async {
      await FirebaseFirestore.instance.collection('location').doc(userID).set({
        'latitude': position.latitude,
        'longitude': position.longitude,
      }, SetOptions(merge: true));
    });
    notifyListeners();
  }

  void stopListening(BuildContext context){
    _locationSubscription?.cancel();
    _locationSubscription=null;
    notifyListeners();
  }
}