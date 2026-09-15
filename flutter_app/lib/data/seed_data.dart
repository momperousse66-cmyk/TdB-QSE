import '../models/action_item.dart';
import '../models/controle_qualite.dart';
import '../models/echeance.dart';
import '../models/parametres.dart';
import '../models/plan_prevention.dart';
import '../models/reclamation.dart';
import '../models/suivi_mensuel.dart';
import '../models/ville.dart';

/// Données de démarrage reprises du classeur `Lille_TDB QSE.xlsm` (échantillon
/// représentatif). Modifiable et extensible depuis l'application : ce n'est
/// qu'un point de départ, pas une limite du nombre de lignes.
class SeedData {
  static const villeLille = 'Lille';

  static List<Ville> villes() => [Ville(id: 'v-lille', nom: villeLille)];

  static Parametres parametres() => Parametres(
        preavisEcheanceJours: 30,
        objectifQualite: null,
        objectifPdpComplet: null,
        delaiReponseRcJours: null,
      );

  static List<SuiviMensuel> suiviMensuel() {
    final list = <SuiviMensuel>[];
    for (var m = 1; m <= 12; m++) {
      list.add(SuiviMensuel(
        id: 'sm-2026-$m',
        ville: villeLille,
        mois: DateTime(2026, m, 1),
        // Taux écolabellisés réels issus de l'onglet "TX ECO" (janvier/février).
        tauxEcolabel: m == 1 ? 0.3853 : (m == 2 ? 0.4508 : null),
        avisSuivis: m == 9 ? 24 : null,
        avisClotures: m == 9 ? 23 : null,
        commentaires: m == 9
            ? "Restrictions!A11:M34 : état constaté au 14/09/2026. Les autres mesures restent à renseigner."
            : (m <= 2 ? 'TX ECO!B${m + 2}. Taux source, base de pondération non disponible.' : null),
      ));
    }
    return list;
  }

  static List<ActionItem> actions() => [
        ActionItem(
          id: 'ac-1',
          ville: villeLille,
          idAction: 'AP-016',
          famille: 'Processus',
          origine: 'Site Lille centre',
          ouverture: DateTime(2026, 3, 4),
          probleme: 'Tri des déchets non conforme sur le dépôt',
          actionARealiser: 'Réorganiser les points de tri et former les équipes',
          responsable: 'Responsable QSE',
          echeance: DateTime(2026, 6, 30),
          realisation: DateTime(2026, 6, 20),
          evaluation: 'Efficace',
          preuves: "Photos avant/après, feuille d'émargement formation",
          source: "Plan d'actions!A16:L16",
        ),
        ActionItem(
          id: 'ac-2',
          ville: villeLille,
          idAction: 'AP-017',
          famille: 'Processus',
          origine: 'Agence',
          ouverture: DateTime(2026, 4, 10),
          probleme: 'Fiches de données de sécurité obsolètes',
          actionARealiser: 'Mettre à jour le classeur FDS',
          responsable: 'Assistante QSE',
          echeance: DateTime(2026, 9, 1),
          evaluation: 'Non vérifiée',
          source: "Plan d'actions!A17:L17",
        ),
        ActionItem(
          id: 'ac-3',
          ville: villeLille,
          idAction: 'AC-021',
          famille: 'Audit chantier',
          origine: 'Chantier Roubaix',
          ouverture: DateTime(2026, 5, 2),
          probleme: 'Absence de balisage zone de circulation engins',
          actionARealiser: 'Installer un balisage permanent et affichage consignes',
          responsable: 'Chef de chantier',
          echeance: DateTime(2026, 7, 15),
          evaluation: 'Non vérifiée',
          source: "Plan d'actions - Audit chantier!A21:L21",
        ),
      ];

  static List<PlanPrevention> plansPrevention() => [
        PlanPrevention(
          id: 'pdp-1',
          ville: villeLille,
          otp: 'C/005847',
          clientSite: 'Client A - Site principal',
          responsable: 'Chargé d\'affaires',
          echeanceSource: DateTime(2027, 1, 15),
          analyseFaite: 'Oui',
          analyseEnvoyee: 'Oui',
          signeIsor: 'Oui',
          signeClient: 'Oui',
          commenteAgents: 'Oui',
          source: 'Suivi PdP!A12',
        ),
        PlanPrevention(
          id: 'pdp-2',
          ville: villeLille,
          otp: 'C/006112',
          clientSite: 'Client B - Entrepôt',
          responsable: 'Chargé d\'affaires',
          echeanceSource: DateTime(2026, 10, 5),
          analyseFaite: 'Oui',
          analyseEnvoyee: 'Non',
          signeIsor: 'Oui',
          signeClient: 'Non',
          commenteAgents: 'NC',
          source: 'Suivi PdP!A13',
        ),
      ];

  static List<ControleQualite> controlesQualite() {
    final list = <ControleQualite>[];
    final notes = [0.98, 0.94, 0.90, 0.97, 0.93, 0.96];
    for (var i = 0; i < notes.length; i++) {
      list.add(ControleQualite(
        id: 'cq-$i',
        ville: villeLille,
        site: 'Site ${i + 1}',
        type: i.isEven ? 'Prestation régulière' : 'Prestation ponctuelle',
        controleur: 'Contrôleur qualité',
        dateRealisee: DateTime(2026, 7, 1 + i),
        note: notes[i],
      ));
    }
    return list;
  }

  static List<Echeance> echeances() => [
        Echeance(
          id: 'hab-1',
          ville: villeLille,
          famille: 'Habilitation',
          site: 'Agence Lille',
          personne: 'Jean Dupont',
          objet: 'Habilitation électrique B0',
          derniereRealisation: DateTime(2024, 9, 20),
          prochaineEcheance: DateTime(2026, 9, 20),
          qualificationSource: 'Suivi Habilitations!A9',
        ),
        Echeance(
          id: 'vpo-1',
          ville: villeLille,
          famille: 'VPO',
          site: 'Agence Lille',
          personne: 'Autolaveuse AL-12',
          objet: 'Vérification périodique obligatoire',
          derniereRealisation: DateTime(2025, 11, 3),
          prochaineEcheance: DateTime(2026, 11, 3),
          qualificationSource: 'Suivi VPO!A20',
        ),
        Echeance(
          id: 'ex-1',
          ville: villeLille,
          famille: 'Exercice',
          site: 'Agence Lille',
          personne: 'Équipe évacuation',
          objet: 'Exercice évacuation incendie',
          derniereRealisation: DateTime(2026, 3, 12),
          prochaineEcheance: DateTime(2026, 9, 12),
          qualificationSource: 'Exercices Obligatoires!A15',
        ),
      ];

  static List<Reclamation> reclamations() => [
        Reclamation(
          id: 'rc-1',
          ville: villeLille,
          client: 'Client A',
          categorie: 'Réclamation',
          canal: 'Téléphone',
          emission: DateTime(2026, 8, 1),
          reception: DateTime(2026, 8, 1),
          reponse: DateTime(2026, 8, 5),
          responsable: 'Responsable QSE',
          motif: 'Prestation de nettoyage incomplète',
          actionMenee: 'Reprise de la prestation, rappel des consignes',
        ),
        Reclamation(
          id: 'rc-2',
          ville: villeLille,
          client: 'Client B',
          categorie: 'Réclamation',
          canal: 'Email',
          emission: DateTime(2026, 8, 20),
          reception: DateTime(2026, 8, 21),
          responsable: 'Responsable QSE',
          motif: 'Retard de livraison de consommables',
        ),
      ];
}
