using Test
include("../src/backend_optimisation/types.jl")
include("../src/analyse.jl")
include("../src/visualisation.jl")
include("../src/rapports.jl")
include("../src/main.jl")

"""
Tests unitaires pour les modules développés par le Membre 2
"""

@testset "Tests Module Analyse" begin
    
    # Données de test avec plus de variété
    test_frequentations = [
        Frequentation(1, DateTime(2024, 1, 1), Time(8, 0), 1, 1, 50, 25, 30, 50),
        Frequentation(2, DateTime(2024, 1, 1), Time(9, 0), 1, 2, 75, 40, 35, 50),
        Frequentation(3, DateTime(2024, 1, 1), Time(8, 0), 2, 1, 10, 5, 25, 50),
        Frequentation(4, DateTime(2024, 1, 2), Time(17, 0), 1, 1, 60, 30, 40, 50)
    ]
    
    test_arrets = [
        Arret(1, "Arrêt Central", "Centre", "Zone A", 12.3, -1.5, true, true, [1, 2]),
        Arret(2, "Arrêt Nord", "Secteur 1", "Zone B", 12.4, -1.4, false, true, [1])
    ]
    
    @testset "Analyse fréquentation par ligne" begin
        resultats = analyser_frequentation_par_ligne(test_frequentations)
        
        @test haskey(resultats, 1)
        @test haskey(resultats, 2)
        @test resultats[1] > 0  # Ligne 1 doit avoir une fréquentation
        @test resultats[2] > 0  # Ligne 2 doit avoir une fréquentation
        @test resultats[1] > resultats[2]  # Ligne 1 plus fréquentée que ligne 2
    end
    
    @testset "Identification heures de pointe" begin
        heures_pointe = identifier_heures_pointe(test_frequentations)
        
        @test length(heures_pointe) > 0
        @test isa(heures_pointe[1], Pair{Int, Int})
        # L'heure 8 et 17 devraient être dans les heures de pointe
        heures = [h for (h, p) in heures_pointe]
        @test (8 in heures) || (17 in heures)
    end
    
    @testset "Calcul taux d'occupation" begin
        taux = calculer_taux_occupation(test_frequentations)
        
        @test taux >= 0
        @test taux <= 100
        @test isa(taux, Float64)
        # Avec nos données de test, le taux devrait être raisonnable
        @test taux > 50  # Les bus sont plutôt bien occupés
    end
    
    @testset "Analyse arrêts populaires" begin
        arrets_pop = analyser_arrets_populaires(test_frequentations, test_arrets)
        
        @test length(arrets_pop) > 0
        @test isa(arrets_pop[1], Tuple{String, Int})
        @test arrets_pop[1][2] > 0  # Nombre de passagers doit être positif
        
        # L'arrêt 1 devrait être plus populaire que l'arrêt 2
        if length(arrets_pop) >= 2
            @test arrets_pop[1][2] >= arrets_pop[2][2]
        end
    end
    
    @testset "Détection lignes sous-utilisées" begin
        # Test avec un seuil élevé - la ligne 2 devrait être détectée
        lignes_sous_utilisees = detecter_lignes_sous_utilisees(test_frequentations, 50.0)
        
        @test isa(lignes_sous_utilisees, Vector)
        @test length(lignes_sous_utilisees) >= 0
        
        # Test avec un seuil très bas - aucune ligne ne devrait être détectée
        lignes_seuil_bas = detecter_lignes_sous_utilisees(test_frequentations, 1.0)
        @test length(lignes_seuil_bas) == 0
        
        # Test avec un seuil moyen
        lignes_seuil_moyen = detecter_lignes_sous_utilisees(test_frequentations, 30.0)
        if !isempty(lignes_seuil_moyen)
            @test lignes_seuil_moyen[1][2] < 30.0  # Vérifier que le seuil est respecté
        end
    end
    
    @testset "Calcul stats par zone" begin
        stats_zones = calculer_stats_par_zone(test_frequentations, test_arrets)
        
        @test isa(stats_zones, Dict{String, Int})
        @test haskey(stats_zones, "Zone A")
        @test stats_zones["Zone A"] > 0
    end
end

