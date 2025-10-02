import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final int dt;
  final int sunrise;
  final int sunset;
  final double temp;
  final double feels_like;
  final int humidity;
  // final double uvi;

  const WeatherCard({
    super.key,
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.feels_like,
    required this.humidity,
    // required this.uvi,
});
  @override
  Widget build(BuildContext context) {
    return Card(
    child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Temp: ${temp.toStringAsFixed(1)} °C'),
            Text('Feels like: ${feels_like.toStringAsFixed(1)} °C'),
            Text('Humidity: $humidity %'),
            // Text('UVI: ${uvi.toStringAsFixed(1)}'),
            Text('sunrise: ${DateTime.fromMillisecondsSinceEpoch(sunrise * 1000)}'),
            Text('sunset: ${DateTime.fromMillisecondsSinceEpoch(sunset * 1000)}'),
            Text('DT: ${DateTime.fromMillisecondsSinceEpoch(dt * 1000)}'),

          ],

    )
    ),
    );
  }
}


