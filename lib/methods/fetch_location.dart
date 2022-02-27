import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as Loc;

class LocationFinder{
  Future getLocation() async {
    bool serviceEnabled;
    Loc.PermissionStatus permission;
    serviceEnabled = await Loc.Location().serviceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Loc.Location().hasPermission();
    if (permission == Loc.PermissionStatus.denied) {
      permission = await Loc.Location().requestPermission();
      if (permission == Loc.PermissionStatus.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == Loc.PermissionStatus.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, Cannot request permissions.');
    }
    Loc.Location().changeSettings(accuracy: Loc.LocationAccuracy.high);
    return await Loc.Location().getLocation();
  }

  Future<List> getCityName(BuildContext context) async{
    final response = await getLocation().catchError((error){
      WidgetsBinding.instance!.addPostFrameCallback((_){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),backgroundColor: Colors.redAccent,));
      });
    });
    final lat = response.latitude;
    final long = response.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(lat,long);
    if(placemarks.isNotEmpty){
      return Future.value(placemarks);
    } else {
      return Future.error("Location Not Found");
    }
  }
}