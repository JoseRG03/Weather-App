import 'package:weather/models/weather-data.dart';
import 'package:weather/secrets.dart';
import 'package:weather/services/location.dart';
import 'package:weather/services/networking.dart';

class WeatherService {

  final _secrets = Secrets();
  String _baseUrl = '';
  String _apiKey = '';

  WeatherService() {
    _baseUrl = _secrets.baseUrl;
    _apiKey = _secrets.apiKey;
  }

  Future<WeatherData> getCityWeather(String cityName) async{
    Networking networking = Networking(url: '${_baseUrl}?q=${cityName}&appid=${_apiKey}&units=metric');
    final data = await networking.getData();

    try {
      WeatherData weatherData = WeatherData.fromJson(data);
      return weatherData;
    } catch (err) {
      print('Error: $err');
      return new WeatherData();
    }

  }


  Future<WeatherData> getWeatherData() async {

    Location location = Location();
    await location.getCurrentPosition();

    Networking networking = Networking(url: '${_baseUrl}?lat=${location.latitude}&lon=${location.longitude}&appid=${_apiKey}&units=metric');
    var data = await networking.getData();

    try {
      WeatherData weatherData = WeatherData.fromJson(data);
      return weatherData;
    } catch (err) {
      print('Error: $err');
      return new WeatherData();
    }
  }








  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
