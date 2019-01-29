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

-- Fonctions
create or replace function insert_tout()
returns trigger as $$
declare
    tmp text;
    tmp2 text;
	tmp3 text;
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
	pers_desig
	pers_note
	pers_job

	--metier
	metier_id int;
	metier_desig

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
								date_m := (regexp_split_to_array(date_cache[2],'-'))[1];
								date_m_b := (regexp_split_to_array(date_cache[2],'-'))[2];
							ELSE
								date_m := (date_cache[2]);
							END IF;

							IF cardinality(regexp_split_to_array(date_cache[3],'-')) = 2 THEN
								date_a := to_number(((regexp_split_to_array(date_cache[3],'-'))[1]),'9999');
								date_a_b := to_number(((regexp_split_to_array(date_cache[3],'-'))[2]),'9999');
							ELSE
								date_a := (to_number(date_cache[3],'9999'));
							END IF;
						WHEN cardinality(date_cache) = 2 THEN
							IF cardinality(regexp_split_to_array(date_cache[1],'-')) = 2 THEN
								date_m := (regexp_split_to_array(date_cache[1],'-'))[1];
								date_m_b := (regexp_split_to_array(date_cache[1],'-'))[2];
							ELSE
								date_m := (date_cache[1]);
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
		SELECT REPLACE(NEW.IndexIco,' | ','/ ') INTO tmp;
		tmp = regexp_split_to_array(tmp,'/ ')
		IF tmp IS NOT NULL THEN
			FOR EACH tmp2 IN ARRAY tmp
			LOOP
				pers_Nom := (SELECT SUBSTRING(tmp2,'[A-Z]{1,}.[A-Z|A-Z ]{1,}.(?![, ]).(?![a-z]{1,})'));
				IF pers_Nom IS NULL THEN
					pers_Nom := '';
					pers_job := (SELECT SUBSTRING(tmp2,'\(.*.\)'));
					IF pers_job IS NULL THEN
						pers_job := '';
					END IF;
					pers_Prenom := (SELECT SUBSTRING(TRIM(TRIM(tmp2,pers_Nom),pers_job),'[A-Z]{1}[a-z]{1,}'));
					IF pers_Prenom IS NULL THEN:
						pers_Prenom := '';
					END IF;
					pers_desig := (SELECT SUBSTRING(TRIM(TRIM(TRIM(tmp2,pers_Nom),pers_job),pers_Prenom),'[a-z]{1,}'));
					IF pers_desig IS NULL THEN:
						pers_desig := '';
					END IF;
					pers_note := (SELECT TRIM(SUBSTRING(tmp2,'(voir aussi).+')),'(voir aussi).+');


				END IF;
				IF pers_Nom IS NULL AND pers_Prenom IS NULL AND pers_job IS NULL AND pers_desig IS NULL THEN
					pers_note := tmp2
					INSERT INTO Personne(Notes) VALUES (pers_note) returning id_pers into pers_id;
				ELSE
					INSERT INTO Personne(Nom,Prenom,Representation,Notes) VALUES (pers_Nom,pers_Prenom,pers_desig,pers_note) returning id_pers into pers_id;

					IF pers_job IS NOT NULL THEN
						pers_job = (SELECT TRIM(TRIM(pers_job,'\('),'\)'));
						pers_job = regexp_split_to_array(pers_job,',');
						FOR EACH tmp3 IN ARRAY pers_job
						LOOP
							
						END LOOP


					END IF;





				END IF;
				
			END LOOP
		END IF;
	END IF;
/*
    IF NEW.IndexP IS NOT NULL THEN
		IF regexp_split_to_array(NEW.IndexP,'/ ') IS NOT NULL THEN
			foreach tmp2 in array regexp_split_to_array(NEW.IndexP,'/ ')
			loop
				if tmp2 is not null then
					IF regexp_split_to_array(tmp2,' ') IS NOT NULL THEN
						foreach tmp3 in array regexp_split_to_array(tmp2,' ')
							loop
								IF tmp3 IS NOT NULL THEN
									IF tmp3 ~ '[A-Z]{1,},' THEN
										pers_Nom := (SELECT REPLACE(tmp3,',',''));
									END IF;

									IF tmp3 ~ '[A-Z]{1}[a-z]{1,}' THEN
										pers_Prenom := tmp3;
									END IF;

									IF tmp3 ~ '\([a-z]{1,}\)' OR tmp3 ~ '\({0,1}[a-z]{1,}\)' OR tmp3 ~ '\([a-z]{1,}\){0,1}' THEN
										IF NOT EXISTS(SELECT Designation FROM Metier WHERE Designation=REPLACE(REPLACE(tmp3,'(',''),')','')) THEN
											INSERT INTO Metier(Designation) VALUES (REPLACE(REPLACE(tmp3,'(',''),')','')) returning id_metier into metier_id;
										END IF;
										IF pers_Nom IS NOT NULL THEN
											IF pers_Prenom IS NOT NULL THEN
												IF NOT EXISTS(SELECT * FROM Personne WHERE Nom=pers_Nom AND Prenom=pers_Prenom) THEN
													INSERT INTO Personne(Nom,Prenom) VALUES (pers_Nom,pers_Prenom) returning id_pers into pers_id;
												END IF;
											ELSE
												IF NOT EXISTS(SELECT * FROM Personne WHERE Nom=pers_Nom) THEN
													INSERT INTO Personne(Nom) VALUES (pers_Nom) returning id_pers into pers_id;
												END IF;
											END IF;
										END IF;
										IF pers_id IS NOT NULL AND metier_id IS NOT NULL THEN
											IF NOT EXISTS(SELECT * FROM Personne_Metier WHERE id_pers=pers_id AND id_metier = metier_id) THEN
												INSERT INTO Personne_Metier(id_pers,id_metier) VALUES(pers_id,metier_id);
											END IF;
											pers_id = NULL;
											metier_id = NULL;
										END IF;
									END IF;

									IF tmp3 ~ '' THEN

									END IF;
								END IF;
							END LOOP;
					END IF;
				end if;
			end loop;
		END IF;
	END IF;
*/
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

-- Insertion des données Lambert93 (Site originaire des données : http://www.pillot.fr/cartographe/index.php)
COPY Lambert93 FROM 'C:\Users\Louis LE LANN\Documents\GitHub\teaProjectBD\villes.csv' DELIMITER ',' CSV HEADER ENCODING 'ISO-8859-15';

-- Insertion des données dans la table de transfert et séparation dans les bonnes tables
COPY DataImported FROM 'C:\Users\Louis LE LANN\Documents\GitHub\teaProjectBD\data.csv' DELIMITER '	' CSV HEADER;

