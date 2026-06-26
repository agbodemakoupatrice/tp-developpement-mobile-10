import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:apps_meteo/viewmodels/ville_viewmodel.dart';
import 'package:apps_meteo/screens/ecran_accueil.dart';
import 'package:apps_meteo/screens/ecran_liste_ville.dart';

Widget creerAppTest() {
  return ChangeNotifierProvider(
    create: (_) => VilleViewModel(),
    child: const MaterialApp(home: EcranAccueil()),
  );
}

void main() {
  testWidgets('EcranAccueil affiche une AppBar avec le titre', (tester) async {
    await tester.pumpWidget(creerAppTest());
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('AppMeteo'), findsOneWidget);
  });

  testWidgets('EcranAccueil affiche une Temperature', (tester) async {
    await tester.pumpWidget(creerAppTest());
    await tester.pumpAndSettle();

    final textFinder = find.textContaining('°C');
    expect(textFinder, findsWidgets);
  });

  testWidgets('Le bouton Changer de ville est present', (tester) async {
    await tester.pumpWidget(creerAppTest());
    await tester.pumpAndSettle();

    expect(find.text('Changer de ville'), findsOneWidget);
  });

  // Exercice : appuyer sur Changer de ville ouvre la liste
  testWidgets('Appuyer sur Changer de ville ouvre la liste', (tester) async {
    await tester.pumpWidget(creerAppTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Changer de ville'));
    await tester.pumpAndSettle();

    expect(find.byType(EcranListeVilles), findsOneWidget);
  });
}
