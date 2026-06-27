import 'package:flutter_test/flutter_test.dart';
import 'package:apps_meteo/models/meteo_data.dart';

void main() {
  group('MeteoData - conditionTexte', () {
    // Exercice A: Tester tous les codes météo WMO

    test('code 0 - Ensoleillé', () {
      // Arrange
      final meteo = MeteoData(
        temperature: 20,
        humidite: 50,
        weatherCode: 0,
        dateHeure: '2024-01-01T12:00',
        previsions: [],
      );

      // Act
      final condition = meteo.conditionTexte;

      // Assert
      expect(condition, equals('Ensoleillé'));
    });

    test('code 1-3 - Nuageux', () {
      // Arrange
      for (int code in [1, 2, 3]) {
        final meteo = MeteoData(
          temperature: 20,
          humidite: 50,
          weatherCode: code,
          dateHeure: '2024-01-01T12:00',
          previsions: [],
        );

        // Act
        final condition = meteo.conditionTexte;

        // Assert
        expect(condition, equals('Nuageux'), reason: 'Code $code');
      }
    });

    test('code 51-67 - Pluvieux', () {
      // Arrange
      final meteo = MeteoData(
        temperature: 20,
        humidite: 50,
        weatherCode: 61,
        dateHeure: '2024-01-01T12:00',
        previsions: [],
      );

      // Act
      final condition = meteo.conditionTexte;

      // Assert
      expect(condition, equals('Pluvieux'));
    });

    test('code 80-82 - Averses', () {
      // Arrange
      for (int code in [80, 81, 82]) {
        final meteo = MeteoData(
          temperature: 20,
          humidite: 50,
          weatherCode: code,
          dateHeure: '2024-01-01T12:00',
          previsions: [],
        );

        // Act
        final condition = meteo.conditionTexte;

        // Assert
        expect(condition, equals('Averses'), reason: 'Code $code');
      }
    });

    test('code 95+ - Orageux', () {
      // Arrange
      for (int code in [95, 96, 99]) {
        final meteo = MeteoData(
          temperature: 20,
          humidite: 50,
          weatherCode: code,
          dateHeure: '2024-01-01T12:00',
          previsions: [],
        );

        // Act
        final condition = meteo.conditionTexte;

        // Assert
        expect(condition, equals('Orageux'), reason: 'Code $code');
      }
    });

    test('code inconnu - Variable', () {
      // Arrange
      final meteo = MeteoData(
        temperature: 20,
        humidite: 50,
        weatherCode: 10,
        dateHeure: '2024-01-01T12:00',
        previsions: [],
      );

      // Act
      final condition = meteo.conditionTexte;

      // Assert
      expect(condition, equals('Variable'));
    });
  });

  group('MeteoData - estDangereux', () {
    // Exercice B: Tester la méthode estDangereux()

    test('Température > 40°C ET weatherCode >= 95 - DANGEREUX', () {
      // Arrange
      final meteo = MeteoData(
        temperature: 45,
        humidite: 30,
        weatherCode: 95,
        dateHeure: '2024-01-01T12:00',
        previsions: [],
      );

      // Act
      final dangereux = meteo.estDangereux();

      // Assert
      expect(dangereux, isTrue);
    });

    test('Température > 40°C SEUL - DANGEREUX', () {
      // Arrange
      final meteo = MeteoData(
        temperature: 45,
        humidite: 30,
        weatherCode: 0,
        dateHeure: '2024-01-01T12:00',
        previsions: [],
      );

      // Act
      final dangereux = meteo.estDangereux();

      // Assert
      expect(dangereux, isTrue);
    });

    test('weatherCode >= 95 SEUL - DANGEREUX', () {
      // Arrange
      final meteo = MeteoData(
        temperature: 20,
        humidite: 50,
        weatherCode: 95,
        dateHeure: '2024-01-01T12:00',
        previsions: [],
      );

      // Act
      final dangereux = meteo.estDangereux();

      // Assert
      expect(dangereux, isTrue);
    });

    test('Température normale ET weatherCode normal - NON DANGEREUX', () {
      // Arrange
      final meteo = MeteoData(
        temperature: 25,
        humidite: 50,
        weatherCode: 0,
        dateHeure: '2024-01-01T12:00',
        previsions: [],
      );

      // Act
      final dangereux = meteo.estDangereux();

      // Assert
      expect(dangereux, isFalse);
    });
  });
}
