class PrevisionJour {
  final DateTime date;
  final double temperatureMax;
  final double temperatureMin;
  final int weatherCode;

  PrevisionJour({
    required this.date,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.weatherCode,
  });

  String get conditionTexte {
    if (weatherCode == 0) return 'Ensoleillé';
    if (weatherCode <= 3) return 'Nuageux';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Pluvieux';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Averses';
    if (weatherCode >= 95) return 'Orageux';
    return 'Variable';
  }

  String get jour {
    const jours = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

    return jours[date.weekday - 1];
  }
}
