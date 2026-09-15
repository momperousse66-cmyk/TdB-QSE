# TdB-QSE

Application Flutter de suivi de la qualité, de la sécurité et de
l'environnement (QSE), adaptée du tableau de bord `Lille_TDB QSE.xlsm`.

## Fonctionnalités

- Tableau de bord avec indicateurs KPI et graphiques.
- Suivi des actions, plans de prévention, contrôles qualité, échéances,
	réclamations et indicateurs mensuels.
- Gestion de plusieurs villes depuis la page **Options**.
- Calcul automatique des statuts : retard, expiration, renouvellement,
	complétude et doublons.
- Ajout, modification et suppression des lignes dans chaque registre.
- Données sauvegardées localement dans un fichier JSON ; aucun serveur requis.

## Prérequis

- Flutter stable avec un SDK Dart compatible avec `>=3.3.0 <4.0.0`.
- Un appareil ou une cible Flutter : Windows, Web, Android, iOS, Linux ou
	macOS.

## Lancer le projet

Depuis le dossier `flutter_app` :

```powershell
flutter pub get
flutter run -d windows
```

Pour lancer la version Web :

```powershell
flutter run -d chrome
```

Voir les cibles disponibles avec `flutter devices`.

## Structure

```text
flutter_app/
	lib/
		data/       Données de démarrage
		models/     Modèles et règles de calcul
		screens/    Dashboard, registres et Options
		services/   Sauvegarde et chargement local
		state/      État central de l'application
		widgets/    Composants réutilisables
```

## Données

Les données de démarrage sont définies dans
`flutter_app/lib/data/seed_data.dart`. Après lancement, les données saisies
sont conservées dans le répertoire local de documents de l'application.

## Licence

Projet interne TdB-QSE.