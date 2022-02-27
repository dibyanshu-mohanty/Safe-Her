import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class GoogleMapScreen extends StatefulWidget {
  final String userId;
  const GoogleMapScreen({Key? key,required this.userId}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController _controller;
  bool _added = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("location").snapshots(),
          builder: (context,mapSnapshot){
            if (_added) {
              mymap(mapSnapshot);
            }
            if (!mapSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return GoogleMap(
              mapType: MapType.normal,
              markers: {
                Marker(
                    position: LatLng(
                      mapSnapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.userId)['latitude'],
                      mapSnapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.userId)['longitude'],
                    ),
                    markerId: MarkerId('id'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure)),
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                    mapSnapshot.data!.docs.singleWhere(
                            (element) => element.id == widget.userId)['latitude'],
                    mapSnapshot.data!.docs.singleWhere(
                            (element) => element.id == widget.userId)['longitude'],
                  ),
                  zoom: 16),
              onMapCreated: (GoogleMapController controller) async {
                setState(() {
                  _controller = controller;
                  _added = true;
                });
              },
            );
          }
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.userId)['latitude'],
          snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.userId)['longitude'],
        ),
        zoom: 16)));
  }
}
