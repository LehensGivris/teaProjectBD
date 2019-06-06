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