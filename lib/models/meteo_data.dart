import 'package:intl/intl.dart';
import 'prevision_jour.dart';

class MeteoData {
  final double temperature;
  final int humidite;
  final int weatherCode;
  final String dateHeure;
  final List<PrevisionJour> previsions;

  MeteoData({
    required this.temperature,
    required this.humidite,
    required this.weatherCode,
    required this.dateHeure,
    required this.previsions,
  });

  factory MeteoData.fromJson(
    Map<String, dynamic> current,
    Map<String, dynamic> daily,
  ) {
    final List dates = daily['time'];
    final List tempMax = daily['temperature_2m_max'];
    final List tempMin = daily['temperature_2m_min'];
    final List codes = daily['weather_code'];

    final List<PrevisionJour> liste = List.generate(3, (i) {
      final idx = i + 1;
      return PrevisionJour(
        date: DateTime.parse(dates[idx] as String),
        temperatureMax: (tempMax[idx] as num).toDouble(),
        temperatureMin: (tempMin[idx] as num).toDouble(),
        weatherCode: (codes[idx] as num).toInt(),
      );
    });

    return MeteoData(
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidite: (current['relative_humidity_2m'] as num).toInt(),
      weatherCode: (current['weather_code'] as num).toInt(),
      dateHeure: current['time'] as String,
      previsions: liste,
    );
  }

  String get conditionTexte {
    if (weatherCode == 0) return 'Ensoleillé';
    if (weatherCode <= 3) return 'Nuageux';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Pluvieux';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Averses';
    if (weatherCode >= 95) return 'Orageux';
    return 'Variable';
  }

  String get dateHeureFormatee {
    final date = DateTime.parse(dateHeure);
    return DateFormat("dd/MM/yyyy HH'h'mm").format(date);
  }
}
