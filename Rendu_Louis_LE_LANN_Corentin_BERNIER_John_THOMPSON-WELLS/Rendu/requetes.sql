--Chargement Initial de la base de données
SET datestyle TO 'european';

-- Suppression des tables existantes dans le bon ordre
-- Tables Liens
DROP TABLE IF EXISTS Photographie_Lieu, Fichier_Photographie, Iconographie_Photographie, Sujet_Photographie, Personne_Photographie, Personne_Metier, Photographie_Date, Cindoc_Photographie;

-- Tables Basiques
DROP TABLE IF EXISTS Date, Photographie, NegatifOuReversible, Taille, Support, Lambert93, Fichier, Iconographie, Sujet, Personne, Metier, Cindoc;

-- Tables "Clé Etrangère"
DROP TABLE IF EXISTS Discriminant, Remarque;

-- Suppression table de transfert existante
DROP TABLE IF EXISTS DataImported;

-- Création table de transfert
CREATE TABLE DataImported (
	Cindoc VARCHAR(255),
	Serie VARCHAR(255),
	Article INTEGER,
	Disc Text default null,
	Ville Text,
	Sujet Text,
	Descr Text,
	Date Text,
	NoteBasPage Text,
	IndexP Text,
	FichierN Text,
	IndexIco Text,
	NbCliche Text,
	TailleC Text,
	NegatReve Text,
	Couleur VARCHAR(255),
	Remarq Text
);

-- Créations des tables
CREATE TABLE Discriminant(
	discriminant VARCHAR(255),
	PRIMARY KEY(discriminant)
);

CREATE TABLE Remarque(
	id_remarque SERIAL,
	remarque VARCHAR(255),
	PRIMARY KEY(id_remarque)
);

