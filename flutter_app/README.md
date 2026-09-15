# Tableau de bord QSE — application Flutter

Application Flutter reprenant le classeur `Lille_TDB QSE.xlsm` sous forme de
tableau de bord **modifiable** et **réplicable** par ville.

## Principes

- **Réplicable** : les données ne sont pas codées en dur par ville. Le module
  `Paramètres` permet d'ajouter une nouvelle ville ; les six registres et le
  tableau de bord deviennent immédiatement disponibles pour elle, avec les
  mêmes calculs (statuts, échéances, indices) que pour Lille — exactement le
  principe de la note « 6. Répliquer pour une ville » du classeur source.
- **Modifiable** : chaque registre (Actions, Plans de prévention, Contrôles
  qualité, Échéances, Réclamations, Suivi mensuel) est un tableau éditable
  (ajout/édition/suppression de lignes) via un formulaire générique. Les
  statuts (Retard, Expiré, À renouveler, À jour, Doublon...) sont recalculés
  automatiquement, comme les formules Excel d'origine.
- **Données locales** : tout est stocké dans un fichier JSON unique
  (répertoire documents de l'application), rechargé au démarrage. Aucune
  donnée n'est envoyée à un serveur.

## Structure du code

```
lib/
  models/       Modèles de données + règles de calcul (statuts, échéances)
  data/         Données de démarrage (échantillon repris du classeur Lille)
  state/        AppState (ChangeNotifier) : source de vérité + persistance
  services/     Sauvegarde/chargement JSON local
  widgets/      Formulaire générique, tableau générique, cartes KPI, badges
  screens/      Tableau de bord, un écran par registre, Paramètres
```

Le tableau et le formulaire d'édition (`GenericRegisterScreen`,
`showRecordFormDialog`) sont génériques : ajouter un nouveau registre ou un
nouveau champ ne demande qu'une liste de `FieldSpec`, pas un nouvel écran.

## Données de démarrage

`lib/data/seed_data.dart` contient un échantillon représentatif des données
réellement présentes dans `Lille_TDB QSE.xlsm` (ex. taux écolabellisés
janvier/février réels, effectifs de restrictions au 14/09/2026). Ce n'est pas
une transcription exhaustive des ~184 lignes du classeur : complétez
directement dans l'application, qui accepte un nombre illimité de lignes par
registre (contrairement aux 500 lignes figées du classeur Excel).

## Lancer l'application

Flutter n'est pas installé dans cet environnement d'exécution ; à faire sur
votre poste :

```powershell
# 1) Installer le SDK Flutter si nécessaire : https://docs.flutter.dev/get-started/install
flutter --version

# 2) Depuis le dossier flutter_app
flutter pub get
flutter run -d windows   # ou -d chrome, -d edge, -d <un appareil connecté>
```

Pour générer les projets natifs (Windows/Web/Android...), lancez d'abord
`flutter create .` dans ce dossier afin que Flutter ajoute les répertoires
`windows/`, `web/`, etc. adaptés à votre poste (ils ne sont pas inclus ici).

## Prochaines étapes possibles

- Import/export CSV ou JSON pour transférer l'historique complet du classeur.
- Authentification / synchronisation multi-poste si plusieurs personnes
  doivent modifier le même tableau de bord.
