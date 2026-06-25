import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ville.dart';
import '../viewmodels/ville_viewmodel.dart';

class EcranAjouterVille extends StatefulWidget {
  const EcranAjouterVille({super.key});

  @override
  State<EcranAjouterVille> createState() => _EcranAjouterVilleState();
}

class _EcranAjouterVilleState extends State<EcranAjouterVille> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _paysController = TextEditingController();
  final _tempController = TextEditingController();
  final _humiditeController = TextEditingController();

  String _conditionSelectionnee = 'Ensoleille';
  final List<String> _conditions = [
    'Ensoleille',
    'Nuageux',
    'Pluvieux',
    'Orageux',
    'Ventueux',
  ];

  @override
  void dispose() {
    _nomController.dispose();
    _paysController.dispose();
    _tempController.dispose();
    _humiditeController.dispose();
    super.dispose();
  }

  void _soumettreFormulaire() {
    if (_formKey.currentState!.validate()) {
      final double temp =
          double.tryParse(_tempController.text.replaceAll(',', '.')) ?? 20.0;
      final int hum = int.tryParse(_humiditeController.text) ?? 50;

      final nouvelleVille = Ville(
        nom: _nomController.text.trim(),
        pays: _paysController.text.trim(),
        temperature: temp,
        condition: _conditionSelectionnee,
        humidite: hum,
      );

      // Utilisation de la méthode universelle Provider pour éviter l'erreur d'état
      Provider.of<VilleViewModel>(
        context,
        listen: false,
      ).ajouterVille(nouvelleVille);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une ville'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la ville',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? 'Veuillez entrer un nom'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _paysController,
                  decoration: const InputDecoration(
                    labelText: 'Pays',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? 'Veuillez entrer un pays'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tempController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Température (°C)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return 'Veuillez entrer une température';
                    if (double.tryParse(val.replaceAll(',', '.')) == null)
                      return 'Nombre invalide';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _humiditeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Humidité (%)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return 'Veuillez entrer l\'humidité';
                    final j = int.tryParse(val);
                    if (j == null || j < 0 || j > 100) return 'Entre 0 et 100';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _conditionSelectionnee,
                  decoration: const InputDecoration(
                    labelText: 'Condition météo',
                    border: OutlineInputBorder(),
                  ),
                  items: _conditions
                      .map(
                        (String c) =>
                            DropdownMenuItem(value: c, child: Text(c)),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null)
                      setState(() => _conditionSelectionnee = val);
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _soumettreFormulaire,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Enregistrer la ville'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