CREATE TABLE Photographie(
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

CREATE TABLE Cindoc(
	index_cindoc VARCHAR(255),
	PRIMARY KEY(index_cindoc)
);

CREATE TABLE Date(
	id_date SERIAL,
	jour INTEGER,
	jour_bis INTEGER,
	mois VARCHAR(255),
	mois_bis VARCHAR(255),
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
	PRIMARY KEY(id_support),
	FOREIGN KEY (id_photo) REFERENCES Photographie(id_photo),
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
	id_sujet SERIAL,
	sujet VARCHAR(65535) NOT NULL,
	PRIMARY KEY(id_sujet)
);

CREATE TABLE Personne(
	id_pers SERIAL,
	Nom VARCHAR(255),
	Prenom VARCHAR(255),
	Representation VARCHAR(255),
	Notes VARCHAR(4096),
	PRIMARY KEY(id_pers)
);

CREATE TABLE Metier(
	id_metier SERIAL,
	Designation VARCHAR(255) NOT NULL,
	PRIMARY KEY(id_metier)
);

CREATE TABLE Photographie_Lieu(
	id_photo INTEGER,
	id_lambert INTEGER,
	PRIMARY KEY(id_photo,id_lambert),
	FOREIGN KEY (id_photo) REFERENCES Photographie(id_photo),
	FOREIGN KEY (id_lambert) REFERENCES Lambert93(ref_lieux)
);

CREATE TABLE Fichier_Photographie(
	id_photo INTEGER,
	id_fichier INTEGER,
	PRIMARY KEY(id_photo,id_fichier),
	FOREIGN KEY (id_fichier) REFERENCES Fichier(id_fichier),
	FOREIGN KEY (id_photo) REFERENCES Photographie(id_photo)
);

CREATE TABLE Iconographie_Photographie(
	id_photo INTEGER,
	index_icono VARCHAR(255),
	PRIMARY KEY(id_photo,index_icono),
	FOREIGN KEY (index_icono) REFERENCES Iconographie(index_icono),
	FOREIGN KEY (id_photo) REFERENCES Photographie(id_photo)
);

CREATE TABLE Sujet_Photographie(
	id_photo INTEGER,
	id_sujet INTEGER,
	PRIMARY KEY(id_photo,id_sujet),
	FOREIGN KEY (id_sujet) REFERENCES Sujet(id_sujet),
	FOREIGN KEY (id_photo) REFERENCES Photographie(id_photo)
);

CREATE TABLE Personne_Photographie(
	id_photo INTEGER,
	id_pers INTEGER,
	PRIMARY KEY(id_photo,id_pers),
	FOREIGN KEY (id_pers) REFERENCES Personne(id_pers),
	FOREIGN KEY (id_photo) REFERENCES Photographie(id_photo)
);

CREATE TABLE Personne_Metier(
	id_pers INTEGER,
	id_metier INTEGER,
	PRIMARY KEY(id_pers,id_metier),
	FOREIGN KEY (id_pers) REFERENCES Personne(id_pers),
	FOREIGN KEY (id_metier) REFERENCES Metier(id_metier)
);

CREATE TABLE Photographie_Date(
	id_photo INTEGER,
	id_date INTEGER,
	PRIMARY KEY(id_photo,id_date),
	FOREIGN KEY (id_date) REFERENCES Date(id_date),
	FOREIGN KEY (id_photo) REFERENCES Photographie(id_photo)
);

CREATE TABLE Cindoc_Photographie(
	index_cindoc VARCHAR(255),
	id_photo INTEGER,
	PRIMARY KEY(index_cindoc,id_photo),
	FOREIGN KEY (index_cindoc) REFERENCES Cindoc(index_cindoc),
	FOREIGN KEY (id_photo) REFERENCES Photographie(id_photo)
);

-- Indexs optimisations

DROP INDEX IF EXISTS nameLm;
CREATE INDEX nameLm ON Lambert93 USING hash(nom);

DROP INDEX IF EXISTS nomP;
CREATE INDEX nomP ON Personne USING hash(nom);
DROP INDEX IF EXISTS pnomP;
CREATE INDEX pnomP ON Personne USING hash(Prenom);

DROP INDEX IF EXISTS sujetI;
CREATE INDEX sujetI ON Sujet USING hash(sujet);

DROP INDEX IF EXISTS persMetA;
CREATE INDEX persMetA ON Personne_Metier(id_pers);
DROP INDEX IF EXISTS persMetB;
CREATE INDEX persMetB ON Personne_Metier(id_metier);

DROP INDEX IF EXISTS persPhoA;
CREATE INDEX persPhoA ON Personne_Photographie(id_photo);
DROP INDEX IF EXISTS persPhoB;
CREATE INDEX persPhoB ON Personne_Photographie(id_pers);

DROP INDEX IF EXISTS fichPhoA;
CREATE INDEX fichPhoA ON Fichier_Photographie(id_photo);
DROP INDEX IF EXISTS fichPhoB;
CREATE INDEX fichPhoB ON Fichier_Photographie(id_fichier);

DROP INDEX IF EXISTS sujPhoA;
CREATE INDEX sujPhoA ON Sujet_Photographie(id_photo);
DROP INDEX IF EXISTS sujPhoB;
CREATE INDEX sujPhoB ON Sujet_Photographie(id_sujet);

DROP INDEX IF EXISTS icoPhoA;
CREATE INDEX icoPhoA ON iconographie_Photographie(id_photo);
DROP INDEX IF EXISTS icoPhoB;
CREATE INDEX icoPhoB ON iconographie_Photographie USING hash(index_icono);

DROP INDEX IF EXISTS lieuPhoA;
CREATE INDEX lieuPhoA ON Photographie_Lieu(id_photo);
DROP INDEX IF EXISTS lieuPhoB;
CREATE INDEX lieuPhoB ON Photographie_Lieu(id_lambert);

DROP INDEX IF EXISTS datePhoA;
CREATE INDEX datePhoA ON Photographie_Date(id_photo);
DROP INDEX IF EXISTS datePhoB;
CREATE INDEX datePhoB ON Photographie_Date(id_date);

CREATE OR REPLACE FUNCTION norm_text_latin(character varying) 
RETURNS character varying AS $$
DECLARE 
        p_str    alias for $1; 
        v_str    varchar; 
BEGIN 
        select translate(p_str, 'ÀÁÂÃÄÅ', 'AAAAAA') into v_str; 
        select translate(v_str, 'ÉÈËÊ', 'EEEE') into v_str; 
        select translate(v_str, 'ÌÍÎÏ', 'IIII') into v_str; 
        select translate(v_str, 'ÌÍÎÏ', 'IIII') into v_str; 
        select translate(v_str, 'ÒÓÔÕÖ', 'OOOOO') into v_str; 
        select translate(v_str, 'ÙÚÛÜ', 'UUUU') into v_str; 
        select translate(v_str, 'àáâãäå', 'aaaaaa') into v_str; 
        select translate(v_str, 'èéêë', 'eeee') into v_str; 
        select translate(v_str, 'ìíîï', 'iiii') into v_str; 
        select translate(v_str, 'òóôõö', 'ooooo') into v_str; 
        select translate(v_str, 'ùúûü', 'uuuu') into v_str; 
        select translate(v_str, 'Çç', 'Cc') into v_str; 
        return v_str; 
END;
$$LANGUAGE 'plpgsql'; 

CREATE OR REPLACE FUNCTION verifMois(month character varying)
RETURNS character varying AS $$
DECLARE
	testM TEXT;
BEGIN
	testM := (SELECT LOWER(norm_text_latin(month)));
	IF testM IS NULL OR testM = '' THEN
		RETURN NULL;
	END IF; 

	IF (SELECT month SIMILAR TO '[mai]{2,3}') THEN
		RETURN 'mai';
	END IF;
	IF (SELECT month SIMILAR TO '[mars]{3,4}') THEN
		RETURN 'mars';
	END IF;
	IF (SELECT month SIMILAR TO '[juin]{2,4}') THEN
		RETURN 'juin';
	END IF;
	IF (SELECT month SIMILAR TO '[aout]{2,4}') THEN
		RETURN 'aout';
	END IF;
	IF (SELECT month SIMILAR TO '[avril]{3,5}') THEN
		RETURN 'avril';
	END IF;
	IF (SELECT month SIMILAR TO '[janvier]{6,7}') THEN
		RETURN 'janvier';
	END IF;
	IF (SELECT month SIMILAR TO '[fevrier]{6,7}') THEN
		RETURN 'fevrier';
	END IF;
	IF (SELECT month SIMILAR TO '[juillet]{4,7}') THEN
		RETURN 'juillet';
	END IF;
	IF (SELECT month SIMILAR TO '[octobre]{4,7}') THEN
		RETURN 'octobre';
	END IF;
	IF (SELECT month SIMILAR TO '[novembre]{6,8}') THEN
		RETURN 'novembre';
	END IF;
	IF (SELECT month SIMILAR TO '[decembre]{6,8}') THEN
		RETURN 'decembre';
	END IF;
	IF (SELECT month SIMILAR TO '[septembre]{7,9}') THEN
		RETURN 'septembre';
	END IF;
	
	RETURN testM;
END;
$$LANGUAGE 'plpgsql';

-- Fonctions
create or replace function insert_tout()
returns trigger as $$
declare
	--Temporaire
    tmp text;
    tmp2 text;
	tmp3 text;
	tmp8 text;
	tmp9 text;

	tmp4 text[];
	tmp5 text[];

	tmpI int;

    --remarque
    remarque_id int;
    --photographie
    photo_id int;
	--cindoc
	indexCindoc text;
    --date
    dcurs cursor for select * from date_split(new.Date);
    d record;

    date_id int;
	date_j int;
	date_j_b int;
	date_m text;
	date_m_b text;
	date_a int;
	date_a_b int;
	date_cache text[];
    --support
    t text[];
    neg text[];
    c text[];
    nb text[];
    support_id int;
    --fichier
    fichier_id int;
	--iconographie

    --sujet
    sujet_id int;
    --personne
    pers_id int;
	pers_Nom text;
	pers_Prenom text;
	pers_desig text;
	pers_note text;
	pers_job text;

	--metier
	metier_id int;
	metier_desig text;

    --lambert
    lamb_id int;
	maxId int;
begin
    --discriminant
    if new.Disc is not null and not exists (select * from Discriminant
    	where discriminant = new.Disc) then
    	insert into Discriminant values (new.Disc);
    end if;

    --remarque
    if new.Remarq is not null then
    	if not exists (select * from Remarque
    		where remarque = new.Remarq) then
    			insert into Remarque(remarque) values (new.Remarq) returning id_remarque into remarque_id;
    	else
    	remarque_id := (select id_remarque from Remarque as r where r.remarque = new.Remarq);
    	end if;
    end if;

    --photographie
    insert into Photographie(cindoc,serie,article,discriminant,description,notes,id_remarque) values (new.Cindoc,new.Serie,new.Article,new.Disc,new.Descr,new.NoteBasPage,remarque_id) returning id_photo into photo_id;
    
	--cindoc
	IF NEW.Cindoc IS NOT NULL THEN
		IF regexp_split_to_array(new.Cindoc,' \| ') IS NOT NULL THEN
			foreach tmp in array regexp_split_to_array(new.Cindoc,' \| ')
			LOOP
				if not exists (select index_cindoc from Cindoc where index_cindoc=tmp) then
					insert into Cindoc(index_cindoc) values (tmp) returning index_cindoc into indexCindoc;
				else
					indexCindoc := (select index_cindoc from Cindoc where index_cindoc=tmp);
				end if;
				IF NOT EXISTS(SELECT * FROM Cindoc_Photographie WHERE index_cindoc=indexCindoc AND id_photo=photo_id) THEN
					insert into Cindoc_Photographie values(indexCindoc,photo_id);
				END IF;
			END LOOP;
		END IF;
	END IF;

	--date
	IF NEW.Date IS NOT NULL THEN
		SELECT REPLACE(NEW.Date,' | ','/ ') INTO tmp;
		
		IF tmp IS NOT NULL AND regexp_split_to_array(tmp,'/') IS NOT NULL THEN
			foreach tmp2 in array regexp_split_to_array(tmp,'/')
			loop
				if tmp2 is not null then
					SELECT regexp_split_to_array(ltrim(tmp2,'Prise de vue:'),' ') INTO date_cache;

					CASE
						WHEN cardinality(date_cache) = 3 THEN
							IF cardinality(regexp_split_to_array(date_cache[1],'-')) = 2 THEN
								date_j := to_number(((regexp_split_to_array(date_cache[1],'-'))[1]),'9999');
								date_j_b := to_number(((regexp_split_to_array(date_cache[1],'-'))[2]),'9999');
							ELSE
								date_j := (to_number(date_cache[1],'9999'));
							END IF;

							IF cardinality(regexp_split_to_array(date_cache[2],'-')) = 2 THEN
							--Here
								date_m := (SELECT verifMois((regexp_split_to_array(date_cache[2],'-'))[1]));
								date_m_b := (SELECT verifMois((regexp_split_to_array(date_cache[2],'-'))[2]));
							ELSE
								date_m := (SELECT verifMois(date_cache[2]));
							END IF;

							IF cardinality(regexp_split_to_array(date_cache[3],'-')) = 2 THEN
								date_a := to_number(((regexp_split_to_array(date_cache[3],'-'))[1]),'9999');
								date_a_b := to_number(((regexp_split_to_array(date_cache[3],'-'))[2]),'9999');
							ELSE
								date_a := (to_number(date_cache[3],'9999'));
							END IF;
						WHEN cardinality(date_cache) = 2 THEN
							IF cardinality(regexp_split_to_array(date_cache[1],'-')) = 2 THEN
							--Here
								date_m := (SELECT verifMois((regexp_split_to_array(date_cache[1],'-'))[1]));
								date_m_b := (SELECT verifMois((regexp_split_to_array(date_cache[1],'-'))[2]));
							ELSE
								date_m := (SELECT verifMois(date_cache[1]));
							END IF;

							IF cardinality(regexp_split_to_array(date_cache[2],'-')) = 2 THEN
								date_a := to_number(((regexp_split_to_array(date_cache[2],'-'))[1]),'9999');
								date_a_b := to_number(((regexp_split_to_array(date_cache[2],'-'))[2]),'9999');
							ELSE
								date_a := (to_number(date_cache[2],'9999'));
							END IF;
						WHEN cardinality(date_cache) = 1 THEN
							IF cardinality(regexp_split_to_array(date_cache[1],'-')) = 2 THEN
								date_a := to_number(((regexp_split_to_array(date_cache[1],'-'))[1]),'9999');
								date_a_b := to_number(((regexp_split_to_array(date_cache[1],'-'))[2]),'9999');
							ELSE
								date_a := (to_number(date_cache[1],'9999'));
							END IF;
						ELSE
							date_a := NULL;
					END CASE;

					IF NOT EXISTS(SELECT * FROM DATE WHERE jour = date_j AND mois = date_m AND annee = date_a AND jour_bis = date_j_b AND mois_bis = date_m_b AND annee_bis = date_a_b) THEN
						INSERT INTO DATE(jour,jour_bis,mois,mois_bis,annee,annee_bis) VALUES(date_j,date_j_b,date_m,date_m_b,date_a,date_a_b) returning id_date into date_id;
						INSERT INTO Photographie_Date(id_photo,id_date) VALUES (photo_id,date_id);
					ELSE
						IF NOT EXISTS(SELECT * FROM Photographie_Date WHERE id_date = date_id AND photo_id = id_photo) THEN
							INSERT INTO Photographie_Date(id_photo,id_date) VALUES (photo_id,date_id);
						END IF;
					END IF;
				end if;
			end loop;
		END IF;
	END IF;

    --taille
    t := regexp_split_to_array(new.TailleC,', ');
	IF t IS NOT NULL THEN
		foreach tmp in array t
		loop
			if tmp is not null and not exists (select * from Taille
				where taille = tmp) then
					insert into Taille(taille) values (tmp);
				end if;
		end loop;
	END IF;

    --negatif reversible
    neg := regexp_split_to_array(new.NegatReve,', ');
	IF neg IS NOT NULL THEN
		foreach tmp in array neg
		loop
			if tmp is not null and not exists (select * from NegatifOuReversible
				where nr = tmp) then
					insert into NegatifOuReversible(nr) values (tmp);
				end if;
		end loop;
	END IF;

    --support
    nb := regexp_split_to_array(new.NbCliche,', ');
    c := regexp_split_to_array(new.Couleur,', ');
	IF nb IS NOT NULL AND c IS NOT NULL THEN
		for i in 1..array_length(nb,1)
		loop
			insert into Support(id_photo,nbcliche,taille,nr,NoirBlancOrColor) values (photo_id,to_number(nb[i],'9'),t[i],neg[i],c[i]) returning id_support into support_id;
		end loop;
	END IF;

    --fichier
	IF NEW.FichierN IS NOT NULL THEN
		SELECT REPLACE(NEW.FichierN,' | ','/ ') INTO tmp;
		IF tmp IS NOT NULL AND regexp_split_to_array(tmp,'/') IS NOT NULL THEN
			foreach tmp2 in array regexp_split_to_array(tmp,'/')
			loop
				if tmp2 is not null then
					if not exists (select * from Fichier where NomFichier=new.FichierN) then
						insert into Fichier(NomFichier) values (tmp2) returning id_fichier into fichier_id;
					else
						fichier_id := (select MIN(id_fichier) from Fichier where NomFichier=new.FichierN);
					end if;
					insert into Fichier_Photographie values(photo_id,fichier_id);
				end if;
			end loop;
		END IF;
	END IF;

    --iconographie
	IF NEW.IndexIco IS NOT NULL THEN
		SELECT REPLACE(NEW.IndexIco,' | ','/ ') INTO tmp;
		IF regexp_split_to_array(tmp,'/ ') IS NOT NULL THEN
			foreach tmp2 in array regexp_split_to_array(tmp,'/ ')
			loop
				if tmp2 is not null then
					if not exists (select index_icono from Iconographie where index_icono=tmp2) then
						insert into Iconographie values (tmp2);
					end if;
					IF NOT EXISTS (SELECT index_icono FROM Iconographie_Photographie WHERE index_icono = tmp2) THEN
						insert into Iconographie_Photographie values(photo_id,tmp2);
					END IF;
				end if;
			end loop;
		END IF;
	END IF;
	
    --sujet
    if tmp is not null then
    	if not exists (select * from Sujet where sujet=tmp) then
    		insert into Sujet(sujet) values (tmp) returning id_sujet into sujet_id;
    	else
    		sujet_id := (select id_sujet from Sujet where sujet=tmp);
    	end if;
    	insert into Sujet_Photographie values(photo_id,sujet_id);
    end if;

    --personne and metier
	IF NEW.IndexP IS NOT NULL THEN
		SELECT REPLACE(NEW.IndexP,' | ','/') INTO tmp;
		tmp4 := regexp_split_to_array(tmp,'/');
		IF tmp2 IS NOT NULL THEN
			FOREACH tmp2 IN ARRAY tmp4
			LOOP
				tmp9 := norm_text_latin(tmp2);

				pers_Nom := (SELECT SUBSTRING(tmp9,'((([ A-Z]|-[A-Z]|[A-Z]){2,}[,]{0,1})[ ]{1,})'));

				tmp9 = (SELECT REPLACE(tmp9,pers_Nom,''));
				
				IF pers_Nom IS NOT NULL THEN
					pers_Nom = (SELECT REPLACE(pers_Nom,',',''));
					pers_Nom = (SELECT TRIM(pers_Nom));
					pers_job := (SELECT SUBSTRING(tmp9,'\(.*.\)'));
					
					IF pers_Job IS NOT NULL THEN
						tmp9 = (SELECT REPLACE(tmp9,pers_job,''));
					END IF;
					
					pers_note := (SELECT SUBSTRING(tmp9, ', [a-z]{1,}'));
					IF pers_note IS NOT NULL THEN
						pers_note = (SELECT REPLACE(pers_note,',',''));
						tmp9 = (SELECT REPLACE(tmp9,pers_note,''));
						tmp9 = (SELECT REPLACE(tmp9,'voir aussi',''));
					END IF;

					IF tmp9 IS NOT NULL THEN
						pers_Prenom := (SELECT TRIM(tmp9));
						IF pers_Prenom = '' THEN
							pers_Prenom = NULL;
						END IF;
						IF pers_Prenom IS NOT NULL THEN
							pers_Prenom = (SELECT TRIM(pers_Prenom));
							tmp9 = pers_Prenom;
							pers_Prenom = (SELECT SUBSTRING(pers_Prenom,0,strpos(pers_Prenom,',')));
							tmp9 = (SELECT REPLACE(tmp9,pers_Prenom,''));
						END IF;
					END IF;

					IF tmp9 IS NOT NULL THEN
						pers_desig := pers_note || tmp9;
						pers_desig = (SELECT REPLACE(pers_desig,',',''));
					END IF;

					pers_note = (SELECT Substring(pers_Prenom,strpos(pers_Prenom,'voir aussi'),length(pers_Prenom)));
				ELSE
					pers_note = tmp2;
					pers_Nom = (SELECT SUBSTRING(pers_note,'[A-Z]{2,}'));
				END IF;

				IF pers_Prenom = '' THEN
					pers_Prenom = NULL;
				ELSE
					pers_Prenom = (SELECT TRIM(pers_Prenom));
				END IF;

				IF pers_desig = '' THEN
					pers_desig = NULL;
				ELSE
					pers_desig = (SELECT TRIM(pers_desig));
				END IF;

				IF pers_note = '' THEN
					pers_note = NULL;
				ELSE
					pers_note = (SELECT TRIM(pers_note));
					IF pers_note = pers_Prenom THEN
						pers_note = NULL;
					END IF;
				END IF;

				IF pers_Nom IS NOT NULL THEN
					IF pers_Prenom IS NOT NULL THEN
						IF pers_desig IS NOT NULL THEN
							IF pers_note IS NOT NULL THEN
								IF EXISTS (SELECT * FROM Personne WHERE Nom = pers_Nom AND Prenom = pers_Prenom AND Representation = pers_desig AND Notes = pers_note) THEN
									pers_id := (SELECT id_pers FROM Personne WHERE Nom = pers_Nom AND Prenom = pers_Prenom AND Representation = pers_desig AND Notes = pers_note LIMIT 1);
								ELSE
									INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
								END IF;
							ELSE
								IF EXISTS (SELECT * FROM Personne WHERE Nom = pers_Nom AND Prenom = pers_Prenom AND Representation = pers_desig) THEN
									pers_id := (SELECT id_pers FROM Personne WHERE Nom = pers_Nom AND Prenom = pers_Prenom AND Representation = pers_desig LIMIT 1);
								ELSE
									INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
								END IF;
							END IF;
						ELSE
							IF pers_note IS NOT NULL THEN
								IF EXISTS (SELECT * FROM Personne WHERE Nom = pers_Nom AND Prenom = pers_Prenom AND Notes = pers_note) THEN
									pers_id := (SELECT id_pers FROM Personne WHERE Nom = pers_Nom AND Prenom = pers_Prenom AND Notes = pers_note LIMIT 1);
								ELSE
									INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
								END IF;
							ELSE
								IF EXISTS (SELECT * FROM Personne WHERE Nom = pers_Nom AND Prenom = pers_Prenom) THEN
									pers_id := (SELECT id_pers FROM Personne WHERE Nom = pers_Nom AND Prenom = pers_Prenom LIMIT 1);
								ELSE
									INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
								END IF;
							END IF;
						END IF;
					ELSE
						IF pers_desig IS NOT NULL THEN
							IF pers_note IS NOT NULL THEN
								IF EXISTS (SELECT * FROM Personne WHERE Nom = pers_Nom AND Representation = pers_desig AND Notes = pers_note) THEN
									pers_id := (SELECT id_pers FROM Personne WHERE Nom = pers_Nom AND Representation = pers_desig AND Notes = pers_note LIMIT 1);
								ELSE
									INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
								END IF;
							ELSE
								IF EXISTS (SELECT * FROM Personne WHERE Nom = pers_Nom AND Representation = pers_desig) THEN
									pers_id := (SELECT id_pers FROM Personne WHERE Nom = pers_Nom AND Representation = pers_desig LIMIT 1);
								ELSE
									INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
								END IF;
							END IF;
						ELSE
							IF pers_note IS NOT NULL THEN
								IF EXISTS (SELECT * FROM Personne WHERE Nom = pers_Nom AND Notes = pers_note) THEN
									pers_id := (SELECT id_pers FROM Personne WHERE Nom = pers_Nom AND Notes = pers_note LIMIT 1);
								ELSE
									INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
								END IF;
							ELSE
								IF EXISTS (SELECT * FROM Personne WHERE Nom = pers_Nom) THEN
									pers_id := (SELECT id_pers FROM Personne WHERE Nom = pers_Nom LIMIT 1);
								ELSE
									INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
								END IF;
							END IF;
						END IF;
					END IF;
				ELSE
					IF pers_desig IS NOT NULL THEN
						IF pers_note IS NOT NULL THEN
							IF EXISTS (SELECT * FROM Personne WHERE Representation = pers_desig AND Notes = pers_note) THEN
								pers_id := (SELECT id_pers FROM Personne WHERE Representation = pers_desig AND Notes = pers_note LIMIT 1);
							ELSE
								INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
							END IF;
						ELSE
							IF EXISTS (SELECT * FROM Personne WHERE Representation = pers_desig) THEN
								pers_id := (SELECT id_pers FROM Personne WHERE Representation = pers_desig LIMIT 1);
							ELSE
								INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
							END IF;
						END IF;
					ELSE
						IF pers_note IS NOT NULL THEN
							IF EXISTS (SELECT * FROM Personne WHERE Notes = pers_note) THEN
								pers_id := (SELECT id_pers FROM Personne WHERE Notes = pers_note LIMIT 1);
							ELSE
								INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
							END IF;
						ELSE
							INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;
						END IF;
					END IF;
				END IF;		

				IF pers_job IS NOT NULL THEN
					pers_job := (SELECT REPLACE(REPLACE(pers_job,'(',''),')',''));

					tmpI := (select array_length(string_to_array(pers_job, ','), 1) - 1);
					
					IF tmpI IS NOT NULL AND tmpI>0 THEN
						
						tmp5 := regexp_split_to_array(pers_job,',');
						FOREACH tmp3 IN ARRAY tmp5
						LOOP
							metier_desig := (SELECT TRIM(tmp3));
							IF metier_desig IS NOT NULL THEN
								IF NOT EXISTS (select * FROM Metier WHERE Designation = metier_desig) THEN
									INSERT INTO Metier(Designation) VALUES (metier_desig) returning id_metier into metier_id;
								ELSE
									metier_id := (select id_metier from Metier where Designation = metier_desig);
								END IF;
								IF NOT EXISTS (SELECT * FROM Personne_Metier WHERE id_metier = id_metier AND pers_id = id_pers) THEN
									INSERT INTO Personne_Metier(id_pers,id_metier) VALUES(pers_id,metier_id);
								END IF;
							END IF;
						END LOOP;
						
						tmpI := 1;
					ELSE
						pers_Job := (SELECT TRIM(pers_Job));
						IF NOT EXISTS (select * FROM Metier WHERE Designation = pers_job) THEN
							INSERT INTO Metier(Designation) VALUES (pers_job) returning id_metier into metier_id;
						ELSE
							metier_id := (select id_metier from Metier where Designation = pers_Job);
						END IF;
						IF NOT EXISTS (SELECT * FROM Personne_Metier WHERE id_metier = id_metier AND pers_id = id_pers) THEN
							INSERT INTO Personne_Metier(id_pers,id_metier) VALUES(pers_id,metier_id);
						END IF;
					END IF;						
				END IF;	
			END LOOP;
		END IF;
	END IF;

    --lambert
	IF NEW.Ville IS NOT NULL THEN
		IF regexp_split_to_array(new.Ville,', ') IS NOT NULL THEN
			foreach tmp in array regexp_split_to_array(new.Ville,', ')
			LOOP
				if exists (select nom from Lambert93 where nom=tmp) then
					lamb_id := (select MIN(ref_lieux) from Lambert93 where nom=tmp AND codePostal>0);
					IF lamb_id IS NOT NULL THEN
						IF NOT EXISTS(SELECT * FROM Photographie_Lieu WHERE id_lambert=lamb_id AND id_photo=photo_id) THEN
							insert into Photographie_Lieu values(photo_id,lamb_id);
						END IF;
					END IF;
				end if;
			END LOOP;
		END IF;
	END IF;
    return new;
end;
$$ language plpgsql;

DROP TRIGGER IF EXISTS insert_data ON DataImported;

create trigger insert_data
BEFORE insert on DataImported
for each row
execute procedure insert_tout();







--Pour ces 2 fichiers: mettre le chemin vers le fichier en chemin absolu (depuis la racine du disque), et donner les droits à "tout le monde" de lire ces fichiers

-- Insertion des données Lambert93 (Site originaire des données : http://www.pillot.fr/cartographe/index.php)
--Mettre le répertoire en chemin absolu d'où se trouve le fichier ville.csv
COPY Lambert93 FROM 'C:\Users\Louis LE LANN\Documents\GitHub\teaProjectBD\Part_01\villes.csv' DELIMITER ',' CSV HEADER ENCODING 'ISO-8859-15';

-- Insertion des données dans la table de transfert et séparation dans les bonnes tables
--Mettre le répertoire en chemin absolu d'où se trouve le fichier data.csv
COPY DataImported FROM 'C:\Users\Louis LE LANN\Documents\GitHub\teaProjectBD\Part_01\data.csv' DELIMITER '	' CSV HEADER;


-- -----------------------------------------
-- Emplacement des fonctions des triggers de suppression
CREATE OR REPLACE FUNCTION verifMetier()
RETURNS TRIGGER AS $$
    DECLARE
    BEGIN
        IF EXISTS (SELECT * FROM Metier WHERE Designation = New.Designation)
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
        IF NOT EXISTS (SELECT * FROM Personne WHERE Nom = New.Nom AND Prenom = New.Prenom AND Representation = New.Representation AND Notes = New.Notes)
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
        IF EXISTS (SELECT * FROM Date WHERE jour = New.jour AND jour_bis = New.jour_bis AND mois = New.mois AND mois_bis = New.mois_bis AND annee = New.annee AND annee_bis = New.annee_bis)
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
        IF EXISTS (SELECT * FROM Lambert93 WHERE nom = New.nom)
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
        IF NOT EXISTS (SELECT * FROM Sujet WHERE Sujet = New.Sujet)
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
        IF NOT EXISTS (SELECT * FROM Fichier WHERE NomFichier = New.NomFichier)
        THEN
            RETURN NEW;
        ELSE
            RETURN NULL;
        END IF;
    END;
$$ LANGUAGE PLPGSQL;

-- Emplacement Trigger de suppressions des doublons dans les tables où cela est possible et nescessaire

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



-- Requêtes de Test

SELECT *
FROM Photographie ph
JOIN Photographie_Lieu pl ON ph.id_photo = pl.id_photo;
JOIN Lambert93 lam ON pl.id_lambert = lam.ref_lieux;

SELECT *
FROM Photographie ph
JOIN Photographie_Date pd ON ph.id_photo = pl.id_photo;
JOIN DATE d ON pd.id_date d.id_date;

SELECT *
FROM Photographie ph
JOIN Support sp ON sp.id_photo = ph.id_photo;

SELECT ph.id_photo, count(cp.index_cindoc) as nbRefCindoc
FROM Photographie ph
JOIN Cindoc_Photographie cp ON ph.id_photo = cp.id_photo
JOIN Cindoc cd ON cd.index_cindoc = cp.index_cindoc
GROUP BY(ph.id_photo);

SELECT id_support
FROM Support
WHERE nbcliche > 1;

SELECT ph.id_photo,id_support,t.taille
FROM Photographie ph
JOIN Support sp ON sp.id_photo = ph.id_photo
JOIN Taille t ON sp.taille = t.taille
GROUP BY ph.id_photo,id_support,t.taille;

SELECT annee, count(ph.id_photo)
FROM Date d
JOIN Photographie_Date pd ON  pd.id_date = d.id_date
JOIN Photographie ph ON ph.id_photo = pd.id_photo
WHERE annee > 1992
GROUP BY annee
ORDER BY annee;

SELECT ph.id_photo, su.sujet
FROM Photographie ph
JOIN Sujet_Photographie sp ON ph.id_photo = sp.id_photo
JOIN Sujet su ON sp.id_sujet = su.id_sujet
GROUP BY ph.id_photo,su.id_sujet
ORDER BY ph.id_photo;