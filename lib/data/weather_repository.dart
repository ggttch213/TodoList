import 'package:todolist/data/api_client.dart';
import 'package:todolist/model/weather.dart';
import 'package:flutter/material.dart';
class WeatherRepository{
  final ApiClient _client;
  WeatherRepository(this._client);

  Future<Weather> fetchWeather({required double lat,required double lon,required String apiKey}) async{
    final uri = Uri.https('api.openweathermap.org','/data/2.5/weather',{
      'lat' : lat.toString(),
      'lon' : lon.toString(),
      'appid' : apiKey,
      'units' : 'metric',
      'exclude' : 'minutely,hourly,daily,alerts'
    });
    debugPrint('[Api] starting GET $uri');
    final map = await _client.getJson(uri);
    debugPrint('RAW JSON => $map');
    return Weather.fromJson(map);
  }
}