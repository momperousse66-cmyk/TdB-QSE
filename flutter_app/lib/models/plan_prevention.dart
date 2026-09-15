import 'json_helpers.dart';

/// Registre "Plans de prévention".
class PlanPrevention {
  String id;
  String ville;
  String otp;
  String clientSite;
  String? responsable;
  DateTime? echeanceSource;
  String analyseFaite; // Oui | Non | NC
  String analyseEnvoyee;
  String signeIsor;
  String signeClient;
  String commenteAgents;
  String? dta;
  String? commentaires;
  String? source;

  PlanPrevention({
    required this.id,
    required this.ville,
    required this.otp,
    required this.clientSite,
    this.responsable,
    this.echeanceSource,
    this.analyseFaite = 'Non',
    this.analyseEnvoyee = 'Non',
    this.signeIsor = 'Non',
    this.signeClient = 'Non',
    this.commenteAgents = 'Non',
    this.dta,
    this.commentaires,
    this.source,
  });

  int? joursRestants(DateTime asOf) =>
      echeanceSource == null ? null : echeanceSource!.difference(asOf).inDays;

  String etatEcheance(DateTime asOf, int preavisJours) {
    final j = joursRestants(asOf);
    if (j == null) return 'À compléter';
    if (j < 0) return 'Expiré';
    if (j <= preavisJours) return 'À renouveler';
    return 'À jour';
  }

  bool pdpComplet(DateTime asOf) =>
      echeanceSource != null &&
      echeanceSource!.isAfter(asOf) &&
      analyseFaite == 'Oui' &&
      analyseEnvoyee == 'Oui' &&
      signeIsor == 'Oui' &&
      signeClient == 'Oui' &&
      commenteAgents == 'Oui';

  factory PlanPrevention.fromJson(Map<String, dynamic> j) => PlanPrevention(
        id: j['id'] as String,
        ville: j['ville'] as String,
        otp: j['otp'] as String? ?? '',
        clientSite: j['clientSite'] as String? ?? '',
        responsable: j['responsable'] as String?,
        echeanceSource: parseDate(j['echeanceSource']),
        analyseFaite: j['analyseFaite'] as String? ?? 'Non',
        analyseEnvoyee: j['analyseEnvoyee'] as String? ?? 'Non',
        signeIsor: j['signeIsor'] as String? ?? 'Non',
        signeClient: j['signeClient'] as String? ?? 'Non',
        commenteAgents: j['commenteAgents'] as String? ?? 'Non',
        dta: j['dta'] as String?,
        commentaires: j['commentaires'] as String?,
        source: j['source'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ville': ville,
        'otp': otp,
        'clientSite': clientSite,
        'responsable': responsable,
        'echeanceSource': dateToJson(echeanceSource),
        'analyseFaite': analyseFaite,
        'analyseEnvoyee': analyseEnvoyee,
        'signeIsor': signeIsor,
        'signeClient': signeClient,
        'commenteAgents': commenteAgents,
        'dta': dta,
        'commentaires': commentaires,
        'source': source,
      };
}
