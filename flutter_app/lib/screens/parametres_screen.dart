import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/parametres.dart';
import '../state/app_state.dart';

/// Page Options : gestion des villes (réplication du modèle) et des réglages communs.
class ParametresScreen extends StatefulWidget {
  const ParametresScreen({super.key});

  @override
  State<ParametresScreen> createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<ParametresScreen> {
  final _villeCtrl = TextEditingController();
  late TextEditingController _preavisCtrl;
  late TextEditingController _objQualiteCtrl;
  late TextEditingController _objPdpCtrl;
  late TextEditingController _delaiRcCtrl;

  @override
  void initState() {
    super.initState();
    final p = context.read<AppState>().parametres;
    _preavisCtrl = TextEditingController(text: p.preavisEcheanceJours.toString());
    _objQualiteCtrl =
        TextEditingController(text: p.objectifQualite == null ? '' : (p.objectifQualite! * 100).toString());
    _objPdpCtrl = TextEditingController(
        text: p.objectifPdpComplet == null ? '' : (p.objectifPdpComplet! * 100).toString());
    _delaiRcCtrl = TextEditingController(text: p.delaiReponseRcJours?.toString() ?? '');
  }

  @override
  void dispose() {
    _villeCtrl.dispose();
    _preavisCtrl.dispose();
    _objQualiteCtrl.dispose();
    _objPdpCtrl.dispose();
    _delaiRcCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveParametres() async {
    final state = context.read<AppState>();
    await state.setParametres(Parametres(
      preavisEcheanceJours: int.tryParse(_preavisCtrl.text) ?? 30,
      objectifQualite:
          _objQualiteCtrl.text.trim().isEmpty ? null : (double.tryParse(_objQualiteCtrl.text) ?? 0) / 100,
      objectifPdpComplet:
          _objPdpCtrl.text.trim().isEmpty ? null : (double.tryParse(_objPdpCtrl.text) ?? 0) / 100,
      delaiReponseRcJours: _delaiRcCtrl.text.trim().isEmpty ? null : int.tryParse(_delaiRcCtrl.text),
      themeMode: state.parametres.themeMode,
    ));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paramètres enregistrés')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Options')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Villes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text(
            'Ajouter une ville réplique le modèle QSE : les six registres et le tableau de bord '
            'deviennent immédiatement disponibles pour cette ville, sans copier de fichier.',
            style: TextStyle(color: Color(0xFF637588)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _villeCtrl,
                  decoration: const InputDecoration(labelText: 'Nouvelle ville', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () async {
                  await state.ajouterVille(_villeCtrl.text);
                  _villeCtrl.clear();
                },
                icon: const Icon(Icons.add),
                label: const Text('Ajouter'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...state.villes.map((v) => Card(
                child: ListTile(
                  title: Text(v.nom),
                  trailing: state.villes.length > 1
                      ? IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Supprimer la ville'),
                                content: Text(
                                    'Supprimer "${v.nom}" effacera toutes ses données dans les registres. Continuer ?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
                                  FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Supprimer')),
                                ],
                              ),
                            );
                            if (confirmed == true) await state.supprimerVille(v.nom);
                          },
                        )
                      : null,
                ),
              )),
          const Divider(height: 40),
          const Text('Réglages communs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: state.parametres.themeMode,
            decoration: const InputDecoration(labelText: 'Apparence', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'system', child: Text('Comme l\'OS')),
              DropdownMenuItem(value: 'light', child: Text('Mode clair')),
              DropdownMenuItem(value: 'dark', child: Text('Mode sombre')),
            ],
            onChanged: (value) {
              if (value != null) {
                state.setThemeMode(ThemeMode.values.firstWhere(
                  (mode) => mode.name == value,
                  orElse: () => ThemeMode.system,
                ));
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _preavisCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Préavis échéances (jours)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _objQualiteCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
                labelText: 'Objectif qualité (%)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _objPdpCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
                labelText: 'Objectif PdP complet (%)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _delaiRcCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Délai réponse réclamations (jours calendaires)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _saveParametres, child: const Text('Enregistrer les réglages')),
        ],
      ),
    );
  }
}
