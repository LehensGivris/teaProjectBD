SET datestyle TO 'european';

-- Tables Liens
DROP TABLE IF EXISTS Photographgie_Lieu, Fichier_Photographie, Iconographie_Photographie, Sujet_Photographie, Personne_Photographie, Personne_Metier, Photographgie_Date;

-- Tables "Clé Etrangère"
DROP TABLE IF EXISTS Discriminant, Remarque;

-- Tables Basiques
DROP TABLE IF EXISTS Date, Photographgie, NegatifOuReversible, Taille, Support, Lambert93, Fichier, Iconographie, Sujet, Personne, Metier;

CREATE TABLE Discriminant(
	discriminant VARCHAR(255),
	PRIMARY KEY(discriminant)
);

CREATE TABLE Remarque(
	id_remarque SERIAL,
	remarque VARCHAR(255),
	PRIMARY KEY(id_remarque)
);

CREATE TABLE Photographgie(
	id_photo SERIAL,
	cindoc VARCHAR(255),
	serie VARCHAR(255),
	article INTEGER,
	discriminant VARCHAR(255),
	description VARCHAR(65535),
	notes VARCHAR(65535),
	id_remarque INTEGER,
	PRIMARY KEY(id_photo),
	FOREIGN KEY (discriminant) REFERENCES Discriminant(discriminant),
	FOREIGN KEY (id_remarque) REFERENCES Remarque(id_remarque)
);

CREATE TABLE Date(
	id_date SERIAL,
	jour INTEGER,
	jour_bis INTEGER,
	mois INTEGER,
	mois_bis INTEGER,
	annee INTEGER,
	annee_bis INTEGER,
	PRIMARY KEY(id_date)
);

CREATE TABLE NegatifOuReversible(
	nr VARCHAR(255),
	PRIMARY KEY(nr)
);

CREATE TABLE Taille(
	taille VARCHAR(255),
	PRIMARY KEY(taille)
);

CREATE TABLE Support(
	id_support SERIAL,
	id_photo INTEGER,
	nbcliche INTEGER,
	taille VARCHAR(255),
	nr VARCHAR(255),
	NoirBlancOrColor VARCHAR(7),
	PRIMARY KEY(id),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo),
	FOREIGN KEY (taille) REFERENCES Taille(taille),
	FOREIGN KEY (nr) REFERENCES NegatifOuReversible(nr)
);

CREATE TABLE Lambert93(
	ref_lieux INTEGER,
	codeInsee INTEGER,
	codePostal INTEGER,
	nom VARCHAR(255),
	CoordX INTEGER,
	CoordY INTEGER,
	PRIMARY KEY(ref_lieux)
);

CREATE TABLE Fichier(
	id_fichier SERIAL,
	NomFichier VARCHAR(255),
	PRIMARY KEY(id_fichier)
);

CREATE TABLE Iconographie(
	index_icono VARCHAR(255),
	PRIMARY KEY(index_icono)
);

CREATE TABLE Sujet(
	id_sujet INTEGER,
	sujet VARCHAR(65535),
	PRIMARY KEY(id_sujet)
);

CREATE TABLE Personne(
	id_pers VARCHAR(255), -- Nom de la personne ou Notes ou Representation
	Nom VARCHAR(255),
	Prenom VARCHAR(255),
	Representation VARCHAR(255),
	Notes VARCHAR(255),
	PRIMARY KEY(id_pers)
);

CREATE TABLE Metier(
	id_metier INTEGER,
	Designation VARCHAR(255),
	PRIMARY KEY(id_metier)
);

CREATE TABLE Photographgie_Lieu(
	id_photo INTEGER,
	id_lambert INTEGER,
	PRIMARY KEY(id_photo,LambertId),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo),
	FOREIGN KEY (id_lambert) REFERENCES Lambert93(ref_lieux)
);

CREATE TABLE Fichier_Photographie(
	id_fichier INTEGER,
	id_photo INTEGER,
	PRIMARY KEY(id_fichier,id_photo),
	FOREIGN KEY (id_fichier) REFERENCES Fichier(id_fichier),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo)
);

CREATE TABLE Iconographie_Photographie(
	IconographieIndex VARCHAR(255),
	id_photo INTEGER,
	PRIMARY KEY(IconographieIndex,id_photo),
	FOREIGN KEY (IconographieIndex) REFERENCES Iconographie(Index),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo)
);

CREATE TABLE Sujet_Photographie(
	SujetIdsujet INTEGER,
	id_photo INTEGER,
	PRIMARY KEY(SujetIdsujet,id_photo),
	FOREIGN KEY (SujetIdsujet) REFERENCES Sujet(idSujet),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo)
);

CREATE TABLE Personne_Photographie(
	Personnepersonne VARCHAR(255),
	id_photo INTEGER,
	PRIMARY KEY(Personnepersonne,id_photo),
	FOREIGN KEY (Personnepersonne) REFERENCES Personne(personne),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo)
);

CREATE TABLE Personne_Metier(
	Personnepersonne VARCHAR(255),
	MetieridMetier INTEGER,
	PRIMARY KEY(Personnepersonne,MetieridMetier),
	FOREIGN KEY (Personnepersonne) REFERENCES Personne(personne),
	FOREIGN KEY (MetieridMetier) REFERENCES Metier(idMetier)
);

CREATE TABLE Photographgie_Date(
	id_photo INTEGER,
	id_date INTEGER,
	PRIMARY(id_photo,id_date),
	FOREIGN KEY (id_date) REFERENCES Date(id_date),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo)
);