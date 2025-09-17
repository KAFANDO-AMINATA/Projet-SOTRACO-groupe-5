using CSV
using DataFrames
include("types.jl")

function load_arrets(filepath::String)
    df = CSV.read(filepath, DataFrame)

    arrets = Arret[]

    for row in eachrow(df)
        push!(arrets, Arret(
            row.id,
            row.nom_arret,
            row.quartier,
            row.zone,
            parse(Float64, row.latitude), 
            parse(Float64, row.longitude),
            row.abribus,
            row.eclairage,
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
            parse(Float64, row.distance_km),
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
            Time(row.heure),
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

# Charger les données
arrets = load_arrets("data/arrets.csv")
lignes = load_lignes("data/lignes.csv")
frequences = load_frequentations("data/frequentation.csv")

println("Nombre d'arrêts importés: ", length(arrets))
println("Nombre de lignes importées: ", length(lignes))
println("Nombre de mesures de fréquentation: ", length(frequences))



