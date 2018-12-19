set datestyle to 'european';

DROP TABLE IF EXISTS Photographgie, Discriminant, Support;

CREATE TABLE Photographgie(
	id SERIAL,
	cindoc VARCHAR(255),
	serie VARCHAR(255),
	article INTEGER(10),
	discriminant VARCHAR(255),
	description VARCHAR(65535),
	notes VARCHAR(65535),
	'date' INTEGER(10),
	RemarqueidRemarque INTEGER(10),
	PRIMARY KEY(id)
);

CREATE TABLE Discriminant(
	discriminant VARCHAR(255),
	PRIMARY KEY(discriminant)
);

CREATE TABLE Date(
	id SERIAL,
	jour INTEGER(10),
	mois INTEGER(10),
	annee INTEGER(10)
);

CREATE TABLE Remarque(
	idRemarque SERIAL,
	remarque VARCHAR(255)
);

CREATE TABLE Support(
	id SERIAL,
	idphoto INTEGER(10),
	nbcliche INTEGER(10),
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
	Photographgieid INTEGER(10),
	LambertId INTEGER(10),
	PRIMARY KEY(Photographgie_Lieu,LambertId)
);

CREATE TABLE Lambert93(
	refLieux INTEGER(10),
	codeInsee INTEGER(10),
	codePostal INTEGER(10),
	nom VARCHAR(255),
	CoordX INTEGER(10),
	CoordY INTEGER(10),
	PRIMARY KEY(refLieux)
);

CREATE TABLE Fichier_Photographie(
	FichieridFichier INTEGER(10),
	Photographgieid INTEGER(10),
	PRIMARY KEY(FichieridFichier,Photographgieid)
);

CREATE TABLE Fichier(
	idFichier SERIAL,
	NomFichier VARCHAR(255),
	PRIMARY KEY(idFichier)
);

