using CSV
using DataFrames
include("types.jl")
# include("../rapports.jl")

"""
Module de chargement des données SOTRACO 
developpé par le Membre 1 -  Développeur Backend & Optimisation

"""
function load_arrets(filepath::String)
    df = CSV.read(filepath, DataFrame)

    arrets = Arret[]

    for row in eachrow(df)
        push!(arrets, Arret(
            row.id,
            row.nom_arret,
            row.quartier,
            row.zone,
            row.latitude, 
            row.longitude,
            row.abribus == "Oui",
            row.eclairage == "Oui",
            [parse(Int, l) for l in split(row.lignes_desservies, ",")]
        ))
    end

    return arrets
end

function load_lignes(filepath::String)
    df = CSV.read(filepath, DataFrame)

    lignes = Ligne[]

    for row in eachrow(df)
        push!(lignes, Ligne(
            row.id,
            row.nom_ligne,
            row.origine,
            row.destination,
            row.distance_km,
            row.duree_trajet_min,
            row.tarif_fcfa,
            row.frequence_min,
            row.statut
        ))
    end

    return lignes
end

function load_frequentations(filepath::String)
    df = CSV.read(filepath, DataFrame)

    frequences = Frequentation[]

    for row in eachrow(df)
        push!(frequences, Frequentation(
            row.id,
            DateTime(row.date),
            row.heure,
            row.ligne_id,
            row.arret_id,
            row.montees,
            row.descentes,
            row.occupation_bus,
            row.capacite_bus
        ))
    end

    return frequences
end

function exporter_donnees_csv(donnees::Dict, nom_fichier::String)
    """Exporte des données d'analyse en format CSV"""
    try
        # Créer le dossier s'il n'existe pas
        mkpath(dirname(nom_fichier))
        
        open(nom_fichier, "w") do fichier
            write(fichier, "ligne_id,frequentation_moyenne\n")
            for (ligne_id, freq) in sort(collect(donnees))
                write(fichier, "$ligne_id,$(round(freq, digits=2))\n")
            end
        end
        println("Données exportées: $nom_fichier")
    catch e
        println("Erreur lors de l'export: $e")
    end
end


# Chargement des données
arrets = load_arrets("data/arrets.csv")
lignes = load_lignes("data/lignes_bus.csv")
frequences = load_frequentations("data/frequentation.csv")

# println("Nombre d'arrêts importés: ", length(arrets))
# println("Nombre de lignes importées: ", length(lignes))
# println("Nombre de mesures de fréquentation: ", length(frequences))



