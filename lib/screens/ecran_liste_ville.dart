import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_ajouter_ville.dart';

class EcranListeVilles extends StatelessWidget {
  const EcranListeVilles({super.key});

  @override
  Widget build(BuildContext context) {
    // Lecture de la liste des villes depuis le ViewModel
    final vm = context.watch<VilleViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir une ville'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: vm.villes.length,
        itemBuilder: (context, index) {
          final ville = vm.villes[index];
          final estSelectionnee = ville.nom == vm.villeSelectionnee?.nom;

          return ListTile(
            leading: Icon(
              Icons.location_city,
              color: estSelectionnee ? Colors.blue : Colors.grey,
            ),
            title: Text(
              ville.nom,
              style: TextStyle(
                fontWeight: estSelectionnee
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              '${ville.pays} - ${ville.temperature.toStringAsFixed(0)}°C',
            ),
            trailing: estSelectionnee
                ? const Icon(Icons.check_circle, color: Colors.blue)
                : null,
            onTap: () {
              // Sélection de la ville cliquée
              context.read<VilleViewModel>().selectionnerVille(ville);
              // Retour à l'écran d'accueil
              Navigator.pop(context);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // RETRAIT DU MOT-CLÉ CONST ICI POUR ÉVITER TOUT BLOCAGE DE COMPILATION
              builder: (_) => EcranAjouterVille(),
            ),
          );
        },
      ),
    );
  }
}
