import 'package:equatable/equatable.dart';

class WeatherResponse extends Equatable {
  final Coord? coord;
  final List<Weather>? weather;
  final Main? main;
  final Wind? wind;
  final Clouds? clouds;
  final Rain? rain;
  final int? visibility;
  final int? dt;
  final Sys? sys;
  final int? timezone;
  final int? id;
  final String? name;
  final int? cod;

  const WeatherResponse({
    this.coord,
    this.weather,
    this.main,
    this.wind,
    this.clouds,
    this.rain,
    this.visibility,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      coord: json['coord'] != null ? Coord.fromJson(json['coord']) : null,
      weather:
          (json['weather'] as List?)?.map((e) => Weather.fromJson(e)).toList(),
      main: json['main'] != null ? Main.fromJson(json['main']) : null,
      wind: json['wind'] != null ? Wind.fromJson(json['wind']) : null,
      clouds: json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null,
      rain: json['rain'] != null ? Rain.fromJson(json['rain']) : null,
      visibility: json['visibility'],
      dt: json['dt'],
      sys: json['sys'] != null ? Sys.fromJson(json['sys']) : null,
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
    );
  }

  @override
  List<Object?> get props => [
        coord,
        weather,
        main,
        wind,
        clouds,
        rain,
        visibility,
        dt,
        sys,
        timezone,
        id,
        name,
        cod,
      ];
}

class Coord extends Equatable {
  final double? lon;
  final double? lat;

  const Coord({this.lon, this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: (json['lon'] as num?)?.toDouble(),
      lat: (json['lat'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [lon, lat];
}

class Weather extends Equatable {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  const Weather({this.id, this.main, this.description, this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  @override
  List<Object?> get props => [id, main, description, icon];
}

class Main extends Equatable {
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? grndLevel;

  const Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: (json['temp'] as num?)?.toDouble(),
      feelsLike: (json['feels_like'] as num?)?.toDouble(),
      tempMin: (json['temp_min'] as num?)?.toDouble(),
      tempMax: (json['temp_max'] as num?)?.toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
      seaLevel: json['sea_level'],
      grndLevel: json['grnd_level'],
    );
  }

  @override
  List<Object?> get props => [
        temp,
        feelsLike,
        tempMin,
        tempMax,
        pressure,
        humidity,
        seaLevel,
        grndLevel
      ];
}

class Wind extends Equatable {
  final double? speed;
  final int? deg;
  final double? gust;

  const Wind({this.speed, this.deg, this.gust});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: (json['speed'] as num?)?.toDouble(),
      deg: json['deg'],
      gust: (json['gust'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [speed, deg, gust];
}

class Rain extends Equatable {
  final double? oneHour;

  const Rain({this.oneHour});

  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(
      oneHour: (json['1h'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [oneHour];
}

class Clouds extends Equatable {
  final int? all;

  const Clouds({this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(all: json['all']);
  }

  @override
  List<Object?> get props => [all];
}

class Sys extends Equatable {
  final int? type;
  final int? id;
  final String? country;
  final int? sunrise;
  final int? sunset;

  const Sys({this.type, this.id, this.country, this.sunrise, this.sunset});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      type: json['type'],
      id: json['id'],
      country: json['country'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  @override
  List<Object?> get props => [type, id, country, sunrise, sunset];
}
