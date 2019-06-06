Pour l'importation des données:
	Ne pouvant pas mettre de chemin relatif, il vous faudra placer les fichiers "data.csv" et "villes.csv" dans un répertoire spécifique
	et changer le chemin d'accès dans le fichier donnees.sql dans les 2 lignes COPY, en bas du fichier, avec ce nouveau chemin.
	Il faut que les droits de lectures soit données à "tout le monde" sur ces 2 fichiers pour que PostgresSQL puisse les lire et importer les données qui sont dedans.
	Exemple:
		C:\Users\Louis LE LANN\Documents\GitHub\teaProjectBD\villes.csv
		C:\Users\Louis LE LANN\Documents\GitHub\teaProjectBD\data.csv
		devient
		C:\tmp\villes.csv
		C:\tmp\data.csv