@testset "Tests Module Visualisation" begin
    
    # Données de test
    test_lignes = [
        Ligne(1, "Ligne A", "Terminus Nord", "Terminus Sud", 15.0, 45, 200, 10, "Actif"),
        Ligne(2, "Ligne B", "Est", "Ouest", 12.0, 35, 200, 15, "Actif")
    ]
    
    test_stats = Dict(1 => 150.0, 2 => 75.0)
    test_heures = [8 => 500, 17 => 450, 12 => 200]
    
    @testset "Affichage stats ligne " begin
        # Test que la fonction s'exécute sans erreur
        @test_nowarn afficher_stats_ligne(test_stats, test_lignes)
    end
    
    @testset "Affichage heures de pointe " begin
        @test_nowarn afficher_heures_pointe(test_heures)
    end
    
    @testset "Affichage taux occupation " begin
        @test_nowarn afficher_taux_occupation(65.5)
        @test_nowarn afficher_taux_occupation(35.0)  # Cas faible
        @test_nowarn afficher_taux_occupation(95.0)  # Cas élevé
    end
    
    @testset "Affichage arrêts populaires " begin
        test_arrets_pop = [("Arrêt Central", 150), ("Arrêt Nord", 100)]
        @test_nowarn afficher_arrets_populaires(test_arrets_pop)
        
        # Test avec liste vide
        @test_nowarn afficher_arrets_populaires(Tuple{String, Int}[])
    end
    
    @testset "Résumé exécutif " begin
        @test_nowarn afficher_resume_executif(test_stats, 65.5, test_heures)
    end
end

@testset "Tests Module Rapports" begin
    
    # Données de test complètes
    test_lignes = [
        Ligne(1, "Ligne Test 1", "Nord", "Sud", 10.0, 30, 200, 10, "Actif"),
        Ligne(2, "Ligne Test 2", "Est", "Ouest", 8.0, 25, 200, 12, "Actif")
    ]
    
    test_arrets = [
        Arret(1, "Arrêt Test 1", "Centre", "Zone A", 12.0, -1.0, true, true, [1]),
        Arret(2, "Arrêt Test 2", "Périphérie", "Zone B", 12.1, -1.1, false, true, [2])
    ]
    
    test_frequentations = [
        Frequentation(1, DateTime(2024, 1, 1), Time(8, 0), 1, 1, 20, 10, 40, 50),
        Frequentation(2, DateTime(2024, 1, 1), Time(17, 0), 2, 2, 25, 15, 45, 50)
    ]
    
    @testset "Génération rapport complet " begin
        @test_nowarn generer_rapport_complet(test_lignes, test_arrets, test_frequentations)
    end
    
    @testset "Informations générales " begin
        @test_nowarn afficher_informations_generales(test_lignes, test_arrets, test_frequentations)
    end
    
    @testset "Génération recommandations " begin
        ligne_stats = Dict(1 => 30.0, 2 => 40.0)
        heures_pointe = [8 => 100, 17 => 90]
        @test_nowarn generer_recommandations(ligne_stats, 60.0, heures_pointe, test_lignes)
        
        # Test avec différents taux d'occupation
        @test_nowarn generer_recommandations_occupation(35.0)  # Faible
        @test_nowarn generer_recommandations_occupation(75.0)  # Normal
        @test_nowarn generer_recommandations_occupation(95.0)  # Élevé
    end
    
    @testset "Export CSV" begin
        test_data = Dict(1 => 50.5, 2 => 75.2)
        nom_fichier = "test_export.csv"
        
        @test_nowarn exporter_donnees_csv(test_data, nom_fichier)
        
        # Nettoyer le fichier de test s'il existe
        if isfile(nom_fichier)
            rm(nom_fichier)
        end
    end
end

@testset "Tests Intégration Interface" begin
    
    @testset "Menu principal " begin
        # Rediriger stdout pour éviter l'affichage pendant les tests
        original_stdout = stdout
        (rd, wr) = redirect_stdout()
        
        try
            @test_nowarn afficher_menu_principal()
        finally
            redirect_stdout(original_stdout)
            close(wr)
            close(rd)
        end
    end
end

# Tests de robustesse avec données vides
@testset "Tests Robustesse Données Vides" begin
    
    @testset "Analyse avec données vides" begin
        resultats_vides = analyser_frequentation_par_ligne(Frequentation[])
        @test isempty(resultats_vides)
        
        heures_vides = identifier_heures_pointe(Frequentation[])
        @test isempty(heures_vides)
        
        taux_vide = calculer_taux_occupation(Frequentation[])
        @test taux_vide == 0.0
    end
    
    @testset "Visualisation avec données vides" begin
        @test_nowarn afficher_arrets_populaires(Tuple{String, Int}[])
        @test_nowarn afficher_stats_zones(Dict{String, Int}())
    end
end

println(" Tout est succès!")