import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safe_her/methods/fetch_location.dart';
import 'package:safe_her/secrets.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  String getImage(double lat, double long){
    final url = "https://api.mapbox.com/styles/v1/mapbox/light-v10/static/pin-s-l+000($long,$lat)/$long,$lat,16/600x600?"
        "access_token=$mapboxAPI";
    return url;
  }

  String location = "";
  String city = "";
  String address="";
  String pincode="";
  bool _isLoading=true;
  var latitude;
  var longitude;

  void getCity() async{
    final response = await LocationFinder().getCityName(context);
    final data = await LocationFinder().getLocation().catchError((error){
      WidgetsBinding.instance!.addPostFrameCallback((_){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
      });
    });
    if (!mounted) return;
    setState(() {
      latitude = data.latitude;
      longitude = data.longitude;
      location = response[0].subLocality;
      city = response[0].locality;
      address = response[0].street;
      pincode = response[0].postalCode;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              SizedBox(height: 20.0,),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_back_ios),
                  ),),
              ),
              Center(child: Text("Your Current Location")),
              SizedBox(height: 20.0,),
              _isLoading
                  ? SpinKitPouringHourGlassRefined(color: Colors.black)
                  : Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: Image.network(getImage(latitude, longitude),fit: BoxFit.cover,),
              ),
              SizedBox(height: 20.0,),
              ListTile(
                title: Text("Address"),
                subtitle: Text(address + ", "+ location + ", "+ city,softWrap: true,style: TextStyle(fontSize: 18.0),),
              ),
              // ListTile(
              //   title: Text("Location"),
              //   subtitle: Text(location),
              // ),
              // ListTile(
              //   title: Text("City"),
              //   subtitle: Text(city + " ," + pincode),
              // ),
              // Text(address+" , "+location+" , "+city,softWrap: true,style: TextStyle(fontSize: 18.0),),
            ],
          ),
        ));
  }
}
