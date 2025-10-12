using Test
using Dates
using CSV
using DataFrames
using Statistics

# Inclure le module
include("../src/backend_optimisation/io_operations.jl")

# Inclure le module types
include("../src/backend_optimisation/types.jl")

include("../src/backend_optimisation/optimisation.jl")


@testset "Tests structures SOTRACO" begin

    # ---------------------------------------
    # Test de la structure Ligne
    # ---------------------------------------
    @testset "Ligne" begin
        ligne = Ligne(1, "Ligne 1 - Centre", "Gare Routière", "Kossodo", 18.0, 45, 150, 20, "Actif")
        @test ligne.id == 1
        @test ligne.nom_ligne == "Ligne 1 - Centre"
        @test ligne.distance_km == 18.0
        @test typeof(ligne.duree_trajet_min) == Int
        @test ligne.statut == "Actif"
    end

    # ---------------------------------------
    # Test de la structure Arret
    # ---------------------------------------
    @testset "Arret" begin
        arret = Arret(1, "Gare Routière", "Centre-ville", "Zone 1", 12.345, -1.234, true, false, [1,2,3])
        @test arret.id == 1
        @test arret.nom_arret == "Gare Routière"
        @test arret.abribus == true
        @test arret.eclairage == false
        @test length(arret.lignes_desservies) == 3
        @test 2 in arret.lignes_desservies
    end

    # ---------------------------------------
    # Test de la structure Frequentation
    # ---------------------------------------
    @testset "Frequentation" begin
        dt = DateTime(2024, 1, 1, 6, 0)
        heure = Time(6, 0)
        freq = Frequentation(1, dt, heure, 1, 1, 25, 0, 25, 80)
        @test freq.id == 1
        @test freq.date == dt
        @test freq.heure == heure
        @test freq.montees == 25
        @test freq.capacite_bus == 80
    end

    # ---------------------------------------
    # Test de la structure StatistiquesLigne
    # ---------------------------------------
    @testset "StatistiquesLigne" begin
        stats_ligne = StatistiquesLigne(1, 150, 60.5, [Time(7,0), Time(17,0)], Dict(1=>50, 2=>100))
        @test stats_ligne.ligne_id == 1
        @test stats_ligne.total_passagers == 150
        @test length(stats_ligne.heures_pointe) == 2
        @test stats_ligne.arrets_populaires[2] == 100
    end

    # ---------------------------------------
    # Test de la structure StatistiquesArret
    # ---------------------------------------
    @testset "StatistiquesArret" begin
        stats_arret = StatistiquesArret(1, 120, Dict(1=>70, 2=>50), Dict(Time(7,0)=>80, Time(17,0)=>40))
        @test stats_arret.arret_id == 1
        @test stats_arret.total_passagers == 120
        @test stats_arret.lignes_frequentees[1] == 70
        @test stats_arret.heures_affluence[Time(17,0)] == 40
    end

end


# ================================
#  Tests sur le chargement des fichiers CSV
# ================================
@testset "Chargement des données SOTRACO" begin

    # Déterminer automatiquement le dossier racine du projet
    project_root = dirname(@__DIR__)   # remonte d’un dossier : tests → projet-sotraco-groupe-5

    # Construire les chemins complets des fichiers
    path_arrets = joinpath(project_root, "data", "arrets.csv")
    path_lignes = joinpath(project_root, "data", "lignes_bus.csv")
    path_frequences = joinpath(project_root, "data", "frequentation.csv")

    # Charger les fichiers existants
    arrets = load_arrets(path_arrets)
    lignes = load_lignes(path_lignes)
    frequences = load_frequentations(path_frequences)

    # Tests généraux
    @test length(arrets) > 0
    @test length(lignes) > 0
    @test length(frequences) > 0

    # Types des objets
    @test typeof(arrets[1]) == Arret
    @test typeof(lignes[1]) == Ligne
    @test typeof(frequences[1]) == Frequentation

    # Test de certaines valeurs
    @test arrets[1].abribus in (true, false)
    @test arrets[1].eclairage in (true, false)
    @test length(arrets[1].lignes_desservies) > 0
end

# ================================
#  Tests sur l'export CSV
# ================================
@testset "Export CSV" begin
    donnees = Dict(1 => 25.5, 2 => 40.0)
    fichier_test_csv = "test_output/frequentation_test.csv"
    
    exporter_donnees_csv(donnees, fichier_test_csv)
    
    # Vérifier que le fichier est créé
    @test isfile(fichier_test_csv)
    
    # Vérifier le contenu CSV
    df_test = CSV.read(fichier_test_csv, DataFrame)
    @test nrow(df_test) == 2
    @test all(["ligne_id","frequentation_moyenne"] .== names(df_test))
    @test df_test.frequentation_moyenne[1] == 25.5
    @test df_test.frequentation_moyenne[2] == 40.0
end


# ==============================
# Création de données factices
# ==============================
ligne_test = Ligne(
    1, "Ligne A", "Centre", "Gare", 10.0, 30, 300, 15, "Actif"
)

frequentations_test = [
    Frequentation(1, DateTime(2025,10,11,6,0), Time(6,0), 1, 1, 20, 0, 20, 80),
    Frequentation(2, DateTime(2025,10,11,7,0), Time(7,0), 1, 2, 60, 0, 60, 80),
    Frequentation(3, DateTime(2025,10,11,8,0), Time(8,0), 1, 3, 80, 0, 80, 80),
    Frequentation(4, DateTime(2025,10,11,9,0), Time(9,0), 1, 4, 40, 0, 40, 80)
]

# ==============================
# Tests unitaire
# ==============================
@testset "Optimisation des fréquences" begin
    # Test fréquence fixe
    freq_fixe = optimiser_frequence_fixe(ligne_test, frequentations_test)
    @test freq_fixe isa Int
    @test FREQUENCE_MIN_ACCEPTABLE <= freq_fixe <= FREQUENCE_MAX_ACCEPTABLE

    # Test fréquence variable
    freq_var = optimiser_frequence_variable(ligne_test, frequentations_test)
    @test freq_var isa Dict
    @test all(k in ["pointe","normale","creuse"] for k in keys(freq_var)) || isempty(freq_var)

    # Test calcul de fréquence optimale
    f_opt = calculer_frequence_optimale(120.0, 80)
    @test f_opt isa Int
    @test FREQUENCE_MIN_ACCEPTABLE <= f_opt <= FREQUENCE_MAX_ACCEPTABLE
end

println(" Tous les tests d'optimisation ont passé avec succès !")


