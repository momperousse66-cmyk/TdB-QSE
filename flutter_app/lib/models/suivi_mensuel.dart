import 'json_helpers.dart';

/// Registre "Suivi mensuel" (une ligne par ville et par mois).
class SuiviMensuel {
  String id;
  String ville;
  DateTime mois; // premier jour du mois
  double? tauxEcolabel; // fraction 0..1
  double? papierFeuilles;
  double? electriciteKwh;
  double? co2Kg;
  double? distanceKm;
  double? atAvecArret;
  double? atAnalyses;
  double? auditsPrevus;
  double? auditsRealises;
  double? satisfaction; // fraction 0..1
  double? avisSuivis;
  double? avisClotures;
  double? urgencesATraiter;
  double? urgencesTraitees;
  String? commentaires;

  SuiviMensuel({
    required this.id,
    required this.ville,
    required this.mois,
    this.tauxEcolabel,
    this.papierFeuilles,
    this.electriciteKwh,
    this.co2Kg,
    this.distanceKm,
    this.atAvecArret,
    this.atAnalyses,
    this.auditsPrevus,
    this.auditsRealises,
    this.satisfaction,
    this.avisSuivis,
    this.avisClotures,
    this.urgencesATraiter,
    this.urgencesTraitees,
    this.commentaires,
  });

  bool memeMois(DateTime autre) => mois.year == autre.year && mois.month == autre.month;

  factory SuiviMensuel.fromJson(Map<String, dynamic> j) => SuiviMensuel(
        id: j['id'] as String,
        ville: j['ville'] as String,
        mois: parseDate(j['mois']) ?? DateTime.now(),
        tauxEcolabel: asDouble(j['tauxEcolabel']),
        papierFeuilles: asDouble(j['papierFeuilles']),
        electriciteKwh: asDouble(j['electriciteKwh']),
        co2Kg: asDouble(j['co2Kg']),
        distanceKm: asDouble(j['distanceKm']),
        atAvecArret: asDouble(j['atAvecArret']),
        atAnalyses: asDouble(j['atAnalyses']),
        auditsPrevus: asDouble(j['auditsPrevus']),
        auditsRealises: asDouble(j['auditsRealises']),
        satisfaction: asDouble(j['satisfaction']),
        avisSuivis: asDouble(j['avisSuivis']),
        avisClotures: asDouble(j['avisClotures']),
        urgencesATraiter: asDouble(j['urgencesATraiter']),
        urgencesTraitees: asDouble(j['urgencesTraitees']),
        commentaires: j['commentaires'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ville': ville,
        'mois': dateToJson(mois),
        'tauxEcolabel': tauxEcolabel,
        'papierFeuilles': papierFeuilles,
        'electriciteKwh': electriciteKwh,
        'co2Kg': co2Kg,
        'distanceKm': distanceKm,
        'atAvecArret': atAvecArret,
        'atAnalyses': atAnalyses,
        'auditsPrevus': auditsPrevus,
        'auditsRealises': auditsRealises,
        'satisfaction': satisfaction,
        'avisSuivis': avisSuivis,
        'avisClotures': avisClotures,
        'urgencesATraiter': urgencesATraiter,
        'urgencesTraitees': urgencesTraitees,
        'commentaires': commentaires,
      };
}
