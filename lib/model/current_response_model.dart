/// coord : {"lon":90.466,"lat":23.45}
/// weather : [{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}]
/// base : "stations"
/// main : {"temp":303.19,"feels_like":307.34,"temp_min":303.19,"temp_max":303.19,"pressure":1010,"humidity":66,"sea_level":1010,"grnd_level":1009}
/// visibility : 10000
/// wind : {"speed":3.36,"deg":169,"gust":3.6}
/// clouds : {"all":84}
/// dt : 1661745307
/// sys : {"type":1,"id":9145,"country":"BD","sunrise":1661729949,"sunset":1661775582}
/// timezone : 21600
/// id : 1185155
/// name : "Nārāyanganj"
/// cod : 200

class CurrentResposeModel {
  CurrentResposeModel({
    this.coord,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.clouds,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,});

  CurrentResposeModel.fromJson(dynamic json) {
    coord = json['coord'] != null ? Coord.fromJson(json['coord']) : null;
    if (json['weather'] != null) {
      weather = [];
      json['weather'].forEach((v) {
        weather?.add(Weather.fromJson(v));
      });
    }
    base = json['base'];
    main = json['main'] != null ? Main.fromJson(json['main']) : null;
    visibility = json['visibility'];
    wind = json['wind'] != null ? Wind.fromJson(json['wind']) : null;
    clouds = json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null;
    dt = json['dt'];
    sys = json['sys'] != null ? Sys.fromJson(json['sys']) : null;
    timezone = json['timezone'];
    id = json['id'];
    name = json['name'];
    cod = json['cod'];
  }
  Coord? coord;
  List<Weather>? weather;
  String? base;
  Main? main;
  num? visibility;
  Wind? wind;
  Clouds? clouds;
  num? dt;
  Sys? sys;
  num? timezone;
  num? id;
  String? name;
  num? cod;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (coord != null) {
      map['coord'] = coord?.toJson();
    }
    if (weather != null) {
      map['weather'] = weather?.map((v) => v.toJson()).toList();
    }
    map['base'] = base;
    if (main != null) {
      map['main'] = main?.toJson();
    }
    map['visibility'] = visibility;
    if (wind != null) {
      map['wind'] = wind?.toJson();
    }
    if (clouds != null) {
      map['clouds'] = clouds?.toJson();
    }
    map['dt'] = dt;
    if (sys != null) {
      map['sys'] = sys?.toJson();
    }
    map['timezone'] = timezone;
    map['id'] = id;
    map['name'] = name;
    map['cod'] = cod;
    return map;
  }

}

/// type : 1
/// id : 9145
/// country : "BD"
/// sunrise : 1661729949
/// sunset : 1661775582

class Sys {
  Sys({
    this.type,
    this.id,
    this.country,
    this.sunrise,
    this.sunset,});

  Sys.fromJson(dynamic json) {
    type = json['type'];
    id = json['id'];
    country = json['country'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }
  num? type;
  num? id;
  String? country;
  num? sunrise;
  num? sunset;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['id'] = id;
    map['country'] = country;
    map['sunrise'] = sunrise;
    map['sunset'] = sunset;
    return map;
  }

}

/// all : 84

class Clouds {
  Clouds({
    this.all,});

  Clouds.fromJson(dynamic json) {
    all = json['all'];
  }
  num? all;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['all'] = all;
    return map;
  }

}

/// speed : 3.36
/// deg : 169
/// gust : 3.6

class Wind {
  Wind({
    this.speed,
    this.deg,
    this.gust,});

  Wind.fromJson(dynamic json) {
    speed = json['speed'];
    deg = json['deg'];
    gust = json['gust'];
  }
  num? speed;
  num? deg;
  num? gust;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['speed'] = speed;
    map['deg'] = deg;
    map['gust'] = gust;
    return map;
  }

}

/// temp : 303.19
/// feels_like : 307.34
/// temp_min : 303.19
/// temp_max : 303.19
/// pressure : 1010
/// humidity : 66
/// sea_level : 1010
/// grnd_level : 1009

class Main {
  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,});

  Main.fromJson(dynamic json) {
    temp = json['temp'];
    feelsLike = json['feels_like'];
    tempMin = json['temp_min'];
    tempMax = json['temp_max'];
    pressure = json['pressure'];
    humidity = json['humidity'];
    seaLevel = json['sea_level'];
    grndLevel = json['grnd_level'];
  }
  num? temp;
  num? feelsLike;
  num? tempMin;
  num? tempMax;
  num? pressure;
  num? humidity;
  num? seaLevel;
  num? grndLevel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['temp'] = temp;
    map['feels_like'] = feelsLike;
    map['temp_min'] = tempMin;
    map['temp_max'] = tempMax;
    map['pressure'] = pressure;
    map['humidity'] = humidity;
    map['sea_level'] = seaLevel;
    map['grnd_level'] = grndLevel;
    return map;
  }

}

/// id : 803
/// main : "Clouds"
/// description : "broken clouds"
/// icon : "04d"

class Weather {
  Weather({
    this.id,
    this.main,
    this.description,
    this.icon,});

  Weather.fromJson(dynamic json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }
  num? id;
  String? main;
  String? description;
  String? icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['main'] = main;
    map['description'] = description;
    map['icon'] = icon;
    return map;
  }

}

/// lon : 90.466
/// lat : 23.45

class Coord {
  Coord({
    this.lon,
    this.lat,});

  Coord.fromJson(dynamic json) {
    lon = json['lon'];
    lat = json['lat'];
  }
  num? lon;
  num? lat;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lon'] = lon;
    map['lat'] = lat;
    return map;
  }

}