# README.md

```markdown
# Projet SOTRACO - Système d'Optimisation du Transport Public

Système d'analyse et d'optimisation du réseau de transport SOTRACO à Ouagadougou.

## Membres du Groupe

- **KAFANDO Aminata** - Développeur Backend & Optimisation
- **SANOU Dakho Jean Thibaut** - Analyste de Données & Interface

## Vidéos de Présentation

- **Vidéo KAFANDO Aminata** : https://youtu.be/u1_CwXgbKf8?si=bpnv1S6RGdrb2gkd
- **Vidéo SANOU Dakho Jean Thibaut** : https://youtu.be/-UWh5Jwy5UI

## Description du Projet

Ce projet vise à optimiser le réseau de transport public SOTRACO de Ouagadougou en analysant les données de fréquentation réelles. Le système identifie les heures de pointe, calcule les taux d'occupation, détecte les lignes sous-utilisées ou surchargées, et génère automatiquement des recommandations stratégiques pour améliorer l'efficacité du réseau.

## Fonctionnalités Principales

### Analyses
- Calcul de la fréquentation moyenne par ligne
- Identification des heures de pointe du réseau
- Calcul du taux d'occupation global des bus
- Détection des arrêts les plus fréquentés
- Analyse de la répartition géographique par zone
- Tendances de fréquentation hebdomadaires
- Détection des lignes sous-utilisées et surchargées

### Optimisation
- Optimisation des fréquences fixes par ligne
- Optimisation des fréquences variables par période (pointe/normale/creuse)
- Calcul des fréquences optimales selon la demande

### Visualisation
- Graphiques ASCII pour affichage en terminal
- Barres de progression pour les taux d'occupation
- Histogrammes de fréquentation par heure
- Classements et statistiques détaillées

### Rapports
- Génération de rapports complets avec toutes les métriques
- Recommandations stratégiques automatiques
- Résumés exécutifs pour la direction
- Export des résultats en format CSV

## Installation

### Prérequis
- Julia version 1.11 ou supérieure
- Connexion internet pour l'installation des dépendances

### Instructions

1. Installer Julia depuis le site officiel : https://julialang.org/downloads/

2. Cloner le dépôt du projet :
```bash
git clone https://github.com/KAFANDO-AMINATA/Projet-SOTRACO-groupe-5.git
cd Projet_SOTRACO_Julia
```

3. Installer les dépendances :
```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

Les dépendances requises sont :
- CSV.jl : lecture et écriture de fichiers CSV
- DataFrames.jl : manipulation de données tabulaires
- Dates : gestion des dates et heures
- Statistics : calculs statistiques

## Structure du Projet

```
Projet_SOTRACO_Julia/
├── data/
│   ├── lignes_bus.csv         # Données des lignes de bus
│   ├── arrets.csv             # Données des arrêts
│   └── frequentation.csv      # Données de fréquentation
├── src/
│   ├── backend_optimisation/
│   │   ├── types.jl           # Structures de données (Aminata)
│   │   ├── io_operations.jl   # Chargement et export CSV (Aminata)
│   │   └── optimisation.jl    # Algorithmes d'optimisation (Aminata)
│   ├── analyse.jl             # Analyses statistiques (Dakho)
│   ├── visualisation.jl       # Visualisations ASCII (Dakho)
│   ├── rapports.jl            # Génération de rapports (Dakho)
│   └── main.jl                # Interface utilisateur (Dakho)
├── test/
│   └── runtests.jl            # Tests unitaires
├── resultats/                 # Dossier pour les exports
├── Project.toml               # Configuration des dépendances
├── Manifest.toml              # Versions exactes des dépendances
└── README.md                  # Ce fichier
```

## Utilisation

### Lancer le système

Pour démarrer l'interface interactive :

```bash
julia src/main.jl
```

### Menu principal

Le système propose 7 options :

1. **Analyser la fréquentation** : Affiche les statistiques de fréquentation par ligne et les heures de pointe
2. **Optimiser les lignes** : Calcule les fréquences optimales pour chaque ligne
3. **Générer un rapport complet** : Crée un rapport détaillé avec toutes les analyses
4. **Visualiser le réseau** : Affiche le taux d'occupation et les arrêts populaires
5. **Exporter les données** : Sauvegarde les résultats en format CSV
6. **Recommandations** : Génère des recommandations stratégiques d'optimisation
7. **Quitter** : Ferme le système

### Exemples d'utilisation

#### Analyser la fréquentation
Choisissez l'option 1 pour voir :
- La fréquentation moyenne de chaque ligne classée par ordre décroissant
- Les trois heures de pointe du réseau avec graphiques ASCII

#### Générer un rapport complet
Choisissez l'option 3 pour obtenir :
- Informations générales du réseau
- Statistiques détaillées par ligne
- Heures de pointe identifiées
- Taux d'occupation global avec évaluation
- Top 5 des arrêts les plus fréquentés
- Répartition par zone géographique
- Tendances hebdomadaires
- Recommandations stratégiques automatiques

#### Optimiser les lignes
Choisissez l'option 2 pour calculer :
- Les fréquences fixes optimales par ligne
- Les fréquences variables par période (pointe, normale, creuse)

