import 'package:flutter/foundation.dart';
import '../models/ville.dart';
import '../models/meteo_data.dart';
import '../models/prevision_jour.dart';
import '../services/meteo_service.dart';

class VilleViewModel extends ChangeNotifier {
  List<Ville> _villes = [];
  Ville? _villeSelectionnee;
  final MeteoService _meteoService = MeteoService();
  final Map<String, (MeteoData, DateTime)> _cache = {};
  MeteoData? _meteoActuelle;
  bool _chargement = false;
  String? _erreur;
  List<PrevisionJour> _previsions = [];

  List<Ville> get villes => _villes;
  Ville? get villeSelectionnee => _villeSelectionnee;
  MeteoData? get meteoActuelle => _meteoActuelle;
  bool get chargement => _chargement;
  String? get erreur => _erreur;
  List<PrevisionJour> get previsions => _previsions;

  VilleViewModel() {
    _initialiser();
    if (_villeSelectionnee != null) {
      selectionnerVille(_villeSelectionnee!);
    }
  }

  void _initialiser() {
    _villes = [
      Ville(
        nom: 'Cotonou',
        pays: 'Benin',
        temperature: 29,
        condition: 'Ensoleille',
        humidite: 75,
      ),
      Ville(
        nom: 'Parakou',
        pays: 'Benin',
        temperature: 32,
        condition: 'Ensoleille',
        humidite: 60,
      ),
      Ville(
        nom: 'Lagos',
        pays: 'Nigeria',
        temperature: 31,
        condition: 'Nuageux',
        humidite: 80,
      ),
      Ville(
        nom: 'Abidjan',
        pays: 'CI',
        temperature: 27,
        condition: 'Pluvieux',
        humidite: 85,
      ),
      Ville(
        nom: 'Natitingou',
        pays: 'Benin',
        temperature: 26,
        condition: 'Ventueux',
        humidite: 50,
      ),
      Ville(
        nom: 'Ouidah',
        pays: 'Benin',
        temperature: 28,
        condition: 'Orageux',
        humidite: 90,
      ),
      Ville(
        nom: 'Porto-Novo',
        pays: 'Benin',
        temperature: 48,
        condition: 'Orageux',
        humidite: 84,
      ),
    ];
    _villeSelectionnee = _villes.first;
    notifyListeners();
  }

  void ajouterVille(Ville ville) {
    _villes.add(ville);
    notifyListeners();
  }

  Future<void> selectionnerVille(Ville ville) async {
    _villeSelectionnee = ville;

    if (_cache.containsKey(ville.nom)) {
      final (meteoCache, dateCache) = _cache[ville.nom]!;
      if (DateTime.now().difference(dateCache).inMinutes < 30) {
        _meteoActuelle = meteoCache;
        _previsions = meteoCache.previsions;
        notifyListeners();
        return;
      }
    }

    _chargement = true;
    _erreur = null;
    notifyListeners();

    final meteo = await _meteoService.getMeteo(ville.nom);

    if (meteo != null) {
      _meteoActuelle = meteo;
      _previsions = meteo.previsions;
      _cache[ville.nom] = (meteo, DateTime.now());
    } else {
      _erreur = 'Impossible de charger la météo';
      _previsions = [];
    }

    _chargement = false;
    notifyListeners();
  }

  Future<bool> ajouterEtVerifierVille(Ville ville) async {
    // Tester si l'API trouve la ville
    final meteo = await _meteoService.getMeteo(ville.nom);

    if (meteo == null) return false; // ville introuvable

    _villes.add(ville);
    notifyListeners();
    return true;
  }
}
