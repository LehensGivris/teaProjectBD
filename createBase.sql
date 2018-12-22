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
	id_photo INTEGER NOT NULL,
	nbcliche INTEGER NOT NULL,
	taille VARCHAR(255) NOT NULL,
	nr VARCHAR(255) NOT NULL,
	NoirBlancOrColor VARCHAR(7) NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo),
	FOREIGN KEY (taille) REFERENCES Taille(taille),
	FOREIGN KEY (nr) REFERENCES NegatifOuReversible(nr)
);

CREATE TABLE Lambert93(
	ref_lieux INTEGER,
	codeInsee INTEGER,
	codePostal INTEGER NOT NULL,
	nom VARCHAR(255) NOT NULL,
	CoordX INTEGER NOT NULL,
	CoordY INTEGER NOT NULL,
	PRIMARY KEY(ref_lieux)
);

CREATE TABLE Fichier(
	id_fichier SERIAL,
	NomFichier VARCHAR(255) NOT NULL,
	PRIMARY KEY(id_fichier)
);

CREATE TABLE Iconographie(
	index_icono VARCHAR(255),
	PRIMARY KEY(index_icono)
);

CREATE TABLE Sujet(
	id_sujet INTEGER,
	sujet VARCHAR(65535) NOT NULL,
	PRIMARY KEY(id_sujet)
);

CREATE TABLE Personne(
	id_pers VARCHAR(255), -- Nom de la personne ou Notes ou Representation
	Nom VARCHAR(255),
	Prenom VARCHAR(255),
	Representation VARCHAR(255),
	Notes VARCHAR(4096),
	PRIMARY KEY(id_pers)
);

CREATE TABLE Metier(
	id_metier INTEGER,
	Designation VARCHAR(255) NOT NULL,
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
	id_photo INTEGER,
	id_fichier INTEGER,
	PRIMARY KEY(id_photo,id_fichier),
	FOREIGN KEY (id_fichier) REFERENCES Fichier(id_fichier),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo)
);

CREATE TABLE Iconographie_Photographie(
	id_photo INTEGER,
	index_icono VARCHAR(255),
	PRIMARY KEY(id_photo,index_icono),
	FOREIGN KEY (index_icono) REFERENCES Iconographie(index_icono),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo)
);

CREATE TABLE Sujet_Photographie(
	id_photo INTEGER,
	id_sujet INTEGER,
	PRIMARY KEY(id_photo,id_sujet),
	FOREIGN KEY (id_sujet) REFERENCES Sujet(id_sujet),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo)
);

CREATE TABLE Personne_Photographie(
	id_photo INTEGER,
	id_pers VARCHAR(255),
	PRIMARY KEY(id_photo,id_pers),
	FOREIGN KEY (id_pers) REFERENCES Personne(id_pers),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo)
);

CREATE TABLE Personne_Metier(
	id_pers VARCHAR(255),
	id_metier INTEGER,
	PRIMARY KEY(id_pers,id_metier),
	FOREIGN KEY (id_pers) REFERENCES Personne(id_pers),
	FOREIGN KEY (id_metier) REFERENCES Metier(id_metier)
);

CREATE TABLE Photographgie_Date(
	id_photo INTEGER,
	id_date INTEGER,
	PRIMARY(id_photo,id_date),
	FOREIGN KEY (id_date) REFERENCES Date(id_date),
	FOREIGN KEY (id_photo) REFERENCES Photographgie(id_photo)
);