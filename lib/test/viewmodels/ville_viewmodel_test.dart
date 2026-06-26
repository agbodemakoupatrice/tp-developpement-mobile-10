import 'package:flutter_test/flutter_test.dart';
import 'package:apps_meteo/viewmodels/ville_viewmodel.dart';
import 'package:apps_meteo/models/ville.dart';

void main() {
  late VilleViewModel vm;

  setUp(() {
    vm = VilleViewModel();
  });

  group('VilleViewModel', () {
    test('la liste initiale contient au moins 4 villes', () {
      expect(vm.villes.length, greaterThanOrEqualTo(4));
    });

    test('Cotonou est dans la liste initiale', () {
      final contientCotonou = vm.villes.any((v) => v.nom == 'Cotonou');
      expect(contientCotonou, isTrue);
    });

    test('selectionnerVille met a jour villeSelectionnee', () {
      final lagos = vm.villes.firstWhere((v) => v.nom == 'Lagos');
      vm.selectionnerVille(lagos);
      expect(vm.villeSelectionnee?.nom, equals('Lagos'));
    });

    // Exercice : ajouterVille augmente la liste de 1
    test('ajouterVille augmente la liste de 1', () {
      final avant = vm.villes.length;
      vm.ajouterVille(
        Ville(
          nom: 'TestVille',
          pays: 'TestPays',
          temperature: 25,
          condition: 'Ensoleille',
          humidite: 50,
        ),
      );
      expect(vm.villes.length, equals(avant + 1));
    });

    // Exercice : notifyListeners est appelé
    test('selectionnerVille notifie les listeners', () {
      int compteur = 0;
      vm.addListener(() => compteur++);

      final lagos = vm.villes.firstWhere((v) => v.nom == 'Lagos');
      vm.selectionnerVille(lagos);

      expect(compteur, greaterThan(0));
    });
  });
}
