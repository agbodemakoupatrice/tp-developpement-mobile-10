import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_liste_ville.dart';

class EcranAccueil extends StatelessWidget {
  const EcranAccueil({super.key});

  IconData _iconeMeteo(String condition) {
    switch (condition.toLowerCase()) {
      case 'ensoleille':
      case 'sunny':
        return Icons.wb_sunny;
      case 'nuageux':
      case 'cloudy':
        return Icons.cloud;
      case 'pluvieux':
      case 'rainy':
        return Icons.umbrella;
      case 'orageux':
      case 'stormy':
        return Icons.thunderstorm;
      case 'ventueux':
      case 'windy':
        return Icons.air;
      default:
        return Icons.wb_cloudy;
    }
  }

  Color _couleurFond(String condition) {
    switch (condition.toLowerCase()) {
      case 'ensoleille':
      case 'sunny':
        return Colors.orange.shade100; // Orange clair
      case 'nuageux':
      case 'cloudy':
        return Colors.grey.shade300; // Gris clair
      case 'pluvieux':
      case 'rainy':
        return Colors.blue.shade100; // Bleu clair
      case 'orageux':
      case 'stormy':
        return Colors.blueGrey.shade200; // Gris-bleu orage
      case 'ventueux':
      case 'windy':
        return Colors.teal.shade50; // Turquoise très clair
      default:
        return Colors.white; // Blanc par défaut
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VilleViewModel>();
    final ville = vm.villeSelectionnee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppMeteo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ville == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              // Remplissage de tout l'écran avec la couleur dynamique
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: _couleurFond(ville.condition)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _iconeMeteo(ville.condition),
                    size: 100,
                    color: ville.condition.toLowerCase() == 'ensoleille'
                        ? Colors.orange.shade700
                        : Colors.blueGrey.shade700,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${ville.temperature.toStringAsFixed(0)}°C',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ville.nom,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${ville.condition} • Humidité : ${ville.humidite}%',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.list),
                    label: const Text('Changer de ville'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EcranListeVilles(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
