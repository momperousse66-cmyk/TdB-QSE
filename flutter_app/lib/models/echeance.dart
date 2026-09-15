import 'json_helpers.dart';

/// Registre "Échéances" (habilitations, VPO, exercices obligatoires).
class Echeance {
  String id;
  String ville;
  String famille; // Habilitation | VPO | Exercice
  String? site;
  String? personne;
  String? objet;
  DateTime? derniereRealisation;
  DateTime? prochaineEcheance;
  String? qualificationSource;
  String? commentaires;

  Echeance({
    required this.id,
    required this.ville,
    required this.famille,
    this.site,
    this.personne,
    this.objet,
    this.derniereRealisation,
    this.prochaineEcheance,
    this.qualificationSource,
    this.commentaires,
  });

  int? joursRestants(DateTime asOf) => prochaineEcheance == null
      ? null
      : prochaineEcheance!.difference(asOf).inDays;

  String etat(DateTime asOf, int preavisJours) {
    final j = joursRestants(asOf);
    if (j == null) return 'À compléter';
    if (j < 0) return 'Expiré';
    if (j <= preavisJours) return 'À renouveler';
    return 'À jour';
  }

  factory Echeance.fromJson(Map<String, dynamic> j) => Echeance(
        id: j['id'] as String,
        ville: j['ville'] as String,
        famille: j['famille'] as String? ?? '',
        site: j['site'] as String?,
        personne: j['personne'] as String?,
        objet: j['objet'] as String?,
        derniereRealisation: parseDate(j['derniereRealisation']),
        prochaineEcheance: parseDate(j['prochaineEcheance']),
        qualificationSource: j['qualificationSource'] as String?,
        commentaires: j['commentaires'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ville': ville,
        'famille': famille,
        'site': site,
        'personne': personne,
        'objet': objet,
        'derniereRealisation': dateToJson(derniereRealisation),
        'prochaineEcheance': dateToJson(prochaineEcheance),
        'qualificationSource': qualificationSource,
        'commentaires': commentaires,
      };
}
