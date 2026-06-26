import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/localisation_service.dart';
import '../services/meteo_service.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_liste_ville.dart';
import 'ecran_detail_ville.dart';

class EcranAccueil extends StatefulWidget {
  const EcranAccueil({super.key});

  @override
  State<EcranAccueil> createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil>
    with SingleTickerProviderStateMixin {
  // ── TP4 : Animation fondu ────────────────────────────
  bool _visible = false;

  // ── TP4 Exercice C : Rotation soleil ────────────────
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    // Fondu au démarrage
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _visible = true);
    });

    // Rotation continue
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

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

  // ── TP4 Exercice B : couleur selon température ──────
  Color _couleurFond(String condition, double? temperature) {
    if (temperature != null) {
      if (temperature < 20) return Colors.blue.shade100;
      if (temperature < 30) return Colors.orange.shade100;
      return Colors.red.shade100;
    }
    switch (condition.toLowerCase()) {
      case 'ensoleille':
        return Colors.orange.shade100;
      case 'nuageux':
        return Colors.grey.shade300;
      case 'pluvieux':
        return Colors.blue.shade100;
      case 'orageux':
        return Colors.blueGrey.shade200;
      case 'ventueux':
        return Colors.teal.shade50;
      default:
        return Colors.white;
    }
  }

  Future<void> _choisirPhoto(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && context.mounted) {
      context.read<VilleViewModel>().mettreAJourPhoto(image.path);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPS indisponible')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VilleViewModel>();
    final ville = vm.villeSelectionnee;
    final temperature = vm.meteoActuelle?.temperature;
    final estEnsoleille =
        ville?.condition.toLowerCase() == 'ensoleille';

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
      // ── TP4 : Fondu au démarrage ─────────────────────
      body: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
        child: ville == null
            ? const Center(child: CircularProgressIndicator())
            // ── TP4 Exercice B : couleur animée ──────────
            : AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                width: double.infinity,
                height: double.infinity,
                color: _couleurFond(ville.condition, temperature),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // ── Photo de la ville ──────────────
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          size: 50, color: Colors.grey),
                                      Text('Appuyez pour ajouter une photo'),
                                    ],
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── TP4 : Hero + icône animée ──────
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EcranDetailVille(
                                ville: vm.villeSelectionnee!,
                                meteo: vm.meteoActuelle,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'icone-${vm.villeSelectionnee?.nom ?? "meteo"}',
                          // TP4 Exercice A : taille animée selon température
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.elasticOut,
                            width: (temperature != null && temperature > 30)
                                ? 120
                                : 80,
                            height: (temperature != null && temperature > 30)
                                ? 120
                                : 80,
                            // TP4 Exercice C : rotation si ensoleillé
                            child: estEnsoleille
                                ? RotationTransition(
                                    turns: _rotationController,
                                    child: Icon(
                                      Icons.wb_sunny,
                                      size: (temperature != null &&
                                              temperature > 30)
                                          ? 120
                                          : 80,
                                      color: Colors.orange.shade700,
                                    ),
                                  )
                                : Icon(
                                    _iconeMeteo(ville.condition),
                                    size: (temperature != null &&
                                            temperature > 30)
                                        ? 120
                                        : 80,
                                    color: Colors.blueGrey.shade700,
                                  ),
                          ),
                        ),
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
                                const Icon(Icons.wifi_off,
                                    size: 60, color: Colors.red),
                                Text(vm.erreur!,
                                    style:
                                        const TextStyle(color: Colors.red)),
                                ElevatedButton(
                                  onPressed: () => vm.selectionnerVille(
                                      vm.villeSelectionnee!),
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
                                    fontSize: 14, color: Colors.black45),
                              ),
                              const SizedBox(height: 16),

                              // ── TP4 : AnimatedSwitcher température ──
                              AnimatedSwitcher(
                                duration:
                                    const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                                child: Text(
                                  '${meteo.temperature.toStringAsFixed(1)} °C',
                                  key: ValueKey(
                                      vm.villeSelectionnee?.nom),
                                  style: const TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),
                              Text(
                                'Mesure du ${meteo.dateHeureFormatee}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${meteo.conditionTexte} · ${meteo.humidite}% humidité',
                              ),
                              const SizedBox(height: 24),
                              const Divider(indent: 32, endIndent: 32),
                              const SizedBox(height: 16),

                              // ── Prévisions ───────────────────────────
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: vm.previsions.map((p) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Container(
                                      width: 90,
                                      padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withOpacity(0.55),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        border: Border.all(
                                            color: Colors.white60),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(p.jour,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.w600)),
                                          const SizedBox(height: 8),
                                          Icon(
                                              _iconeMeteoCode(
                                                  p.weatherCode),
                                              size: 28),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${p.temperatureMax.round()}° / ${p.temperatureMin.round()}°',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54),
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
                      ElevatedButton.icon(
                        icon: const Icon(Icons.list),
                        label: const Text('Changer de ville'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const EcranListeVilles()),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}