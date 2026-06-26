import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/localisation_service.dart';
import '../services/meteo_service.dart';
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

  IconData _iconeMeteoCode(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.cloud;
    if (code >= 51 && code <= 67) return Icons.umbrella;
    if (code >= 80 && code <= 82) return Icons.grain;
    if (code >= 95) return Icons.thunderstorm;
    return Icons.wb_cloudy;
  }

  Color _couleurFond(String condition) {
    switch (condition.toLowerCase()) {
      case 'ensoleille':
      case 'sunny':
        return Colors.orange.shade100;
      case 'nuageux':
      case 'cloudy':
        return Colors.grey.shade300;
      case 'pluvieux':
      case 'rainy':
        return Colors.blue.shade100;
      case 'orageux':
      case 'stormy':
        return Colors.blueGrey.shade200;
      case 'ventueux':
      case 'windy':
        return Colors.teal.shade50;
      default:
        return Colors.white;
    }
  }

  Future<void> _choisirPhoto(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (context.mounted) {
        context.read<VilleViewModel>().mettreAJourPhoto(image.path);
      }
    }
  }

  Future<void> _trouverVilleProche(BuildContext context) async {
    final service = LocalisationService();
    final position = await service.getPosition();

    if (!context.mounted) return;

    if (position != null) {
      final vm = context.read<VilleViewModel>();
      final villeProche = service.trouverVilleProche(
        position,
        vm.villes,
        MeteoService.coords,
      );
      if (villeProche != null) {
        vm.selectionnerVille(villeProche);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ville proche : ${villeProche.nom}')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('GPS indisponible')));
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
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => _trouverVilleProche(context),
            tooltip: 'Ville la plus proche',
          ),
        ],
      ),
      body: ville == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: _couleurFond(ville.condition)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // ── Photo de la ville ──────────────────────────
                    GestureDetector(
                      onTap: () => _choisirPhoto(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ville.photoPath != null
                            ? Image.file(
                                File(ville.photoPath!),
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: double.infinity,
                                height: 180,
                                color: Colors.grey[200],
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    Text('Appuyez pour ajouter une photo'),
                                  ],
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Icône météo ────────────────────────────────
                    Icon(
                      _iconeMeteo(ville.condition),
                      size: 80,
                      color: ville.condition.toLowerCase() == 'ensoleille'
                          ? Colors.orange.shade700
                          : Colors.blueGrey.shade700,
                    ),
                    const SizedBox(height: 8),

                    Consumer<VilleViewModel>(
                      builder: (context, vm, _) {
                        if (vm.chargement) {
                          return const CircularProgressIndicator();
                        }
                        if (vm.erreur != null) {
                          return Column(
                            children: [
                              const Icon(
                                Icons.wifi_off,
                                size: 60,
                                color: Colors.red,
                              ),
                              Text(
                                vm.erreur!,
                                style: const TextStyle(color: Colors.red),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    vm.selectionnerVille(vm.villeSelectionnee!),
                                child: const Text('Réessayer'),
                              ),
                            ],
                          );
                        }
                        final meteo = vm.meteoActuelle;
                        if (meteo == null) {
                          return const Text('Chargement...');
                        }

                        return Column(
                          children: [
                            Text(
                              vm.villeSelectionnee!.nom,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vm.villeSelectionnee!.pays,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black45,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${meteo.temperature.toStringAsFixed(1)} °C',
                              style: const TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Mesure du ${meteo.dateHeureFormatee}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${meteo.conditionTexte} · ${meteo.humidite}% humidité',
                            ),
                            const SizedBox(height: 24),
                            const Divider(indent: 32, endIndent: 32),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: vm.previsions.map((p) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: Container(
                                    width: 90,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.55),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: Colors.white60),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          p.jour,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Icon(
                                          _iconeMeteoCode(p.weatherCode),
                                          size: 28,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${p.temperatureMax.round()}° / ${p.temperatureMin.round()}°',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // ── Boutons ────────────────────────────────────
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
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}
