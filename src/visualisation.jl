include("analyse.jl")

"""
Module de visualisation des données SOTRACO
Développé par le Membre 2 - Interface et Visualisation
"""

function afficher_titre_section(titre::String)
    """Affiche un titre de section formaté"""
    println("="^60)
    println(titre)
    println("="^60)
    println()
end

function afficher_stats_ligne(ligne_stats::Dict{Int, Float64}, lignes::Vector{Ligne})
    """Affiche les statistiques de fréquentation par ligne"""
    afficher_titre_section("STATISTIQUES DE FREQUENTATION PAR LIGNE")
    
    # Trier par fréquentation décroissante
    lignes_triees = sort(collect(ligne_stats), by=x->x[2], rev=true)
    
    println("Rang | Ligne | Nom | Fréquentation/jour")
    println("-"^55)
    
    for (rang, (ligne_id, freq_moyenne)) in enumerate(lignes_triees)
        ligne_trouve = findfirst(l -> l.id == ligne_id, lignes)
        if ligne_trouve !== nothing
            nom_ligne = lignes[ligne_trouve].nom_ligne
            freq_arrondie = round(freq_moyenne, digits=1)
            println("$rang    | $ligne_id     | $nom_ligne | $freq_arrondie passagers")
        end
    end
    println()
end

function afficher_heures_pointe(heures_pointe::Vector{Pair{Int, Int}})
    """Affiche les heures de pointe du réseau avec graphique ASCII"""
    afficher_titre_section("HEURES DE POINTE DU RESEAU SOTRACO")
    
    for (i, (heure, nb_passagers)) in enumerate(heures_pointe)
        heure_fin = heure + 1
        if heure_fin > 23
            heure_fin = 0
        end
        
        # Créer une barre ASCII proportionnelle
        max_passagers = maximum([p for (h, p) in heures_pointe])
        longueur_barre = Int(round((nb_passagers / max_passagers) * 40))
        barre = repeat("█", longueur_barre)
        
        println("$i. $(heure)h00-$(heure_fin)h00 |$barre $nb_passagers passagers")
    end
    println()
end

function afficher_taux_occupation(taux::Float64)
    """Affiche le taux d'occupation global avec indicateur visuel"""
    afficher_titre_section("TAUX D'OCCUPATION GLOBAL DU RESEAU")
    
    taux_arrondi = round(taux, digits=1)
    println("Taux d'occupation moyen: $(taux_arrondi)%")
    
    # Barre de progression ASCII
    progression = Int(round(taux_arrondi))
    barre_pleine = repeat("█", div(progression, 2))
    barre_vide = repeat("░", div(100 - progression, 2))
    
    println("Progression: [$barre_pleine$barre_vide] $(taux_arrondi)%")
    println()
    
    # Évaluation du taux
    if taux < 40
        println("ALERTE: Occupation très faible - Gaspillage de ressources")
    elseif taux < 60
        println("ATTENTION: Occupation faible - Optimisation possible")
    elseif taux < 80
        println("OPTIMAL: Bon équilibre occupation/confort")
    elseif taux < 95
        println("ATTENTION: Occupation élevée - Inconfort possible")
    else
        println("CRITIQUE: Surcharge - Action urgente requise")
    end
    println()
end

function afficher_arrets_populaires(arrets_pop::Vector{Tuple{String, Int}})
    """Affiche le top 5 des arrêts les plus fréquentés"""
    afficher_titre_section("TOP 5 DES ARRETS LES PLUS FREQUENTES")
    
    if isempty(arrets_pop)
        println("Aucune donnée d'arrêt disponible")
        return
    end
    
    max_passagers = maximum([nb for (nom, nb) in arrets_pop])
    
    for (i, (nom_arret, nb_passagers)) in enumerate(arrets_pop)
        # Barre proportionnelle
        longueur_barre = Int(round((nb_passagers / max_passagers) * 30))
        barre = repeat("█", longueur_barre)
        
        println("$i. $nom_arret")
        println("   |$barre $nb_passagers passagers/jour")
    end
    println()
end

function afficher_stats_zones(stats_zones::Dict{String, Int})
    """Affiche les statistiques par zone géographique"""
    afficher_titre_section("REPARTITION PAR ZONE GEOGRAPHIQUE")
    
    zones_triees = sort(collect(stats_zones), by=x->x[2], rev=true)
    total_passagers = sum(values(stats_zones))
    
    for (zone, nb_passagers) in zones_triees
        pourcentage = round((nb_passagers / total_passagers) * 100, digits=1)
        
        # Barre proportionnelle
        longueur_barre = Int(round(pourcentage / 2))
        barre = repeat("█", longueur_barre)
        
        println("$zone: |$barre $(pourcentage)% ($nb_passagers passagers)")
    end
    println()
end

function afficher_tendances_hebdomadaires(tendances::Dict{Int, Int})
    """Affiche les tendances de fréquentation hebdomadaire"""
    afficher_titre_section("TENDANCES HEBDOMADAIRES")
    
    noms_jours = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"]
    max_passagers = maximum(values(tendances))
    
    for jour in 1:7
        if haskey(tendances, jour)
            nb_passagers = tendances[jour]
            longueur_barre = Int(round((nb_passagers / max_passagers) * 25))
            barre = repeat("█", longueur_barre)
            
            println("$(noms_jours[jour]): |$barre $nb_passagers passagers")
        end
    end
    println()
end

function generer_graphique_ascii_simple(donnees::Vector{Int}, labels::Vector{String}, titre::String)
    """Génère un graphique ASCII simple avec étiquettes"""
    afficher_titre_section(titre)
    
    if length(donnees) != length(labels)
        println("Erreur: nombre de données différent du nombre d'étiquettes")
        return
    end
    
    max_val = maximum(donnees)
    
    for (i, (val, label)) in enumerate(zip(donnees, labels))
        longueur_barre = Int(round((val / max_val) * 30))
        barre = repeat("█", longueur_barre)
        println("$label |$barre $val")
    end
    println()
end

function afficher_resume_executif(ligne_stats::Dict{Int, Float64}, taux_occupation::Float64, heures_pointe::Vector{Pair{Int, Int}})
    """Affiche un résumé exécutif des principales métriques"""
    afficher_titre_section("RESUME EXECUTIF - METRIQUES CLES")
    
    # Nombre total de lignes analysées
    nb_lignes = length(ligne_stats)
    println("Lignes analysées: $nb_lignes")
    
    # Fréquentation totale
    freq_totale = sum(values(ligne_stats))
    println("Fréquentation totale: $(round(freq_totale, digits=0)) passagers/jour")
    
    # Taux d'occupation
    println("Taux d'occupation moyen: $(round(taux_occupation, digits=1))%")
    
    # Ligne la plus fréquentée
    ligne_max = findmax(ligne_stats)
    println("Ligne la plus fréquentée: Ligne $(ligne_max[2]) ($(round(ligne_max[1], digits=1)) pass/jour)")
    
    # Ligne la moins fréquentée
    ligne_min = findmin(ligne_stats)
    println("Ligne la moins fréquentée: Ligne $(ligne_min[2]) ($(round(ligne_min[1], digits=1)) pass/jour)")
    
    # Heure de pointe principale
    if !isempty(heures_pointe)
        heure_peak, passagers_peak = heures_pointe[1]
        println("Heure de pointe: $(heure_peak)h00 ($passagers_peak passagers)")
    end
    
    println()
end