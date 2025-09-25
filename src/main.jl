using Dates

# Imports du travail des deux membres
include("backend_optimisation/types.jl")           # Membre 1 - Structures de données
include("backend_optimisation/io_operations.jl")   # Membre 1 - Chargement des données  
include("backend_optimisation/optimisation.jl")    # Membre 1 - Optimisation des fréquences
include("analyse.jl")         # Membre 2 - Analyses de données
include("visualisation.jl")   # Membre 2 - Visualisations
include("rapports.jl")        # Membre 2 - Génération de rapports

function afficher_menu_principal()
    """Affiche le menu principal du système"""
    println("\n" * "="^50)
    println("     SYSTEME D'OPTIMISATION SOTRACO")
    println("="^50)
    println()
    println("1. Analyser la fréquentation")
    println("2. Optimiser les lignes") 
    println("3. Générer un rapport complet")
    println("4. Visualiser le réseau")
    println("5. Exporter les données")
    println("6. Recommandations")
    println("7. Quitter")
    println()
    print("Votre choix (1-7): ")
end

function executer_analyse_frequentation(lignes, arrets, frequentations)
    """Execute l'analyse de fréquentation"""
    println("\nANALYSE DE FREQUENTATION")
    println("-"^40)
    
    # Utilise les fonctions du Membre 2
    ligne_stats = analyser_frequentation_par_ligne(frequentations)
    afficher_stats_ligne(ligne_stats, lignes)
    
    heures_pointe = identifier_heures_pointe(frequentations)
    afficher_heures_pointe(heures_pointe)
    
    print("\nAppuyez sur Entrée pour continuer...")
    readline()
end


function executer_optimisation_lignes(lignes, frequentations)
    """Execute l'optimisation des lignes"""
    println("\nOPTIMISATION DES LIGNES")
    println("-"^40)
    
    for ligne in lignes
        # Optimisation fixe - Membre 1
        freq_opt = optimiser_frequence_fixe(ligne, frequentations)
        println("$(ligne.nom_ligne) → fréquence fixe optimisée : $freq_opt min")

        # Optimisation variable - Membre 1
        freq_var = optimiser_frequence_variable(ligne, frequentations)
        if !isempty(freq_var)
            println("   Fréquences variables par période :")
            for (periode, freq) in freq_var
                println("     - $periode : $freq min")
            end
        end

        println()
    end

    print("\nAppuyez sur Entrée pour continuer...")
    readline()
end


function executer_visualisation(arrets, frequentations)
    """Execute la visualisation du réseau"""
    println("\nVISUALISATION DU RESEAU")
    println("-"^40)
    
    # Utilise les fonctions du Membre 2
    taux_occupation = calculer_taux_occupation(frequentations)
    afficher_taux_occupation(taux_occupation)
    
    arrets_populaires = analyser_arrets_populaires(frequentations, arrets)
    afficher_arrets_populaires(arrets_populaires)
    
    print("\nAppuyez sur Entrée pour continuer...")
    readline()
end

function executer_export_donnees(lignes, arrets, frequentations)
    """Execute l'export des données"""
    println("\nEXPORT DES DONNEES")
    println("-"^40)
    
    # Utilise les fonctions du Membre 2
    ligne_stats = analyser_frequentation_par_ligne(frequentations)
    
    timestamp = Dates.format(now(), "yyyy-mm-dd_HH-MM")
    nom_fichier = "resultats/analyse_sotraco_$timestamp.csv"
    
    exporter_donnees_csv(ligne_stats, nom_fichier)
    
    print("\nAppuyez sur Entrée pour continuer...")
    readline()
end

function lancer_systeme_sotraco()
    """Fonction principale qui lance le système"""
    println("Chargement du système SOTRACO...")
    
    # Utilise les fonctions de chargement du Membre 1
    local lignes, arrets, frequentations
    try
        println("Chargement des données...")
        lignes = load_lignes("data/lignes_bus.csv")
        arrets = load_arrets("data/arrets.csv") 
        frequentations = load_frequentations("data/frequentation.csv")
        println("Données chargées avec succès")
        println("Nombre d'arrêts importés: ", length(arrets))
        println("Nombre de lignes importées: ", length(lignes))
        println("Nombre de mesures de fréquentation: ", length(frequentations))
    catch e
        println("Erreur chargement données: $e")
        println("Vérifiez que les fichiers CSV existent dans le dossier 'data/'")
        return
    end
    
    # Boucle principale du menu
    while true
        afficher_menu_principal()
        choix = readline()
        
        if choix == "1"
            executer_analyse_frequentation(lignes, arrets, frequentations)
        elseif choix == "2"
            executer_optimisation_lignes(lignes, frequentations)
        elseif choix == "3"
            # Utilise les fonctions de rapport du Membre 2
            generer_rapport_complet(lignes, arrets, frequentations)
            print("\nAppuyez sur Entrée pour continuer...")
            readline()
        elseif choix == "4"
            executer_visualisation(arrets, frequentations)
        elseif choix == "5"
            executer_export_donnees(lignes, arrets, frequentations)
        elseif choix == "6"
            # Utilise les fonctions d'analyse et de rapport du Membre 2
            ligne_stats = analyser_frequentation_par_ligne(frequentations)
            taux_occupation = calculer_taux_occupation(frequentations)
            heures_pointe = identifier_heures_pointe(frequentations)
            generer_recommandations(ligne_stats, taux_occupation, heures_pointe, lignes)
            print("\nAppuyez sur Entrée pour continuer...")
            readline()
        elseif choix == "7"
            println("\nAu revoir ! Merci d'avoir utilisé le système SOTRACO")
            break
        else
            println("Choix invalide. Veuillez choisir entre 1 et 7.")
        end
    end
end

# Point d'entrée du programme
if abspath(PROGRAM_FILE) == @__FILE__
    lancer_systeme_sotraco()
end