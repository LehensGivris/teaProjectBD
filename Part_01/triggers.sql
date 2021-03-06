DROP TRIGGER IF EXISTS checkMetier ON Metier;

CREATE TRIGGER checkMetier
BEFORE INSERT ON Metier
FOR EACH ROW
EXECUTE PROCEDURE verifMetier();


DROP TRIGGER IF EXISTS checkPers ON Personne;

CREATE TRIGGER checkPers
BEFORE INSERT ON Personne
FOR EACH ROW
EXECUTE PROCEDURE verifPers();


DROP TRIGGER IF EXISTS checkDate ON Date;

CREATE TRIGGER checkDate
BEFORE INSERT ON Date
FOR EACH ROW
EXECUTE PROCEDURE verifDate();


DROP TRIGGER IF EXISTS checkLamb ON Lambert93;

CREATE TRIGGER checkLamb
BEFORE INSERT ON Lambert93
FOR EACH ROW
EXECUTE PROCEDURE verifLamb();


DROP TRIGGER IF EXISTS checkSujet ON Sujet;

CREATE TRIGGER checkSujet
BEFORE INSERT ON Sujet
FOR EACH ROW
EXECUTE PROCEDURE verifSujet();


DROP TRIGGER IF EXISTS checkFichier ON Fichier;

CREATE TRIGGER checkFichier
BEFORE INSERT ON Fichier
FOR EACH ROW
EXECUTE PROCEDURE verifFichier();


