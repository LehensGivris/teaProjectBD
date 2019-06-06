import java.util.*;
import java.util.Map.Entry;

public class Modification {// cree une requete update
    private String table;//table cile du changement
    private ArrayList<Criteria> crits;//critere de selection du tuple
    private HashMap<String,String> changes;//changement necessaire avec premiere case etant le nom de la colonne et la deuxieme etant la nouvelle valeur
    //si la valeur est un string il faut la mettre en guillemets

    public Modification(String table, ArrayList<Criteria> crits, HashMap<String, String> changes) {
        this.table = table;
        this.crits = crits;
        this.changes = changes;
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

    public HashMap<String, String> getChanges() {
        return changes;
    }

    public void setChanges(HashMap<String, String> changes) {
        this.changes = changes;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Modification that = (Modification) o;
        return Objects.equals(table, that.table) &&
                Objects.equals(crits, that.crits) &&
                Objects.equals(changes, that.changes);
    }

    @Override
    public int hashCode() {
        return Objects.hash(table, crits, changes);
    }

    public String getSqlRequest(){//fonction importante
        StringBuilder result = new StringBuilder("update "+table+" ");//ajout de la table cible
        ArrayList<String> tables = new ArrayList<String>();
        result.append(" set (");//ajout des changement d'abord colonne
        for(Entry<String,String> change : changes.entrySet()){
            if(!result.toString().endsWith("(")){
                result.append(", ");
            }
            result.append(change.getKey());
        }
        result.append(") = (");//ensuite des valeurs
        for(Entry<String,String> change : changes.entrySet()){
            if(!result.toString().endsWith("(")){
                result.append(", ");
            }
            result.append(change.getValue());
        }
        result.append(") ");
        if(crits.size()!=0){
            result.append(" from ");
        }
        for(Criteria c : crits){//ajout des critères (cf Requete)
            if(!tables.contains(c.getDonnee().getTable())&&!c.getDonnee().getTable().equals(table)){
                tables.add(c.getDonnee().getTable());
                if(!result.toString().endsWith(" from ")){
                    result.append(", ");
                }
                result.append(" "+c.getDonnee().getTable());
            }
            if(c.getCompare().isLine()&&!tables.contains(((Line)c.getCompare()).getTable())&&!((Line)c.getCompare()).getTable().equals(table)){
                tables.add(((Line)c.getCompare()).getTable());
                if(!result.toString().endsWith(" from ")){
                    result.append(", ");
                }else{
                    result.append(" from ");
                }
                result.append(" "+((Line)c.getCompare()).getTable());
            }
        }
        if(crits.size()!=0){
            result.append(" where ");
        }
        for(Criteria c : crits){
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
