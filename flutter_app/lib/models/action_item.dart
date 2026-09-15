import 'json_helpers.dart';

/// Registre "Actions" (plans d'actions et audits chantier).
class ActionItem {
  String id;
  String ville;
  String idAction;
  String famille; // Processus | Audit chantier
  String? origine;
  DateTime? ouverture;
  String probleme;
  String actionARealiser;
  String? responsable;
  DateTime? echeance;
  DateTime? realisation;
  String? evaluation; // Non vérifiée | Efficace | A revoir
  String? preuves;
  String? source;

  ActionItem({
    required this.id,
    required this.ville,
    required this.idAction,
    required this.famille,
    this.origine,
    this.ouverture,
    this.probleme = '',
    this.actionARealiser = '',
    this.responsable,
    this.echeance,
    this.realisation,
    this.evaluation,
    this.preuves,
    this.source,
  });

  /// Reprend la logique de la colonne "Avancement calculé" du classeur source.
  String avancement(DateTime asOf) {
    if (actionARealiser.trim().isEmpty) return 'À compléter';
    if (realisation != null && !realisation!.isAfter(asOf)) return 'Réalisée';
    if (echeance == null) return 'À compléter';
    if (echeance!.isBefore(asOf)) return 'Retard';
    return 'À venir';
  }

  int retardJours(DateTime asOf) {
    if (echeance == null || avancement(asOf) != 'Retard') return 0;
    return asOf.difference(echeance!).inDays;
  }

  factory ActionItem.fromJson(Map<String, dynamic> j) => ActionItem(
        id: j['id'] as String,
        ville: j['ville'] as String,
        idAction: j['idAction'] as String,
        famille: j['famille'] as String,
        origine: j['origine'] as String?,
        ouverture: parseDate(j['ouverture']),
        probleme: j['probleme'] as String? ?? '',
        actionARealiser: j['actionARealiser'] as String? ?? '',
        responsable: j['responsable'] as String?,
        echeance: parseDate(j['echeance']),
        realisation: parseDate(j['realisation']),
        evaluation: j['evaluation'] as String?,
        preuves: j['preuves'] as String?,
        source: j['source'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ville': ville,
        'idAction': idAction,
        'famille': famille,
        'origine': origine,
        'ouverture': dateToJson(ouverture),
        'probleme': probleme,
        'actionARealiser': actionARealiser,
        'responsable': responsable,
        'echeance': dateToJson(echeance),
        'realisation': dateToJson(realisation),
        'evaluation': evaluation,
        'preuves': preuves,
        'source': source,
      };
}
