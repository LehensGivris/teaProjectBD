SET datestyle TO 'european';

DROP TABLE IF EXISTS DataImported, DataTempo;

CREATE TABLE DataImported(
	RefCindoc VARCHAR(200),
	Serie Text,
	Article Text,
	Discriminant Text,
	Ville Text,
	Sujet Text,
	DescriptionDetaille Text,
	dateArchive Text,
	NoteBasPage Text,
	IndexPersonnes Text,
	FichierNumerique Text,
	IndexIconographique Text,
	NbCliche Text,
	TailleCliche Text,
	NegatInversible Text,
	Couleur Text,
	Remarque Text
);

CREATE TABLE DataTempo(
	
);

COPY DataImported FROM 'C:\Users\llelann\Downloads\data.csv' DELIMITER '	' CSV HEADER;