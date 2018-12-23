SET datestyle TO 'european';

-- Suppression des tables existantes dans le bon ordre
-- Tables Liens
DROP TABLE IF EXISTS Photographie_Lieu, Fichier_Photographie, Iconographie_Photographie, Sujet_Photographie, Personne_Photographie, Personne_Metier, Photographie_Date;

-- Tables Basiques
DROP TABLE IF EXISTS Date, Photographie, NegatifOuReversible, Taille, Support, Lambert93, Fichier, Iconographie, Sujet, Personne, Metier;

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
	id_pers VARCHAR(255),
	PRIMARY KEY(id_photo,id_pers),
	FOREIGN KEY (id_pers) REFERENCES Personne(id_pers),
	FOREIGN KEY (id_photo) REFERENCES Photographie(id_photo)
);

CREATE TABLE Personne_Metier(
	id_pers VARCHAR(255),
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

-- Fonctions
CREATE OR REPLACE FUNCTION array_reverse(anyarray) RETURNS anyarray AS $$
SELECT ARRAY(
    SELECT $1[i]
    FROM generate_series(
        array_lower($1,1),
        array_upper($1,1)
    ) AS s(i)
    ORDER BY i DESC
);
$$ LANGUAGE 'sql' STRICT IMMUTABLE;

create or replace function date_split(texte text)
returns table(jour int, mois varchar(255), annee int) as $$
declare
    d text;
    s text;
    flag int;
    a int;
    m text;
    j int;
begin
    foreach d in array regexp_split_to_array(texte, '/')
    loop
        flag :=0;
        foreach s in array array_reverse(regexp_split_to_array(ltrim(d,'Prise de vue : '),' '))
        loop
            case
                when flag = 0 then
                    a := to_number(s,'9999');
                when flag = 1 then
                    m := s;
                when flag = 2 then
                    j := to_number(s,'99'); 
            end case;
            flag := flag+1;
        end loop;
        jour := j;
        mois := m;
        annee := a;
        return next;
    end loop;
end;
$$ language plpgsql;

create or replace function insert_tout()
returns trigger as $$
declare
    tmp text;
    tmp2 text;
    --remarque
    remarque_id int;
    --photographie
    photo_id int;
    --date
    dcurs cursor for select * from date_split(new.Date);
    d record;
    date_id int;
    --support
    t text[];
    neg text[];
    c text[];
    nb text[];
    support_id int;
    --fichier
    fichier_id int;
    --sujet
    sujet_id int;
    --personne
    
    --lambert
    lamb_id int;
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
    insert into Photographie(cindoc,serie,article,discriminant,description,notes,id_remarque) values (new.Cindoc,new.Serie,new.Article/*to_number(new.Article,'999999')*/,new.Disc,new.Descr,new.NoteBasPage,remarque_id) returning id_photo into photo_id;
    --date
    open dcurs;
    loop
        fetch dcurs into d;
        if not found then exit;
        end if;
        insert into Date(jour, mois, annee) values (d.jour, d.mois, d.annee) returning id_date into date_id;
        insert into Photographie_Date values (photo_id, date_id);
    end loop;
    close dcurs;
    --taille
    t := regexp_split_to_array(new.TailleC,', ');
    foreach tmp in array t
    loop
        if tmp is not null and not exists (select * from Taille
        	where taille = tmp) then
        		insert into Taille(taille) values (tmp);
        	end if;
    end loop;
    --negatif reversible
    neg := regexp_split_to_array(new.NegatReve,', ');
    foreach tmp in array neg
    loop
        if tmp is not null and not exists (select * from NegatifOuReversible
        	where nr = tmp) then
        		insert into NegatifOuReversible(nr) values (tmp);
        	end if;
    end loop;
    --support
    nb := regexp_split_to_array(new.NbCliche,', ');
    c := regexp_split_to_array(new.Couleur,', ');
    for i in 1..array_length(nb,1)
    loop
        insert into Support(id_photo,nbcliche,taille,nr,NoirBlancOrColor) values (photo_id,to_number(nb[i],'9'),t[i],neg[i],c[i]) returning id_support into support_id;
        --insert into Support_Photographie values (photo_id,support_id);
    end loop;
    --fichier
    foreach tmp in array regexp_split_to_array(new.FichierN,' | ')
    loop
        foreach tmp2 in array regexp_split_to_array(tmp,'/')
        loop
            if tmp2 is not null then
            	if not exists (select * from Fichier where NomFichier=new.FichierN) then
            		insert into Fichier(NomFichier) values (tmp2) returning id_fichier into fichier_id;
           		else
            		fichier_id := (select id_fichier from Fichier where NomFichier=new.FichierN);
            	end if;
            	insert into Fichier_Photographie values(photo_id,fichier_id);
            end if;
        end loop;
    end loop;
    --iconographie
    foreach tmp in array regexp_split_to_array(new.IndexIco,'/ ')
    loop
        if tmp is not null then
        	if not exists (select * from Iconographie where New.IndexIco=tmp) then
        		insert into Iconographie values (tmp);
        	end if;
        	insert into Iconographie_Photographie values(photo_id,New.IndexIco);
        end if;
    end loop;
    --sujet
    if new.Sujet is not null then
    	if not exists (select * from Sujet where sujet=tmp) then
    		insert into Sujet(sujet) values (tmp) returning id_sujet into sujet_id;
    	else
    		sujet_id := (select id_sujet from Sujet where sujet=tmp);
    	end if;
    	insert into Sujet_Photographie values(photo_id,sujet_id);
    end if;
    --personne
    
    --lambert
    IF NEW.Ville IS NOT NULL THEN
		IF NOT EXISTS (SELECT nom FROM Lambert93 WHERE nom=NEW.Ville) THEN
			INSERT INTO Lambert93(ref_lieux,codeInsee,codePostal,nom,CoordX,CoordY) VALUES ((SELECT MAX(ref_lieux)+1 FROM Lambert93),-1,0,NEW.Ville,0,0) returning ref_lieux INTO lamb_id;
		ELSE
			lamb_id := (SELECT ref_lieux FROM Lambert93 WHERE nom=NEW.Ville);
		END IF;
		INSERT INTO Photographie_Lieu VALUES(photo_id,lamb_id);
	END IF;
    return new;
end;
$$ language plpgsql;

create trigger insert_data
after insert on DataImported
for each row
execute procedure insert_tout();

-- Insertion des données Lambert93 (Site originaire des données : http://www.pillot.fr/cartographe/index.php)
COPY Lambert93 FROM 'C:\Users\Louis LE LANN\Documents\GitHub\teaProjectBD\villes.csv' DELIMITER ',' CSV HEADER ENCODING 'ISO-8859-15';

-- Insertion des données dans la table de transfert et séparation dans les bonnes tables
COPY DataImported FROM 'C:\Users\Louis LE LANN\Documents\GitHub\teaProjectBD\data.csv' DELIMITER '	' CSV HEADER;

