import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/*
Cette classe sert a créer a partire des informations fourni par l'utilisateur a travers l'interface graphique une requete sql select en type String
*/

public class Requete {
	private ArrayList<Line> resultats; //ici sont toutes les informations qui seronts afficher par la requete
	private ArrayList<Criteria> criteres;//ici sont toutes les conditions qui decide de quelles tuples selectionner
	private int limit;//la limite de ligne
	private HashMap<Line,Boolean> order;//l'ordre de selection(boolean true pour ascendant et false pour descendant)

	public Requete(ArrayList<Line> resultats, ArrayList<Criteria> criteres, int limit, HashMap<Line,Boolean> order) {
		this.resultats = resultats;
		this.criteres = criteres;
		this.limit = limit;
		this.order = order;
	}

	public ArrayList<Line> getResultats() {
		return resultats;
	}
	public void setResultats(ArrayList<Line> resultats) {
		this.resultats = resultats;
	}
	public ArrayList<Criteria> getCriteres() {
		return criteres;
	}
	public void setCriteres(ArrayList<Criteria> criteres) {
		this.criteres = criteres;
	}
	public int getLimit() {
		return limit;
	}
	public void setLimit(int limit) {
		this.limit = limit;
	}
	public HashMap<Line, Boolean> getOrder() {return order;}
	public void setOrder(HashMap<Line, Boolean> order) {this.order = order;}
	
