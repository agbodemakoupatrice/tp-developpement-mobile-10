import 'package:flutter_test/flutter_test.dart';
import 'package:apps_meteo/models/meteo_data.dart';

void main() {
  group('MeteoData', () {
    // Test 1 : fromJson parse la température
    test('fromJson parse la temperature correctement', () {
      final current = {
        'temperature_2m': 29.5,
        'relative_humidity_2m': 70,
        'weather_code': 0,
        'time': '2026-06-26T11:00',
      };
      final daily = {
        'time': ['2026-06-26', '2026-06-27', '2026-06-28', '2026-06-29'],
        'temperature_2m_max': [30.0, 31.0, 29.0, 28.0],
        'temperature_2m_min': [24.0, 23.0, 22.0, 21.0],
        'weather_code': [0, 1, 61, 95],
      };

      final meteo = MeteoData.fromJson(current, daily);

      expect(meteo.temperature, equals(29.5));
    });

    // Test 2 : conditionTexte pour code 0
    test('conditionTexte retourne Ensoleillé pour code 0', () {
      final meteo = MeteoData(
        temperature: 30,
        humidite: 60,
        weatherCode: 0,
        dateHeure: '2026-06-26T11:00',
        previsions: [],
      );
      expect(meteo.conditionTexte, equals('Ensoleillé'));
    });

    // Test 3 : conditionTexte pour code 61
    test('conditionTexte retourne Pluvieux pour code 61', () {
      final meteo = MeteoData(
        temperature: 25,
        humidite: 80,
        weatherCode: 61,
        dateHeure: '2026-06-26T11:00',
        previsions: [],
      );
      expect(meteo.conditionTexte, equals('Pluvieux'));
    });

    // Test 4 : fromJson parse l'humidité
    test('fromJson parse l humidite correctement', () {
      final current = {
        'temperature_2m': 28.0,
        'relative_humidity_2m': 75,
        'weather_code': 0,
        'time': '2026-06-26T11:00',
      };
      final daily = {
        'time': ['2026-06-26', '2026-06-27', '2026-06-28', '2026-06-29'],
        'temperature_2m_max': [30.0, 31.0, 29.0, 28.0],
        'temperature_2m_min': [24.0, 23.0, 22.0, 21.0],
        'weather_code': [0, 1, 61, 95],
      };

      final meteo = MeteoData.fromJson(current, daily);

      expect(meteo.humidite, equals(75));
    });

    // Exercice A : tous les codes météo
    test('conditionTexte retourne Nuageux pour code 1', () {
      final meteo = MeteoData(
        temperature: 25,
        humidite: 60,
        weatherCode: 1,
        dateHeure: '2026-06-26T11:00',
        previsions: [],
      );
      expect(meteo.conditionTexte, equals('Nuageux'));
    });

    test('conditionTexte retourne Averses pour code 80', () {
      final meteo = MeteoData(
        temperature: 25,
        humidite: 60,
        weatherCode: 80,
        dateHeure: '2026-06-26T11:00',
        previsions: [],
      );
      expect(meteo.conditionTexte, equals('Averses'));
    });

    test('conditionTexte retourne Orageux pour code 95', () {
      final meteo = MeteoData(
        temperature: 25,
        humidite: 60,
        weatherCode: 95,
        dateHeure: '2026-06-26T11:00',
        previsions: [],
      );
      expect(meteo.conditionTexte, equals('Orageux'));
    });

    test('conditionTexte retourne Variable pour code inconnu', () {
      final meteo = MeteoData(
        temperature: 25,
        humidite: 60,
        weatherCode: 99,
        dateHeure: '2026-06-26T11:00',
        previsions: [],
      );
      expect(meteo.conditionTexte, equals('Variable'));
    });

    // Exercice B : estDangereux()
    test('estDangereux retourne true si temperature > 40', () {
      final meteo = MeteoData(
        temperature: 41,
        humidite: 60,
        weatherCode: 0,
        dateHeure: '2026-06-26T11:00',
        previsions: [],
      );
      expect(meteo.estDangereux(), isTrue);
    });

    test('estDangereux retourne true si orage (code >= 95)', () {
      final meteo = MeteoData(
        temperature: 25,
        humidite: 60,
        weatherCode: 95,
        dateHeure: '2026-06-26T11:00',
        previsions: [],
      );
      expect(meteo.estDangereux(), isTrue);
    });

    test('estDangereux retourne true si chaud ET orageux', () {
      final meteo = MeteoData(
        temperature: 42,
        humidite: 60,
        weatherCode: 95,
        dateHeure: '2026-06-26T11:00',
        previsions: [],
      );
      expect(meteo.estDangereux(), isTrue);
    });

    test('estDangereux retourne false si normal', () {
      final meteo = MeteoData(
        temperature: 28,
        humidite: 60,
        weatherCode: 0,
        dateHeure: '2026-06-26T11:00',
        previsions: [],
      );
      expect(meteo.estDangereux(), isFalse);
    });
  });
}
