class Weather{
  final int dt;
  final int sunrise;
  final int sunset;
  final double temp;
  final double feels_like;
  final int humidity;
  // final double uvi;

  Weather({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.feels_like,
    required this.humidity,
    // required this.uvi,
});
  factory Weather.fromJson(Map<String,dynamic> json){
    final main = (json['main'] as Map<String,dynamic>?) ?? const {};
    final sysMap  = (json['sys']  as Map<String, dynamic>?) ?? const {};
    final int dt = (json['dt'] ?? 0) as int;
    final int sunrise = (sysMap['sunrise'] ?? 0) as int;
    final int sunset = (sysMap['sunset'] ?? 0) as int;
    final double temp = (main['temp'] is num) ? (main['temp'] as num).toDouble(): 0.0;
    final double feelslike = (main['feels_like'] is num) ? (main['feels_like'] as num).toDouble(): 0.0;
    final int humidity = (main['humidity'] ?? 0) as int;
    // final double uvi = (cur['uvi'] is num) ? (cur['uvi'] as num).toDouble(): 0.0;
    return Weather(
      dt: dt,
      sunrise: sunrise,
      sunset: sunset,
      temp: temp,
      feels_like: feelslike,
      humidity: humidity,
    );

  }
}