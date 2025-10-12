
# Importation des librairies nécessaires
using Dates 
using Statistics

"""
Module de structuration des données SOTRACO 
developpé par le Membre 1 -  Développeur Backend & Optimisation

"""


# Définition des structures

"""
Représente une ligne de bus avec ses caractéristiques
"""
struct Ligne
    id::Int
    nom_ligne::String
    origine::String
    destination::String
    distance_km::Float64
    duree_trajet_min::Int
    tarif_fcfa::Int
    frequence_min::Int
    statut::String
end

"""
Représente un arrêt de bus
"""
struct Arret
    id::Int
    nom_arret::String
    quartier::String
    zone::String
    latitude::Float64
    longitude::Float64
    abribus::Bool
    eclairage::Bool
    lignes_desservies::Vector{Int}
end

"""
Enregistre la fréquentation d'un bus à un arrêt donné
"""
struct Frequentation
    id::Int
    date::DateTime
    heure::Time
    ligne_id::Int
    arret_id::Int
    montees::Int
    descentes::Int
    occupation_bus::Int
    capacite_bus::Int
end

"""
Statistiques globales d'une ligne
"""
struct StatistiquesLigne
    ligne_id::Int
    total_passagers::Int
    taux_occupation_moyen::Float64
    heures_pointe::Vector{Time}
    arrets_populaires::Dict{Int, Int}
end

"""
Statistiques globales d'un arrêt
"""
struct StatistiquesArret
    arret_id::Int
    total_passagers::Int
    lignes_frequentees::Dict{Int, Int}  # ligne_id -> nombre_passagers
    heures_affluence::Dict{Time, Int}   # heure -> nombre_passagers
end
