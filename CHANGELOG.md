**
## [1.0.0] - 27/06/2026

### Nouvelles fonctionnalités
- Affichage de la météo en temps réel grâce à l'API Open-Meteo.
- Gestion de l'état de l'application avec Provider et l'architecture MVVM.
- Prise en charge de plusieurs villes : Cotonou, Parakou, Lagos et Abidjan.
- Possibilité d'ajouter une photo personnalisée pour chaque ville (galerie ou appareil photo).
- Localisation GPS pour détecter automatiquement la ville la plus proche.
- Notifications d'alerte en cas de forte chaleur (température supérieure à 33 °C).
- Tests unitaires des codes météo WMO et des conditions météorologiques dangereuses.
- Animations fluides (fondu, Hero et rotation de l'icône du soleil).
- Changement dynamique de la couleur de fond selon la température.
- Affichage détaillé de la météo actuelle ainsi que des prévisions.

### Aspects techniques
- Développé avec Flutter 3.22.0.
- Langage Dart 3.11.5.
- Utilisation de Provider pour la gestion de l'état.
- Utilisation de Dio pour les requêtes vers l'API météo.
- Utilisation de Geolocator pour la géolocalisation GPS.
- Utilisation de Flutter Local Notifications pour les notifications locales.
- Utilisation d'Image Picker pour sélectionner une image depuis la galerie ou l'appareil photo.