## Tests

Le projet inclut une suite de tests unitaires pour valider le bon fonctionnement de tous les modules.

### Exécuter tous les tests

```bash
julia test/runtests.jl
```

### Tests inclus

**Tests du module analyse.jl (Dakho) :**
- Analyse de fréquentation par ligne
- Identification des heures de pointe
- Calcul du taux d'occupation
- Analyse des arrêts populaires
- Détection des lignes sous-utilisées
- Calcul des statistiques par zone

**Tests du module visualisation.jl (Dakho) :**
- Affichage des statistiques sans erreur
- Affichage des heures de pointe
- Affichage du taux d'occupation
- Affichage des arrêts populaires

**Tests du module rapports.jl (Dakho) :**
- Génération de rapport complet
- Affichage des informations générales
- Génération des recommandations
- Export CSV

**Tests du module optimisation.jl (Aminata) :**
- Tests des fonctions d'optimisation
- Validation des fréquences calculées

**Tests de robustesse :**
- Comportement avec données vides
- Gestion des erreurs

## Contributions

### KAFANDO Aminata (50%)

**Modules développés :**
- types.jl : Définition des structures de données (Ligne, Arret, Frequentation, StatistiquesLigne, StatistiquesArret)
- io_operations.jl : Fonctions de chargement des fichiers CSV et export des résultats
- optimisation.jl : Algorithmes d'optimisation des fréquences (fixe et variable)

**Responsabilités :**
- Architecture des structures de données
- Import et validation des données CSV
- Algorithmes d'optimisation des ressources
- Calculs des fréquences optimales
- Tests unitaires des modules backend
- Documentation du code backend

### SANOU Dakho Jean Thibaut (50%)

**Modules développés :**
- analyse.jl : Fonctions d'analyse statistique des données de fréquentation
- visualisation.jl : Affichage des résultats avec graphiques ASCII
- rapports.jl : Génération de rapports complets et recommandations
- main.jl : Interface utilisateur interactive avec menu

**Responsabilités :**
- Analyses statistiques des données
- Identification des patterns de fréquentation
- Visualisations en mode texte (graphiques ASCII)
- Génération de rapports structurés
- Système de recommandations automatiques
- Interface utilisateur interactive
- Tests unitaires des modules d'analyse
- Documentation du code frontend

## Technologies Utilisées

- **Langage** : Julia 1.11.6
- **Bibliothèques** :
  - CSV.jl : Lecture et écriture de fichiers CSV
  - DataFrames.jl : Manipulation de données tabulaires
  - Dates : Gestion des dates et heures
  - Statistics : Calculs statistiques (moyenne, etc.)
  - Test : Framework de tests unitaires

## Format des Données

### lignes_bus.csv
Contient les informations sur les lignes de bus :
- id : Identifiant unique de la ligne
- nom_ligne : Nom de la ligne
- origine : Point de départ
- destination : Point d'arrivée
- distance_km : Distance totale en kilomètres
- duree_trajet_min : Durée du trajet en minutes
- tarif_fcfa : Tarif en francs CFA
- frequence_min : Fréquence actuelle en minutes
- statut : Statut de la ligne (Actif/Inactif)

### arrets.csv
Contient les informations sur les arrêts :
- id : Identifiant unique de l'arrêt
- nom_arret : Nom de l'arrêt
- quartier : Quartier de l'arrêt
- zone : Zone géographique
- latitude : Coordonnée latitude
- longitude : Coordonnée longitude
- abribus : Présence d'un abribus (Oui/Non)
- eclairage : Présence d'éclairage (Oui/Non)
- lignes_desservies : Liste des lignes passant par cet arrêt

### frequentation.csv
Contient les mesures de fréquentation :
- id : Identifiant unique de la mesure
- date : Date de la mesure
- heure : Heure de la mesure
- ligne_id : Identifiant de la ligne
- arret_id : Identifiant de l'arrêt
- montees : Nombre de passagers montés
- descentes : Nombre de passagers descendus
- occupation_bus : Nombre de passagers dans le bus
- capacite_bus : Capacité totale du bus

## Résultats et Exports

Les résultats peuvent être exportés au format CSV dans le dossier `resultats/`. Les fichiers générés incluent :
- analyse_sotraco_[timestamp].csv : Statistiques de fréquentation par ligne
- rapport_sotraco_[timestamp].txt : Rapport complet en format texte

## Améliorations Futures

- Ajout de visualisations graphiques avec Plots.jl
- Prédiction de la demande avec des modèles de machine learning
- Interface web pour consultation à distance
- Système d'alertes en temps réel
- Intégration avec des données GPS des bus
- Application mobile pour les usagers

## Licence

Ce projet a été réalisé dans le cadre du cours de Programmation Julia.

## Contact

Pour toute question sur le projet, veuillez contacter :
- KAFANDO Aminata
- SANOU Dakho Jean Thibaut

## Remerciements

Nous remercions notre enseignant Roland Kalmogo de la Programmation Julia pour son encadrement et ses conseils tout au long de ce projet.
```