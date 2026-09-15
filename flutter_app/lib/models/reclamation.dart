import 'json_helpers.dart';

/// Registre "Réclamations".
class Reclamation {
  String id;
  String ville;
  String? client;
  String categorie; // Réclamation | Avis | ...
  String? canal;
  DateTime? emission;
  DateTime? reception;
  DateTime? reponse;
  String? responsable;
  String? motif;
  String? actionMenee;
  String? etatActionSource;

  Reclamation({
    required this.id,
    required this.ville,
    this.client,
    this.categorie = 'Réclamation',
    this.canal,
    this.emission,
    this.reception,
    this.reponse,
    this.responsable,
    this.motif,
    this.actionMenee,
    this.etatActionSource,
  });

  int? delaiJours() =>
      (reception == null || reponse == null) ? null : reponse!.difference(reception!).inDays;

  String etatReponse(DateTime asOf, int? delaiCibleJours) {
    if (reception == null) return 'Réception manquante';
    if (reponse != null && reponse!.isBefore(reception!)) return 'Incohérent';
    if (delaiCibleJours == null) {
      return reponse != null ? 'Répondue / cible absente' : 'Sans réponse / cible absente';
    }
    if (reponse != null) {
      final d = delaiJours()!;
      return d <= delaiCibleJours ? 'Dans le délai' : 'Hors délai';
    }
    final attente = asOf.difference(reception!).inDays;
    return attente > delaiCibleJours ? 'Retard' : 'En attente';
  }

  factory Reclamation.fromJson(Map<String, dynamic> j) => Reclamation(
        id: j['id'] as String,
        ville: j['ville'] as String,
        client: j['client'] as String?,
        categorie: j['categorie'] as String? ?? 'Réclamation',
        canal: j['canal'] as String?,
        emission: parseDate(j['emission']),
        reception: parseDate(j['reception']),
        reponse: parseDate(j['reponse']),
        responsable: j['responsable'] as String?,
        motif: j['motif'] as String?,
        actionMenee: j['actionMenee'] as String?,
        etatActionSource: j['etatActionSource'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ville': ville,
        'client': client,
        'categorie': categorie,
        'canal': canal,
        'emission': dateToJson(emission),
        'reception': dateToJson(reception),
        'reponse': dateToJson(reponse),
        'responsable': responsable,
        'motif': motif,
        'actionMenee': actionMenee,
        'etatActionSource': etatActionSource,
      };
}
