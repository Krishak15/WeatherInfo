import 'package:weatherinfo/models/locationdata.dart';
import 'package:weatherinfo/models/wedata.dart';

const ApiUrl = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkData networkHelper = NetworkData(
        '$ApiUrl?lat=${location.latitude}&lon=${location.longitide}&appid=${Location.apiKey}&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }
}
