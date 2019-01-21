SET datestyle TO 'european';

DROP TABLE IF EXISTS Photographgie_Lieu, Fichier_Photographie, Iconographie_Photographie, Sujet_Photographie, Personne_Photographie, Personne_Metier;
DROP TABLE IF EXISTS Discriminant, Date, Remarque, Photographgie, NegatifOuReversible, Taille, Support, Lambert93, Fichier, Iconographie, Sujet, Personne, Metier;

CREATE TABLE Discriminant(
	discriminant VARCHAR(255),
	PRIMARY KEY(discriminant)
);

CREATE TABLE Date(
	id SERIAL,
	jour INTEGER,
	mois INTEGER,
	annee INTEGER,
	PRIMARY KEY(id)
);

CREATE TABLE Remarque(
	idRemarque SERIAL,
	remarque VARCHAR(255),
	PRIMARY KEY(idRemarque)
);

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
	PRIMARY KEY(id),
	FOREIGN KEY (discriminant) REFERENCES Discriminant(discriminant),
	FOREIGN KEY (date) REFERENCES Date(id),
	FOREIGN KEY (RemarqueidRemarque) REFERENCES Remarque(idRemarque)
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
	id SERIAL,
	idphoto INTEGER,
	nbcliche INTEGER,
	taille VARCHAR(255),
	nr VARCHAR(255),
	NoirBlancOrColor VARCHAR(7),
	PRIMARY KEY(id),
	FOREIGN KEY (idphoto) REFERENCES Photographgie(id),
	FOREIGN KEY (taille) REFERENCES Taille(taille),
	FOREIGN KEY (nr) REFERENCES NegatifOuReversible(nr)
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

CREATE TABLE Fichier(
	idFichier SERIAL,
	NomFichier VARCHAR(255),
	PRIMARY KEY(idFichier)
);

CREATE TABLE Iconographie(
	Index VARCHAR(255),
	PRIMARY KEY(Index)
);

CREATE TABLE Sujet(
	idSujet INTEGER,
	sujet VARCHAR(65535)
);

CREATE TABLE Personne(
	personne VARCHAR(255), -- Nom de la personne ou Notes ou Representation
	Nom VARCHAR(255),
	Prenom VARCHAR(255),
	Representation VARCHAR(255),
	Notes VARCHAR(255),
	PRIMARY KEY(personne)
);

CREATE TABLE Metier(
	idMetier INTEGER,
	Designation VARCHAR(255),
	PRIMARY KEY(idMetier)
);

CREATE TABLE Photographgie_Lieu(
	Photographgieid INTEGER,
	LambertId INTEGER,
	PRIMARY KEY(Photographgieid,LambertId),
	FOREIGN KEY (Photographgieid) REFERENCES Photographgie(id),
	FOREIGN KEY (LambertId) REFERENCES Lambert93(refLieux)
);

CREATE TABLE Fichier_Photographie(
	FichieridFichier INTEGER,
	Photographgieid INTEGER,
	PRIMARY KEY(FichieridFichier,Photographgieid),
	FOREIGN KEY (FichieridFichier) REFERENCES Fichier(idFichier),
	FOREIGN KEY (Photographgieid) REFERENCES Photographgie(id)
);

CREATE TABLE Iconographie_Photographie(
	IconographieIndex VARCHAR(255),
	Photographgieid INTEGER,
	PRIMARY KEY(IconographieIndex,Photographgieid),
	FOREIGN KEY (IconographieIndex) REFERENCES Iconographie(Index),
	FOREIGN KEY (Photographgieid) REFERENCES Photographgie(id)
);

CREATE TABLE Sujet_Photographie(
	SujetIdsujet INTEGER,
	Photographgieid INTEGER,
	PRIMARY KEY(SujetIdsujet,Photographgieid),
	FOREIGN KEY (SujetIdsujet) REFERENCES Sujet(idSujet),
	FOREIGN KEY (Photographgieid) REFERENCES Photographgie(id)
);

CREATE TABLE Personne_Photographie(
	Personnepersonne VARCHAR(255),
	Photographgieid INTEGER,
	PRIMARY KEY(Personnepersonne,Photographgieid),
	FOREIGN KEY (Personnepersonne) REFERENCES Personne(personne),
	FOREIGN KEY (Photographgieid) REFERENCES Photographgie(id)
);

CREATE TABLE Personne_Metier(
	Personnepersonne VARCHAR(255),
	MetieridMetier INTEGER,
	PRIMARY KEY(Personnepersonne,MetieridMetier),
	FOREIGN KEY (Personnepersonne) REFERENCES Personne(personne),
	FOREIGN KEY (MetieridMetier) REFERENCES Metier(idMetier)
);