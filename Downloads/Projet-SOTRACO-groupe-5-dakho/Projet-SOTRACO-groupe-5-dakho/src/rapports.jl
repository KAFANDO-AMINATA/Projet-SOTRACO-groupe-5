using Dates
include("analyse.jl")
include("visualisation.jl")

"""
Module de génération de rapports SOTRACO
Développé par le Membre 2 - Génération de rapports et recommandations
"""

function generer_rapport_complet(lignes::Vector{Ligne}, arrets::Vector{Arret}, frequentations::Vector{Frequentation})
    """Génère un rapport complet d'analyse du réseau SOTRACO"""
    
    println("=" * "="^58 * "=")
    println("        RAPPORT D'ANALYSE RESEAU SOTRACO")
    println("        Date: $(today())")
    println("        Heure: $(Dates.format(now(), "HH:MM"))")
    println("=" * "="^58 * "=")
    println()
    
    # Section 1: Informations générales
    afficher_informations_generales(lignes, arrets, frequentations)
    
    # Section 2: Analyses détaillées
    ligne_stats = analyser_frequentation_par_ligne(frequentations)
    afficher_stats_ligne(ligne_stats, lignes)
    
    heures_pointe = identifier_heures_pointe(frequentations)
    afficher_heures_pointe(heures_pointe)
    
    taux_occupation = calculer_taux_occupation(frequentations)
    afficher_taux_occupation(taux_occupation)
    
    arrets_populaires = analyser_arrets_populaires(frequentations, arrets)
    afficher_arrets_populaires(arrets_populaires)
    
    # Section 3: Analyses complémentaires
    stats_zones = calculer_stats_par_zone(frequentations, arrets)
    afficher_stats_zones(stats_zones)
    
    tendances_hebdo = analyser_tendances_hebdomadaires(frequentations)
    afficher_tendances_hebdomadaires(tendances_hebdo)
    
    # Section 4: Résumé exécutif
    afficher_resume_executif(ligne_stats, taux_occupation, heures_pointe)
    
    # Section 5: Recommandations
    generer_recommandations(ligne_stats, taux_occupation, heures_pointe, lignes)
    
    println("="^60)
    println("FIN DU RAPPORT - $(now())")
    println("="^60)
end

function afficher_informations_generales(lignes::Vector{Ligne}, arrets::Vector{Arret}, frequentations::Vector{Frequentation})
    """Affiche les informations générales du réseau"""
    afficher_titre_section("INFORMATIONS GENERALES DU RESEAU")
    
    println("DONNEES DE BASE:")
    println("Nombre de lignes en service: $(length(lignes))")
    println("Nombre d'arrêts dans le réseau: $(length(arrets))")
    println("Nombre de mesures de fréquentation: $(length(frequentations))")
    
    if !isempty(frequentations)
        date_debut = minimum([f.date for f in frequentations])
        date_fin = maximum([f.date for f in frequentations])
        println("Période d'analyse: du $(Dates.format(date_debut, "dd/mm/yyyy")) au $(Dates.format(date_fin, "dd/mm/yyyy"))")
    end
    
    # Statistiques des lignes
    if !isempty(lignes)
        distance_totale = sum([l.distance_km for l in lignes])
        tarif_moyen = mean([l.tarif_fcfa for l in lignes])
        println("Distance totale du réseau: $(round(distance_totale, digits=1)) km")
        println("Tarif moyen: $(round(tarif_moyen, digits=0)) FCFA")
    end
    
    # Statistiques des arrêts
    if !isempty(arrets)
        arrets_avec_abribus = count(a -> a.abribus, arrets)
        arrets_avec_eclairage = count(a -> a.eclairage, arrets)
        taux_abribus = round((arrets_avec_abribus / length(arrets)) * 100, digits=1)
        taux_eclairage = round((arrets_avec_eclairage / length(arrets)) * 100, digits=1)
        
        println("Arrêts avec abribus: $arrets_avec_abribus ($taux_abribus%)")
        println("Arrêts avec éclairage: $arrets_avec_eclairage ($taux_eclairage%)")
    end
    
    println()
end

function generer_recommandations(ligne_stats::Dict{Int, Float64}, taux_occupation::Float64, heures_pointe::Vector{Pair{Int, Int}}, lignes::Vector{Ligne})
    """Génère des recommandations d'optimisation basées sur l'analyse"""
    afficher_titre_section("RECOMMANDATIONS D'OPTIMISATION")
    
    println("RECOMMANDATIONS STRATEGIQUES:")
    println()
    
    # 1. Recommandations sur le taux d'occupation global
    generer_recommandations_occupation(taux_occupation)
    
    # 2. Recommandations sur les horaires
    generer_recommandations_horaires(heures_pointe)
    
    # 3. Recommandations sur les lignes
    generer_recommandations_lignes(ligne_stats, lignes)
    
    # 4. Recommandations d'infrastructure
    generer_recommandations_infrastructure()
    
    println("="^60)
end

function generer_recommandations_occupation(taux_occupation::Float64)
    """Recommandations basées sur le taux d'occupation"""
    println("1. OPTIMISATION DE LA CAPACITE:")
    
    if taux_occupation < 40
        println("   PRIORITE HAUTE - Taux d'occupation critique ($taux_occupation%)")
        println("   - Réduire la fréquence des lignes peu utilisées")
        println("   - Utiliser des véhicules plus petits aux heures creuses")
        println("   - Revoir la tarification pour encourager l'utilisation")
        println("   - Considérer la fusion ou suppression de certaines lignes")
    elseif taux_occupation < 60
        println("   ATTENTION - Taux d'occupation faible ($taux_occupation%)")
        println("   - Ajuster les horaires selon la demande réelle")
        println("   - Optimiser les itinéraires pour réduire les temps morts")
        println("   - Améliorer la communication sur les horaires")
    elseif taux_occupation < 80
        println("   SATISFAISANT - Bon équilibre ($taux_occupation%)")
        println("   - Maintenir le niveau de service actuel")
        println("   - Surveiller l'évolution de la demande")
    else
        println("   SURCHARGE - Taux d'occupation élevé ($taux_occupation%)")
        println("   - Augmenter la fréquence aux heures de pointe")
        println("   - Déployer des véhicules de plus grande capacité")
        println("   - Créer des lignes express pour délester")
    end
    println()
