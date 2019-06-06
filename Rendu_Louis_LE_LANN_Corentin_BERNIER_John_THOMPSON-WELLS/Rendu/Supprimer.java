import java.util.ArrayList;
import java.util.Objects;
// cette classe sert a ecrire une requete delete de la meme maniere que Requete
public class Supprimer {
    private String table;//la table dans la quelle on veut supprimer le tuple
    private ArrayList<Criteria>  crits;//critere qui definiront le tuple a supprimer

    public Supprimer(String table, ArrayList<Criteria> crits) {
        this.table = table;
        this.crits = crits;
    }

    public String getTable() {
        return table;
    }

    public void setTable(String table) {
        this.table = table;
    }

    public ArrayList<Criteria> getCrits() {
        return crits;
    }

    public void setCrits(ArrayList<Criteria> crits) {
        this.crits = crits;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Supprimer supprimer = (Supprimer) o;
        return Objects.equals(table, supprimer.table) &&
                Objects.equals(crits, supprimer.crits);
    }

    @Override
    public int hashCode() {
        return Objects.hash(table, crits);
    }

    public String getSqlRequest(){// la fonction importante qui ecrit la requete
        StringBuilder result = new StringBuilder("delete from "+table+" ");
        ArrayList<String> tables = new ArrayList<String>();
        for(Criteria c : crits){//ajoute les tables necessaire dans la clause using
            if(!tables.contains(c.getDonnee().getTable())&&!c.getDonnee().getTable().equals(table)){
                tables.add(c.getDonnee().getTable());
                if(!result.toString().endsWith("delete from "+table+" ")){
                    result.append(", ");
                }else{
                    result.append(" using ");
                }
                result.append(" "+c.getDonnee().getTable());
            }
            if(c.getCompare().isLine()&&!tables.contains(((Line)c.getCompare()).getTable())&&!((Line)c.getCompare()).getTable().equals(table)){
                tables.add(((Line)c.getCompare()).getTable());
                if(!result.toString().endsWith("delete from "+table+" ")){
                    result.append(", ");
                }else{
                    result.append(" using ");
                }
                result.append(" "+((Line)c.getCompare()).getTable());
            }
        }
        if(crits.size()!=0){
            result.append(" where ");
        }
        for(Criteria c : crits){//ajoute les critere dans where  (cf requete)
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
            switch (c.getComparateur()){
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
            if(c.getCompare().isLine()){
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
        return result.toString();
    }
}
