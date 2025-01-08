import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/screens/location_screen.dart';
import 'package:weather/services/location.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    //Get the current location
    final location = Location();
    await location.getCurrentPosition();
    print(location.latitude);
    print(location.longitude);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen();
    },));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitFadingCube(
          color: Colors.green,
          size: 50.0,
        ),
      ),
    );
  }
}
