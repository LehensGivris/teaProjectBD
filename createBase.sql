SET datestyle TO 'european';

DROP TABLE IF EXISTS Photographgie, Discriminant, Support;

CREATE TABLE Photographgie(
	id SERIAL,
	cindoc VARCHAR(255),
	serie VARCHAR(255),
	article INTEGER,
	discriminant VARCHAR(255),
	description VARCHAR(65535),
	notes VARCHAR(65535),
	date INTEGER,
	RemarqueidRemarque INTEGER,
	PRIMARY KEY(id)
);

CREATE TABLE Discriminant(
	discriminant VARCHAR(255),
	PRIMARY KEY(discriminant)
);

CREATE TABLE Date(
	id SERIAL,
	jour INTEGER,
	mois INTEGER,
	annee INTEGER
);

CREATE TABLE Remarque(
	idRemarque SERIAL,
	remarque VARCHAR(255)
);

CREATE TABLE Support(
	id SERIAL,
	idphoto INTEGER,
	nbcliche INTEGER,
	taille VARCHAR(255),
	nr VARCHAR(255),
	NoirBlancOrColor VARCHAR(7),
	PRIMARY KEY(id)
);

CREATE TABLE NegatifOuReversible(
	nr VARCHAR(255),
	PRIMARY KEY(nr)
);

CREATE TABLE Taille(
	taille VARCHAR(255),
	PRIMARY KEY(taille)
);

CREATE TABLE Photographgie_Lieu(
	Photographgieid INTEGER,
	LambertId INTEGER,
	PRIMARY KEY(Photographgieid,LambertId)
);

CREATE TABLE Lambert93(
	refLieux INTEGER,
	codeInsee INTEGER,
	codePostal INTEGER,
	nom VARCHAR(255),
	CoordX INTEGER,
	CoordY INTEGER,
	PRIMARY KEY(refLieux)
);

CREATE TABLE Fichier_Photographie(
	FichieridFichier INTEGER,
	Photographgieid INTEGER,
	PRIMARY KEY(FichieridFichier,Photographgieid)
);

CREATE TABLE Fichier(
	idFichier SERIAL,
	NomFichier VARCHAR(255),
	PRIMARY KEY(idFichier)
);

CREATE TABLE Iconographie_Photographie(
	IconographieIndex VARCHAR(255),
	Photographgieid INTEGER,
	PRIMARY KEY(IconographieIndex,Photographgieid)
);

CREATE TABLE Iconographie(
	Index VARCHAR(255),
	PRIMARY KEY(Index)
);

CREATE TABLE Sujet_Photographie(
	SujetIdsujet INTEGER,
	Photographgieid INTEGER,
	PRIMARY KEY(SujetIdsujet,Photographgieid)
);

CREATE TABLE Sujet(
	idSujet INTEGER,
	sujet VARCHAR(65535)
);

CREATE TABLE Personne_Photographie(
	Personnepersonne VARCHAR(255),
	Photographgieid INTEGER,
	PRIMARY KEY(Personnepersonne,Photographgieid)
);

CREATE TABLE Personne(
	personne VARCHAR(255), -- Nom de la personne ou Notes ou Representation
	Nom VARCHAR(255),
	Prenom VARCHAR(255),
	Representation VARCHAR(255),
	Notes VARCHAR(255),
	PRIMARY KEY(personne)
);

CREATE TABLE Personne_Metier(
	Personnepersonne VARCHAR(255),
	MetieridMetier INTEGER,
	PRIMARY KEY(Personnepersonne,MetieridMetier)
);

CREATE TABLE Metier(
	idMetier INTEGER,
	Designation VARCHAR(255),
	PRIMARY KEY(idMetier)
);