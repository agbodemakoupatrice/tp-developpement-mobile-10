import 'package:flutter/material.dart';
import '../models/ville.dart';
import '../models/meteo_data.dart';

class EcranDetailVille extends StatelessWidget {
  final Ville ville;
  final MeteoData? meteo;

  const EcranDetailVille({super.key, required this.ville, this.meteo});

  IconData _iconeMeteo(String condition) {
    switch (condition.toLowerCase()) {
      case 'ensoleille':
        return Icons.wb_sunny;
      case 'nuageux':
        return Icons.cloud;
      case 'pluvieux':
        return Icons.umbrella;
      case 'orageux':
        return Icons.thunderstorm;
      case 'ventueux':
        return Icons.air;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ville.nom),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero avec même tag que l'écran d'accueil
            Hero(
              tag: 'icone-${ville.nom}',
              child: Icon(
                _iconeMeteo(ville.condition),
                size: 180,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              ville.nom,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              ville.pays,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            if (meteo != null) ...[
              Text(
                '${meteo!.temperature.toStringAsFixed(1)} °C',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                '${meteo!.conditionTexte} · ${meteo!.humidite}% humidité',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
