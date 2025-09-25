using DataFrames
using Statistics
using Dates
include("backend_optimisation/types.jl")

"""
Module d'analyse des données de fréquentation SOTRACO
Développé par le Membre 2 - Analyste de Données
"""

function analyser_frequentation_par_ligne(frequentations::Vector{Frequentation})
    """Analyse la fréquentation moyenne par ligne de bus"""
    stats_par_ligne = Dict{Int, Vector{Int}}()
    
    for freq in frequentations
        if !haskey(stats_par_ligne, freq.ligne_id)
            stats_par_ligne[freq.ligne_id] = []
        end
        total_passagers = freq.montees + freq.descentes
        push!(stats_par_ligne[freq.ligne_id], total_passagers)
    end
    
    resultats = Dict{Int, Float64}()
    for (ligne_id, passagers_list) in stats_par_ligne
        if !isempty(passagers_list)
            resultats[ligne_id] = mean(passagers_list)
        end
    end
    
    return resultats
end


function identifier_heures_pointe(frequentations::Vector{Frequentation})
    """Identifie les heures de pointe du réseau SOTRACO"""
    passagers_par_heure = Dict{Int, Int}()
    
    for freq in frequentations
        heure = hour(freq.heure)
        total_passagers = freq.montees + freq.descentes
        passagers_par_heure[heure] = get(passagers_par_heure, heure, 0) + total_passagers
    end
    
    # Trier par nombre de passagers décroissant
    heures_triees = sort(collect(passagers_par_heure), by=x->x[2], rev=true)
    return heures_triees[1:min(3, length(heures_triees))]
end

function calculer_taux_occupation(frequentations::Vector{Frequentation})
    """Calcule le taux d'occupation moyen des bus"""
    taux_occupation = Float64[]
    
    for freq in frequentations
        if freq.capacite_bus > 0
            taux = (freq.occupation_bus / freq.capacite_bus) * 100
            push!(taux_occupation, taux)
        end
    end
    
    return isempty(taux_occupation) ? 0.0 : mean(taux_occupation)
end

function analyser_arrets_populaires(frequentations::Vector{Frequentation}, arrets::Vector{Arret})
    """Identifie les 5 arrêts les plus fréquentés"""
    passagers_par_arret = Dict{Int, Int}()
    
    for freq in frequentations
        total_passagers = freq.montees + freq.descentes
        passagers_par_arret[freq.arret_id] = get(passagers_par_arret, freq.arret_id, 0) + total_passagers
    end
    
    # Trier par fréquentation décroissante
    arrets_tries = sort(collect(passagers_par_arret), by=x->x[2], rev=true)
    
    resultats = Tuple{String, Int}[]
    for (arret_id, nb_passagers) in arrets_tries[1:min(5, length(arrets_tries))]
        arret_trouve = findfirst(a -> a.id == arret_id, arrets)
        if arret_trouve !== nothing
            nom_arret = arrets[arret_trouve].nom_arret
            push!(resultats, (nom_arret, nb_passagers))
        end
    end
    
    return resultats
end

function calculer_stats_par_zone(frequentations::Vector{Frequentation}, arrets::Vector{Arret})
    """Calcule les statistiques de fréquentation par zone géographique"""
    passagers_par_zone = Dict{String, Int}()
    
    for freq in frequentations
        arret_trouve = findfirst(a -> a.id == freq.arret_id, arrets)
        if arret_trouve !== nothing
            zone = arrets[arret_trouve].zone
            total_passagers = freq.montees + freq.descentes
            passagers_par_zone[zone] = get(passagers_par_zone, zone, 0) + total_passagers
        end
    end
    
    return passagers_par_zone
end

function analyser_tendances_hebdomadaires(frequentations::Vector{Frequentation})
    """Analyse les tendances de fréquentation par jour de la semaine"""
    passagers_par_jour = Dict{Int, Int}()
    
    for freq in frequentations
        jour_semaine = dayofweek(freq.date)
        total_passagers = freq.montees + freq.descentes
        passagers_par_jour[jour_semaine] = get(passagers_par_jour, jour_semaine, 0) + total_passagers
    end
    
    return passagers_par_jour
end

function detecter_lignes_sous_utilisees(frequentations::Vector{Frequentation}, seuil_min::Float64=50.0)
    """Détecte les lignes sous-utilisées selon un seuil"""
    stats_lignes = analyser_frequentation_par_ligne(frequentations)
    
    lignes_sous_utilisees = Tuple{Int, Float64}[]
    for (ligne_id, freq_moyenne) in stats_lignes
        if freq_moyenne < seuil_min
            push!(lignes_sous_utilisees, (ligne_id, freq_moyenne))
        end
    end
    
    return sort(lignes_sous_utilisees, by=x->x[2])
end

function detecter_lignes_surchargees(frequentations::Vector{Frequentation}, seuil_max::Float64=200.0)
    """Détecte les lignes potentiellement surchargées"""
    stats_lignes = analyser_frequentation_par_ligne(frequentations)
    
    lignes_surchargees = Tuple{Int, Float64}[]
    for (ligne_id, freq_moyenne) in stats_lignes
        if freq_moyenne > seuil_max
            push!(lignes_surchargees, (ligne_id, freq_moyenne))
        end
    end
    
    return sort(lignes_surchargees, by=x->x[2], rev=true)
end