end

function generer_recommandations_horaires(heures_pointe::Vector{Pair{Int, Int}})
    """Recommandations basées sur les heures de pointe"""
    println("2. OPTIMISATION DES HORAIRES:")
    
    if !isempty(heures_pointe)
        heure_peak = heures_pointe[1][1]
        println("   - Renforcer les services entre $(heure_peak-1)h et $(heure_peak+2)h")
        println("   - Déployer des régulateurs aux heures de pointe")
        
        # Identifier les heures creuses
        heures_peak_list = [h for (h, p) in heures_pointe]
        if 12 ∉ heures_peak_list && 14 ∉ heures_peak_list
            println("   - Réduire la fréquence entre 12h et 14h (pause déjeuner)")
        end
        if 22 ∉ heures_peak_list && 6 ∉ heures_peak_list
            println("   - Service réduit en soirée et tôt le matin")
        end
    end
    println()
end

function generer_recommandations_lignes(ligne_stats::Dict{Int, Float64}, lignes::Vector{Ligne})
    """Recommandations spécifiques par ligne"""
    println("3. OPTIMISATION PAR LIGNE:")
    
    if !isempty(ligne_stats)
        lignes_triees = sort(collect(ligne_stats), by=x->x[2])
        
        # Lignes sous-utilisées
        seuil_bas = 50.0
        lignes_faibles = filter(x -> x[2] < seuil_bas, lignes_triees)
        
        if !isempty(lignes_faibles)
            println("   LIGNES SOUS-UTILISEES:")
            for (ligne_id, freq) in lignes_faibles[1:min(3, length(lignes_faibles))]
                ligne_info = findfirst(l -> l.id == ligne_id, lignes)
                if ligne_info !== nothing
                    nom = lignes[ligne_info].nom_ligne
                    println("   - Ligne $ligne_id ($nom): $(round(freq, digits=1)) pass/jour")
                    println("     Action: Réviser l'itinéraire ou la fréquence")
                end
            end
        end
        
        # Lignes surchargées
        seuil_haut = 200.0
        lignes_fortes = filter(x -> x[2] > seuil_haut, reverse(lignes_triees))
        
        if !isempty(lignes_fortes)
            println("   LIGNES TRES FREQUENTEES:")
            for (ligne_id, freq) in lignes_fortes[1:min(3, length(lignes_fortes))]
                ligne_info = findfirst(l -> l.id == ligne_id, lignes)
                if ligne_info !== nothing
                    nom = lignes[ligne_info].nom_ligne
                    println("   - Ligne $ligne_id ($nom): $(round(freq, digits=1)) pass/jour")
                    println("     Action: Augmenter la capacité ou créer une ligne bis")
                end
            end
        end
    end
    println()
end

function generer_recommandations_infrastructure()
    """Recommandations d'amélioration de l'infrastructure"""
    println("4. AMELIORATIONS INFRASTRUCTURE:")
    println("   - Installer plus d'abribus aux arrêts populaires")
    println("   - Améliorer l'éclairage pour la sécurité nocturne")
    println("   - Mettre en place un système d'information voyageurs")
    println("   - Créer des voies dédiées aux heures de pointe")
    println("   - Développer une application mobile de suivi en temps réel")
    println()
end

function sauvegarder_rapport_txt(contenu::String, nom_fichier::String="")
    """Sauvegarde le rapport dans un fichier texte"""
    if nom_fichier == ""
        timestamp = Dates.format(now(), "yyyy-mm-dd_HH-MM")
        nom_fichier = "resultats/rapport_sotraco_$timestamp.txt"
    end
    
    try
        # Créer le dossier s'il n'existe pas
        mkpath(dirname(nom_fichier))
        
        open(nom_fichier, "w") do fichier
            write(fichier, contenu)
        end
        println("Rapport sauvegardé: $nom_fichier")
    catch e
        println("Erreur lors de la sauvegarde: $e")
    end
end


function generer_rapport_executif(ligne_stats::Dict{Int, Float64}, taux_occupation::Float64)
    """Génère un rapport exécutif condensé pour la direction"""
    afficher_titre_section("RAPPORT EXECUTIF - SYNTHESE DIRECTION")
    
    nb_lignes = length(ligne_stats)
    freq_totale = sum(values(ligne_stats))
    freq_moyenne = freq_totale / nb_lignes
    
    println("SYNTHESE:")
    println("$nb_lignes lignes analysées")
    println("$(round(freq_totale, digits=0)) passagers/jour au total")
    println("$(round(freq_moyenne, digits=1)) passagers/jour/ligne en moyenne")
    println("$(round(taux_occupation, digits=1))% de taux d'occupation")
    
    println("\nACTIONS PRIORITAIRES:")
    if taux_occupation < 60
        println("URGENT: Optimiser l'offre de transport (sous-utilisation)")
    end
    
    ligne_max = findmax(ligne_stats)
    ligne_min = findmin(ligne_stats)
    ratio = ligne_max[1] / ligne_min[1]
    
    if ratio > 5
        println("IMPORTANT: Rééquilibrer les lignes (ratio $(round(ratio, digits=1)):1)")
    end
    
    println()
end