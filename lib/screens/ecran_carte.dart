import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/ville.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_detail_ville.dart';

class EcranCarte extends StatefulWidget {
  const EcranCarte({super.key});

  @override
  State<EcranCarte> createState() => _EcranCarteState();
}

class _EcranCarteState extends State<EcranCarte> {
  // Coordonnées des villes (latitude, longitude)
  final Map<String, LatLng> villesCoords = {
    'Cotonou': LatLng(6.4969, 2.6289),
    'Parakou': LatLng(9.3417, 2.6117),
    'Lagos': LatLng(6.5244, 3.3792),
    'Abidjan': LatLng(5.3364, -4.0265),
  };

  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  // Créer les markers pour la carte
  List<Marker> _buildMarkers(VilleViewModel vm) {
    return villesCoords.entries.map((entry) {
      final nom = entry.key;
      final coord = entry.value;
      final ville = vm.villes.firstWhere(
        (v) => v.nom == nom,
        orElse: () => Ville(
          nom: nom,
          pays: '',
          condition: 'Variable',
          temperature: 0.0,
          humidite: 0,
        ),
      );

      return Marker(
        width: 80.0,
        height: 80.0,
        point: coord,
        child: GestureDetector(
          onTap: () {
            // Sélectionner la ville et naviguer vers le détail
            vm.selectionnerVille(ville);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    EcranDetailVille(ville: ville, meteo: vm.meteoActuelle),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  nom,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VilleViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des villes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(7.0, 2.0), // Centre Afrique de l'Ouest
          initialZoom: 6.5,
          maxZoom: 18.0,
          minZoom: 4.0,
        ),
        children: [
          // Couche de tuiles OpenStreetMap
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.apps_meteo',
          ),
          // Markers des villes
          MarkerLayer(markers: _buildMarkers(vm)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Recenter sur le centre de la carte
          _mapController.move(LatLng(7.0, 2.0), 6.5);
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
