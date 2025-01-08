import 'package:flutter/material.dart';
import 'package:weather/models/weather-data.dart';
import 'package:weather/screens/city_screen.dart';
import 'package:weather/utilities/constants.dart';
import 'package:weather/services/weather.dart';


class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  int temperature = 0;
  String currentCity = '';


  @override
  initState () {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getInitialData();
    });
  }

  Future<void> _getInitialData () async {
    WeatherService weatherService = new WeatherService();
    WeatherData data = await weatherService.getWeatherData();
    
    setState(() {
      temperature = (data.main?.temp ?? 0.0).toInt();
      currentCity = data.name ?? '';
    });
  }

  void updateUI (int temp, String newCity) {
    setState(() {
      temperature = temp;
      currentCity = newCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var cityName = await Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return CityScreen();
                        },
                      ));
                      if (cityName != null){
                        final weather = new WeatherService();
                        var weatherData = await weather.getCityWeather(cityName);

                        int temp = weatherData.main?.temp?.toInt() ?? 0;
                        updateUI(temp, cityName);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '☀️',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "It's 🍦 time in $currentCity!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
