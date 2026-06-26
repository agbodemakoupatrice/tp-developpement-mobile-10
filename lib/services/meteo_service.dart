import 'package:dio/dio.dart';
import '../models/meteo_data.dart';
import '../models/prevision_jour.dart';

class MeteoService {
  // Coordonnées des villes de base
  static final Map<String, List<double>> _coords = {
    'Cotonou': [6.3703, 2.3912],
    'Parakou': [9.3370, 2.6283],
    'Lagos': [6.4541, 3.3947],
    'Abidjan': [5.3600, -4.0083],
    'Natitingou': [10.3042, 1.3796],
    'Ouidah': [6.3631, 2.0851],
    'Porto-Novo': [6.4969, 2.6289],
  };

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.open-meteo.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final Dio _geoDio = Dio(
    BaseOptions(
      baseUrl: 'https://geocoding-api.open-meteo.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  MeteoService() {
    _dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }

  // Trouver les coordonnées d'une ville automatiquement
  Future<List<double>?> _obtenirCoordonnees(String nomVille) async {
    // Déjà connue
    if (_coords.containsKey(nomVille)) return _coords[nomVille];

    try {
      final response = await _geoDio.get(
        '/search',
        queryParameters: {
          'name': nomVille,
          'count': 1,
          'language': 'fr',
          'format': 'json',
        },
      );

      final results = response.data['results'];
      if (results == null || results.isEmpty) return null;

      final lat = (results[0]['latitude'] as num).toDouble();
      final lon = (results[0]['longitude'] as num).toDouble();

      // Mettre en cache pour éviter de rappeler l'API
      _coords[nomVille] = [lat, lon];

      return [lat, lon];
    } catch (e) {
      print('geocoding error: $e');
      return null;
    }
  }

  Future<MeteoData?> getMeteo(String nomVille) async {
    final coords = await _obtenirCoordonnees(nomVille);
    if (coords == null) return null;

    try {
      final response = await _dio.get(
        '/forecast',
        queryParameters: {
          'latitude': coords[0],
          'longitude': coords[1],
          'current': 'temperature_2m,relative_humidity_2m,weather_code',
          'daily': 'temperature_2m_max,temperature_2m_min,weather_code',
          'timezone': 'Africa/Lagos',
          'forecast_days': 4,
        },
      );

      final current = response.data['current'] as Map<String, dynamic>;
      final daily = response.data['daily'] as Map<String, dynamic>;

      return MeteoData.fromJson(current, daily);
    } catch (e) {
      print('getMeteo error: $e');
      return null;
    }
  }
}