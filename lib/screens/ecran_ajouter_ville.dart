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
  bool _chargement = false;
  String? _erreur;

  @override
  void dispose() {
    _nomController.dispose();
    _paysController.dispose();
    super.dispose();
  }

  Future<void> _soumettreFormulaire() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _chargement = true;
      _erreur = null;
    });

    final nouvelleVille = Ville(
      nom: _nomController.text.trim(),
      pays: _paysController.text.trim(),
      temperature: 0, // sera remplacé par l'API
      condition: 'Variable', // sera remplacé par l'API
      humidite: 0, // sera remplacé par l'API
    );

    final vm = Provider.of<VilleViewModel>(context, listen: false);
    final succes = await vm.ajouterEtVerifierVille(nouvelleVille);

    if (!mounted) return;

    if (succes) {
      Navigator.pop(context);
    } else {
      setState(() {
        _chargement = false;
        _erreur = 'Ville introuvable. Vérifie le nom et réessaie.';
      });
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
                    hintText: 'Ex: Paris, Dakar, Lomé...',
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
                    hintText: 'Ex: France, Sénégal, Togo...',
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? 'Veuillez entrer un pays'
                      : null,
                ),
                const SizedBox(height: 32),

                if (_erreur != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _erreur!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                ElevatedButton(
                  onPressed: _chargement ? null : _soumettreFormulaire,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _chargement
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Enregistrer la ville'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
