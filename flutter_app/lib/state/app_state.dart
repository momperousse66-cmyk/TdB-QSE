import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../data/seed_data.dart';
import '../models/action_item.dart';
import '../models/controle_qualite.dart';
import '../models/echeance.dart';
import '../models/parametres.dart';
import '../models/plan_prevention.dart';
import '../models/reclamation.dart';
import '../models/suivi_mensuel.dart';
import '../models/ville.dart';
import '../services/storage_service.dart';

/// État central de l'application : toutes les villes et tous les registres.
/// Un seul point d'entrée pour lire, modifier et persister les données,
/// ce qui rend le tableau de bord entièrement modifiable et réplicable
/// (ajouter une ville = ajouter une entrée dans [villes], sans toucher au code).
class AppState extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final _uuid = const Uuid();

  List<Ville> villes = [];
  Parametres parametres = Parametres();
  List<ActionItem> actions = [];
  List<PlanPrevention> plansPrevention = [];
  List<ControleQualite> controlesQualite = [];
  List<Echeance> echeances = [];
  List<Reclamation> reclamations = [];
  List<SuiviMensuel> suiviMensuel = [];

  String villeSelectionnee = SeedData.villeLille;
  DateTime moisSelectionne = DateTime(2026, 7, 1);
  DateTime dateSituation = DateTime(2026, 9, 14);

  bool _loaded = false;
  bool get loaded => _loaded;

  Future<void> load() async {
    final data = await _storage.load();
    if (data == null) {
      _seed();
    } else {
      _fromJson(data);
    }
    _loaded = true;
    notifyListeners();
  }

  void _seed() {
    villes = SeedData.villes();
    parametres = SeedData.parametres();
    actions = SeedData.actions();
    plansPrevention = SeedData.plansPrevention();
    controlesQualite = SeedData.controlesQualite();
    echeances = SeedData.echeances();
    reclamations = SeedData.reclamations();
    suiviMensuel = SeedData.suiviMensuel();
  }

  void _fromJson(Map<String, dynamic> j) {
    villes = (j['villes'] as List? ?? [])
        .map((e) => Ville.fromJson(e as Map<String, dynamic>))
        .toList();
    parametres = j['parametres'] == null
        ? Parametres()
        : Parametres.fromJson(j['parametres'] as Map<String, dynamic>);
    actions = (j['actions'] as List? ?? [])
        .map((e) => ActionItem.fromJson(e as Map<String, dynamic>))
        .toList();
    plansPrevention = (j['plansPrevention'] as List? ?? [])
        .map((e) => PlanPrevention.fromJson(e as Map<String, dynamic>))
        .toList();
    controlesQualite = (j['controlesQualite'] as List? ?? [])
        .map((e) => ControleQualite.fromJson(e as Map<String, dynamic>))
        .toList();
    echeances = (j['echeances'] as List? ?? [])
        .map((e) => Echeance.fromJson(e as Map<String, dynamic>))
        .toList();
    reclamations = (j['reclamations'] as List? ?? [])
        .map((e) => Reclamation.fromJson(e as Map<String, dynamic>))
        .toList();
    suiviMensuel = (j['suiviMensuel'] as List? ?? [])
        .map((e) => SuiviMensuel.fromJson(e as Map<String, dynamic>))
        .toList();
    if (villes.isNotEmpty && !villes.any((v) => v.nom == villeSelectionnee)) {
      villeSelectionnee = villes.first.nom;
    }
  }

  Map<String, dynamic> _toJson() => {
        'villes': villes.map((e) => e.toJson()).toList(),
        'parametres': parametres.toJson(),
        'actions': actions.map((e) => e.toJson()).toList(),
        'plansPrevention': plansPrevention.map((e) => e.toJson()).toList(),
        'controlesQualite': controlesQualite.map((e) => e.toJson()).toList(),
        'echeances': echeances.map((e) => e.toJson()).toList(),
        'reclamations': reclamations.map((e) => e.toJson()).toList(),
        'suiviMensuel': suiviMensuel.map((e) => e.toJson()).toList(),
      };

  Future<void> _persist() async => _storage.save(_toJson());

  String newId(String prefix) => '$prefix-${_uuid.v4().substring(0, 8)}';

  // ---- Villes : réplication du modèle pour un nouveau périmètre ----
  Future<void> ajouterVille(String nom) async {
    if (nom.trim().isEmpty || villes.any((v) => v.nom == nom)) return;
    villes.add(Ville(id: newId('v'), nom: nom.trim()));
    villeSelectionnee = nom.trim();
    await _persist();
    notifyListeners();
  }

  Future<void> supprimerVille(String nom) async {
    villes.removeWhere((v) => v.nom == nom);
    actions.removeWhere((e) => e.ville == nom);
    plansPrevention.removeWhere((e) => e.ville == nom);
    controlesQualite.removeWhere((e) => e.ville == nom);
    echeances.removeWhere((e) => e.ville == nom);
    reclamations.removeWhere((e) => e.ville == nom);
    suiviMensuel.removeWhere((e) => e.ville == nom);
    if (villeSelectionnee == nom && villes.isNotEmpty) {
      villeSelectionnee = villes.first.nom;
    }
    await _persist();
    notifyListeners();
  }

  Future<void> setVilleSelectionnee(String nom) async {
    villeSelectionnee = nom;
    notifyListeners();
  }

  Future<void> setMoisSelectionne(DateTime mois) async {
    moisSelectionne = DateTime(mois.year, mois.month, 1);
    notifyListeners();
  }

  Future<void> setDateSituation(DateTime date) async {
    dateSituation = date;
    notifyListeners();
  }

  Future<void> setParametres(Parametres p) async {
    parametres = p;
    await _persist();
    notifyListeners();
  }

  // ---- CRUD génériques par registre ----
  Future<void> upsertAction(ActionItem a) async {
    final i = actions.indexWhere((x) => x.id == a.id);
    if (i == -1) {
      actions.add(a);
    } else {
      actions[i] = a;
    }
    await _persist();
    notifyListeners();
  }

  Future<void> deleteAction(String id) async {
    actions.removeWhere((x) => x.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> upsertPlanPrevention(PlanPrevention p) async {
    final i = plansPrevention.indexWhere((x) => x.id == p.id);
    if (i == -1) {
      plansPrevention.add(p);
    } else {
      plansPrevention[i] = p;
    }
    await _persist();
    notifyListeners();
  }

  Future<void> deletePlanPrevention(String id) async {
    plansPrevention.removeWhere((x) => x.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> upsertControleQualite(ControleQualite c) async {
    final i = controlesQualite.indexWhere((x) => x.id == c.id);
    if (i == -1) {
      controlesQualite.add(c);
    } else {
      controlesQualite[i] = c;
    }
    await _persist();
    notifyListeners();
  }

  Future<void> deleteControleQualite(String id) async {
    controlesQualite.removeWhere((x) => x.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> upsertEcheance(Echeance e) async {
    final i = echeances.indexWhere((x) => x.id == e.id);
    if (i == -1) {
      echeances.add(e);
    } else {
      echeances[i] = e;
    }
    await _persist();
    notifyListeners();
  }

  Future<void> deleteEcheance(String id) async {
    echeances.removeWhere((x) => x.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> upsertReclamation(Reclamation r) async {
    final i = reclamations.indexWhere((x) => x.id == r.id);
    if (i == -1) {
      reclamations.add(r);
    } else {
      reclamations[i] = r;
    }
    await _persist();
    notifyListeners();
  }

  Future<void> deleteReclamation(String id) async {
    reclamations.removeWhere((x) => x.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> upsertSuiviMensuel(SuiviMensuel s) async {
    final i = suiviMensuel.indexWhere((x) => x.id == s.id);
    if (i == -1) {
      suiviMensuel.add(s);
    } else {
      suiviMensuel[i] = s;
    }
    await _persist();
    notifyListeners();
  }

  Future<void> deleteSuiviMensuel(String id) async {
    suiviMensuel.removeWhere((x) => x.id == id);
    await _persist();
    notifyListeners();
  }
}
