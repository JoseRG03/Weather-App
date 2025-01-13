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
  String descriptionMessage = '';
  String weatherIcon = '';

  bool isLoading = false;

  @override
  initState () {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getInitialData();
    });
  }

  Future<void> _getInitialData () async {
    setState(() {
      isLoading = true;
    });
    WeatherService weatherService = new WeatherService();
    WeatherData data = await weatherService.getWeatherData();

    updateUI((data.main?.temp ?? 0.0).toInt(), data.name ?? '', (data.main?.humidity ?? 0.0).toInt());
    setState(() {
      isLoading = false;
    });
  }

  void updateUI (int temp, String newCity, int condition) {
    String descriptionMessageResult = getDescriptionMessage(temp);
    String conditionIcon = getTemperatureEmoji(condition);

    setState(() {
      temperature = temp;
      currentCity = newCity;
      descriptionMessage = descriptionMessageResult;
      weatherIcon = conditionIcon;
    });
  }

  String getDescriptionMessage (int temp) {
    WeatherService weatherService = WeatherService();
    String value = weatherService.getMessage(temp);

    return value;
  }

  String getTemperatureEmoji (int condition) {
    WeatherService weatherService = WeatherService();
    String value = weatherService.getWeatherIcon(condition);

    return value;
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
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      WeatherService weatherService = WeatherService();
                      WeatherData weatherData = await weatherService.getWeatherData();

                      updateUI((weatherData.main?.temp ?? 0.0).toInt(), weatherData.name ?? '', (weatherData.main?.humidity ?? 0.0).toInt());
                      setState(() {
                        isLoading = false;
                      });
                    },
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
                        setState(() {
                          isLoading = true;
                        });
                        final weather = new WeatherService();
                        var weatherData = await weather.getCityWeather(cityName);

                        int temp = weatherData.main?.temp?.toInt() ?? 0;
                        int condition = weatherData.main?.humidity?.toInt() ?? 0;
                        updateUI(temp, cityName, condition);
                        setState(() {
                          isLoading = false;
                        });
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
                child: isLoading ? CircularProgressIndicator() : Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: isLoading ? CircularProgressIndicator() : Text(
                  "$descriptionMessage in $currentCity!",
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
