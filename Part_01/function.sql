CREATE OR REPLACE FUNCTION verifMetier()
RETURNS TRIGGER AS $$
    DECLARE
    BEGIN
        IF EXISTS (SELECT * FROM Metier WHERE Designation = New.Designation);
        THEN
            RETURN NEW;
        ELSE
            RETURN NULL;
        END IF;
    END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION verifPers()
RETURNS TRIGGER AS $$
    DECLARE
    BEGIN
        IF NOT EXISTS (SELECT * FROM Personne WHERE Nom = New.Nom AND Prenom = New.Prenom AND Representation = New.Representation AND Notes = New.Notes);
        THEN
            RETURN NEW;
        ELSE
            RETURN NULL;
        END IF;
    END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION verifDate()
RETURNS TRIGGER AS $$
    DECLARE
    BEGIN
        IF EXISTS (SELECT * FROM Date WHERE jour = New.jour AND jour_bis = New.jour_bis AND mois = New.mois AND mois_bis = New.mois_bis AND annee = New.annee AND annee_bis = New.annee_bis);
        THEN
            RETURN NEW;
        ELSE
            RETURN NULL;
        END IF;
    END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION verifLamb()
RETURNS TRIGGER AS $$
    DECLARE
    BEGIN
        IF EXISTS (SELECT * FROM Lambert93 WHERE nom = New.nom);
        THEN
            RETURN NEW;
        ELSE
            RETURN NULL;
        END IF;
    END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION verifSujet()
RETURNS TRIGGER AS $$
    DECLARE
    BEGIN
        IF NOT EXISTS (SELECT * FROM Sujet WHERE Sujet = New.Sujet);
        THEN
            RETURN NEW;
        ELSE
            RETURN NULL;
        END IF;
    END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION verifFichier()
RETURNS TRIGGER AS $$
    DECLARE
    BEGIN
        IF NOT EXISTS (SELECT * FROM Fichier WHERE NomFichier = New.NomFichier);
        THEN
            RETURN NEW;
        ELSE
            RETURN NULL;
        END IF;
    END;
$$ LANGUAGE PLPGSQL;