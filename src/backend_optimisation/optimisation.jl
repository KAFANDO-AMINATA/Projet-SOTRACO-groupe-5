using Statistics
using Dates
include("types.jl")
include("../analyse.jl")

# ==============================
# Constantes pour l'optimisation
# ==============================
const FREQUENCE_MIN_ACCEPTABLE = 5     # fréquence minimale
const FREQUENCE_MAX_ACCEPTABLE = 30    # fréquence maximale
const CAPACITE_BUS_STANDARD = 80       # capacité standard d’un bus

# ==============================
# Optimisation des fréquences
# ==============================



"""
Optimise une fréquence fixe pour toute la journée
"""
function optimiser_frequence_fixe(ligne::Ligne, frequentations::Vector{Frequentation})
    data_ligne = filter(f -> f.ligne_id == ligne.id, frequentations)
    if isempty(data_ligne)
        return ligne.frequence_min
    end

    demande_moyenne = mean(f.montees for f in data_ligne)
    occupation_moyenne = calculer_taux_occupation(data_ligne)

    if occupation_moyenne > 0.8
        nouvelle_frequence = max(FREQUENCE_MIN_ACCEPTABLE, ligne.frequence_min - 5)
    elseif occupation_moyenne < 0.3
        nouvelle_frequence = min(FREQUENCE_MAX_ACCEPTABLE, ligne.frequence_min + 10)
    elseif occupation_moyenne < 0.5
        if demande_moyenne > 50
            nouvelle_frequence = max(FREQUENCE_MIN_ACCEPTABLE, ligne.frequence_min - 3)
        elseif demande_moyenne < 15
            nouvelle_frequence = min(FREQUENCE_MAX_ACCEPTABLE, ligne.frequence_min + 5)
        else
            nouvelle_frequence = ligne.frequence_min
        end
    else
        nouvelle_frequence = ligne.frequence_min
    end

    return Int(round(nouvelle_frequence))
end

"""
Optimise des fréquences variables selon les périodes de la journée
"""
function optimiser_frequence_variable(ligne::Ligne, frequentations::Vector{Frequentation})
    # Filtrer les fréquentations de la ligne
    data_ligne = filter(f -> f.ligne_id == ligne.id, frequentations)

    # Obtenir les périodes les plus fréquentées (Vector{Pair{heure, total_passagers}})
    periodes = identifier_heures_pointe(data_ligne)

    # Calculer la demande par heure
    demande_par_heure = analyser_demande_par_heure(ligne.id, frequentations)

    if isempty(demande_par_heure)
        return Dict(:frequence_fixe => ligne.frequence_min)
    end

    frequences_optimales = Dict{String, Int}()

    # -------------------
    # Heure de pointe (première heure du Vector)
    # -------------------
    if length(periodes) >= 1
        pointe_heures = [periodes[1][1]]  # récupérer l'heure
        demandes = [demande_par_heure[h] for h in pointe_heures if haskey(demande_par_heure, h)]
        if !isempty(demandes)
            frequences_optimales["pointe"] = calculer_frequence_optimale(maximum(demandes), CAPACITE_BUS_STANDARD)
        end
    end

    # -------------------
    # Heure normale (deuxième heure du Vector)
    # -------------------
    if length(periodes) >= 2
        normale_heures = [periodes[2][1]]
        demandes = [demande_par_heure[h] for h in normale_heures if haskey(demande_par_heure, h)]
        if !isempty(demandes)
            frequences_optimales["normale"] = calculer_frequence_optimale(mean(demandes), CAPACITE_BUS_STANDARD)
        end
    end

    # -------------------
    # Heure creuse (troisième heure du Vector)
    # -------------------
    if length(periodes) >= 3
        creuse_heures = [periodes[3][1]]
        demandes = [demande_par_heure[h] for h in creuse_heures if haskey(demande_par_heure, h)]
        if !isempty(demandes)
            frequences_optimales["creuse"] = calculer_frequence_optimale(mean(demandes), CAPACITE_BUS_STANDARD)
        end
    end

    return frequences_optimales
end


"""
Calcule la fréquence optimale en minutes par bus
"""
function calculer_frequence_optimale(demande_par_heure::Float64, capacite_bus::Int)
    if demande_par_heure <= 0 || capacite_bus <= 0
        return FREQUENCE_MAX_ACCEPTABLE
    end

    nb_bus = ceil(demande_par_heure / capacite_bus)
    frequence = 60 / nb_bus

    return Int(round(clamp(frequence, FREQUENCE_MIN_ACCEPTABLE, FREQUENCE_MAX_ACCEPTABLE)))
end