	public String getSqlRequest(){
		/*
		La seule fonction importante qui retourne un string du select
		j'utilise un stringbuilder (parceque c'est plus facile) donc je fais tout l'un après l'autre
		une fonction plus efficace est possible mais je trouve ca plus lisible si caque étapes est dans l'ordre
		*/
		StringBuilder result = new StringBuilder("select ");
		ArrayList<String> tables = new ArrayList<String>();
		/*
		cette première boucle sert a d'abords a initialiser la list tables qui contiendra toute les
		tables necessaire dans le from et pour les joins
		et deuxiemement elle sert a ajouter les informations necessaire a l'affichage des info necessaire au debut
		de la requete
		*/
		for(Line l : resultats){
			if(!tables.contains(l.getTable())){
				tables.add(l.getTable());
				if(l.getTable().equals("Lambert93")){
					tables.add("Photograhie_Lieu");
				}else if(l.getTable().equals("Date")){
					tables.add("Photograhie_Date");
				}else if(l.getTable().equals("Metier")){
					tables.add("Personne_Metier");
					if(!tables.contains("Personne")){
						tables.add("Personne");
						tables.add("Personne_Photographie");
					}
				}else{
					tables.add(l.getTable()+"_Photograhie");
				}
			}
			if(!result.toString().endsWith("select ")){
				result.append(", ");
			}
			switch(l.getFormat()){//sert a implementer le format d'une information
				case 1:
					result.append("count("+l.getTable()+"."+l.getColumn()+")");
					break;
				case 2:
					result.append("avg("+l.getTable()+"."+l.getColumn()+")");
					break;
				case 3:
					result.append("max("+l.getTable()+"."+l.getColumn()+")");
					break;
				case 4:
					result.append("min("+l.getTable()+"."+l.getColumn()+")");
					break;
				case 5:
					result.append("upper("+l.getTable()+"."+l.getColumn()+")");
					break;
				case 6:
					result.append("lower("+l.getTable()+"."+l.getColumn()+")");
					break;
				case 7:
					result.append("every("+l.getTable()+"."+l.getColumn()+")");
					break;
				case 8:
					result.append("sum("+l.getTable()+"."+l.getColumn()+")");
					break;
				default:
					result.append(l.getTable()+"."+l.getColumn());
			}
		}
		for(Criteria l : criteres){//ajoute les dernières tables qui n'était pas deja inclus dans les resultats
			if(!tables.contains(l.getDonnee().getTable())){
				tables.add(l.getDonnee().getTable());
				if(l.getDonnee().getTable().equals("Lambert93")){
					tables.add("Photograhie_Lieu");
				}else if(l.getDonnee().getTable().equals("Date")){
					tables.add("Photograhie_Date");
				}else if(l.getDonnee().getTable().equals("Metier")){
					tables.add("Personne_Metier");
					if(!tables.contains("Personne")){
						tables.add("Personne");
						tables.add("Personne_Photographie");
					}
				}else{
					tables.add(l.getDonnee().getTable()+"_Photograhie");
				}
			}
			if(l.getCompare().isLine()&&!tables.contains(((Line)l.getCompare()).getTable())){
				tables.add(((Line)l.getCompare()).getTable());
				if(l.getDonnee().getTable().equals("Lambert93")){
					tables.add("Photograhie_Lieu");
				}else if(((Line)l.getCompare()).getTable().equals("Date")){
					tables.add("Photograhie_Date");
				}else if(((Line)l.getCompare()).getTable().equals("Metier")){
					tables.add("Personne_Metier");
					if(!tables.contains("Personne")){
						tables.add("Personne");
						tables.add("Personne_Photographie");
					}
				}else{
					tables.add(((Line)l.getCompare()).getTable()+"_Photograhie");
				}
			}
		}
		if(!tables.contains("Photographie")&&(tables.contains("Support")||tables.contains("Cindoc")||tables.contains("Remarque")||tables.contains("Discriminant")||tables.contains("Iconographie")||tables.contains("Sujet")||tables.contains("Fichier")||tables.contains("Lambert93")||tables.contains("Date"))){
			tables.add("Photographie");
		}//ajoute la table photographie dans le cas ou il y a besoin
		result.append(" from ");
		for(String t : tables){//ajout des tables dans la clause from
			if(t!=tables.get(0)){
				result.append(", ");
			}
			result.append(t);
		}
		result.append(" where ");// c'est un peu long mais cette partie fais office de join entre les tables et ensuite les criteres ajouter
		if(tables.contains("Support")){
			result.append(" Support.id_photo=Photographie.id_photo ");
		}
		if(tables.contains("Remarque")){
			if(!result.toString().endsWith(" where ")){
				result.append(" and ");
			}
			result.append(" Remarque.id_remarque=Photographie.id_remarque ");
		}
		if(tables.contains("Cindoc")){
			if(!result.toString().endsWith(" where ")){
				result.append(" and ");
			}
			result.append(" Cindoc_Photographie.id_photo=Photographie.id_photo ");
		}
		if(tables.contains("Iconographique")){
			if(!result.toString().endsWith(" where ")){
				result.append(" and ");
			}
			result.append(" Iconographique_Photographie.id_photo=Photographie.id_photo ");
		}
		if(tables.contains("Sujet")){
			if(!result.toString().endsWith(" where ")){
				result.append(" and ");
			}
			result.append(" Sujet_Photographie.id_photo=Photographie.id_photo and Sujet_Photographie.id_sujet=Sujet.id_sujet ");
		}
		if(tables.contains("Personne")){
			if(!result.toString().endsWith(" where ")){
				result.append(" and ");
			}
			result.append(" Personne_Photographie.id_photo=Photographie.id_photo and Personne_Photographie.id_pers=Personne.id_pers");
		}
		if(tables.contains("Metier")){
			if(!result.toString().endsWith(" where ")){
				result.append(" and ");
			}
			result.append(" Metier.id_metier=Personne_Metier.id_metier and Personne_Metier.id_pers=Personne.id_pers ");
		}
		if(tables.contains("Fichier")){
			if(!result.toString().endsWith(" where ")){
				result.append(" and ");
			}
			result.append(" Fichier_Photographie.id_photo=Photographie.id_photo and Fichier_Photographie.");
		}
		if(tables.contains("Lambert93")){
			if(!result.toString().endsWith(" where ")){
				result.append(" and ");
			}
			result.append(" Photographie_Lieu.id_photo=Photographie.id_photo and Photographie_Lieu.id_lambert=Lambert93.ref_lieu");
		}
		if(tables.contains("Date")){
			if(!result.toString().endsWith(" where ")){
				result.append(" and ");
			}
			result.append(" Photographie_Date.id_photo=Photographie.id_photo and Photographie_Date.id_date=Date.id_date");
		}
		for(Criteria c : criteres){//ajout des conditions pour la selections des tuples
			if(!result.toString().endsWith(" where ")){
				result.append(" and ");
			}
			switch(c.getDonnee().getFormat()){
				case 1:
					result.append("count("+c.getDonnee().getTable()+"."+c.getDonnee().getColumn()+")");
					break;
				case 2:
					result.append("avg("+c.getDonnee().getTable()+"."+c.getDonnee().getColumn()+")");
					break;
				case 3:
					result.append("max("+c.getDonnee().getTable()+"."+c.getDonnee().getColumn()+")");
					break;
				case 4:
					result.append("min("+c.getDonnee().getTable()+"."+c.getDonnee().getColumn()+")");
					break;
				case 5:
					result.append("upper("+c.getDonnee().getTable()+"."+c.getDonnee().getColumn()+")");
					break;
				case 6:
					result.append("lower("+c.getDonnee().getTable()+"."+c.getDonnee().getColumn()+")");
					break;
				case 7:
					result.append("every("+c.getDonnee().getTable()+"."+c.getDonnee().getColumn()+")");
					break;
				case 8:
					result.append("sum("+c.getDonnee().getTable()+"."+c.getDonnee().getColumn()+")");
					break;
				default:
					result.append(c.getDonnee().getTable()+"."+c.getDonnee().getColumn());
			}
			switch (c.getComparateur()){//selection de l'operations de comparaisons
				case 1: result.append("<");
					break;
				case 2: result.append(">");
					break;
				case 3: result.append("<=");
					break;
				case 4: result.append(">=");
					break;
				case 5: result.append("<>");
					break;
				case 6: result.append(" like ");
					break;
				case 7: result.append(" not like ");
					break;
				default: result.append("=");
			}
			if(c.getCompare().isLine()){//ici a la deuxieme partie de la condition il y a le chois entre une autre informations dans la base (avec une Line) ou une expression comme un nombre ou un string(Expression)
				switch(((Line)c.getCompare()).getFormat()){
					case 1:
						result.append("count("+((Line)c.getCompare()).getTable()+"."+((Line)c.getCompare()).getColumn()+")");
						break;
					case 2:
						result.append("avg("+((Line)c.getCompare()).getTable()+"."+((Line)c.getCompare()).getColumn()+")");
						break;
					case 3:
						result.append("max("+((Line)c.getCompare()).getTable()+"."+((Line)c.getCompare()).getColumn()+")");
						break;
					case 4:
						result.append("min("+((Line)c.getCompare()).getTable()+"."+((Line)c.getCompare()).getColumn()+")");
						break;
					case 5:
						result.append("upper("+((Line)c.getCompare()).getTable()+"."+((Line)c.getCompare()).getColumn()+")");
						break;
					case 6:
						result.append("lower("+((Line)c.getCompare()).getTable()+"."+((Line)c.getCompare()).getColumn()+")");
						break;
					case 7:
						result.append("every("+((Line)c.getCompare()).getTable()+"."+((Line)c.getCompare()).getColumn()+")");
						break;
					case 8:
						result.append("sum("+((Line)c.getCompare()).getTable()+"."+((Line)c.getCompare()).getColumn()+")");
						break;
					default:
						result.append(((Line)c.getCompare()).getTable()+"."+((Line)c.getCompare()).getColumn());
				}
			}else{
				result.append(" "+((Expression)c.getCompare()).getExp()+" ");
			}
		}
		if(limit>0){//pour la suite les commentaire des variables explique
			result.append(" limit "+limit+" ");
		}
		if(order.size()!=0){
			result.append(" order by ");
		}
		for (Map.Entry<Line,Boolean> e : order.entrySet()){
			if(!result.toString().endsWith(" order by ")){
				result.append(", ");
			}
			result.append(" "+e.getKey().getTable()+"."+e.getKey().getColumn()+" ");
			if(e.getValue()){
				result.append(" asc ");
			}else{
				result.append(" desc ");
			}
		}
		result.append(";");
		return result.toString();
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((criteres == null) ? 0 : criteres.hashCode());
		result = prime * result + limit;
		result = prime * result + ((resultats == null) ? 0 : resultats.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Requete other = (Requete) obj;
		if (criteres == null) {
			if (other.criteres != null)
				return false;
		} else if (!criteres.equals(other.criteres))
			return false;
		if (limit != other.limit)
			return false;
		if (resultats == null) {
			if (other.resultats != null)
				return false;
		} else if (!resultats.equals(other.resultats))
			return false;
		return true;
	}
}
