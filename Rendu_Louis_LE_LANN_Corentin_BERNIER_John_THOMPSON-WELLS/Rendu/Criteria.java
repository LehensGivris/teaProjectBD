
public class Criteria {
	private Line donnee;//première partie du comparateur donc une refference a une information de la base
	private int comparateur;// operations de comparaisons (flag sous format int)
	private Crit compare;//deuxieme partie qui peut soit etre une info de la base ou une expression comme un nombre ou un string
	
	public Criteria(Line donnee, int comparateur, Crit compare) {
		this.donnee = donnee;
		this.comparateur = comparateur;
		this.compare = compare;
	}

	public Line getDonnee() {
		return donnee;
	}

	public void setDonnee(Line donnee) {
		this.donnee = donnee;
	}

	public int getComparateur() {
		return comparateur;
	}

	public void setComparateur(int comparateur) {
		this.comparateur = comparateur;
	}

	public Crit getCompare() {
		return compare;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + comparateur;
		result = prime * result + ((compare == null) ? 0 : compare.hashCode());
		result = prime * result + ((donnee == null) ? 0 : donnee.hashCode());
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
		Criteria other = (Criteria) obj;
		if (comparateur != other.comparateur)
			return false;
		if (compare == null) {
			if (other.compare != null)
				return false;
		} else if (!compare.equals(other.compare))
			return false;
		if (donnee == null) {
			if (other.donnee != null)
				return false;
		} else if (!donnee.equals(other.donnee))
			return false;
		return true;
	}

	public void setCompare(Crit compare) {
		this.compare = compare;
	}
}
