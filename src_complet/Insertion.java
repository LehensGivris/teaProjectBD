import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class Insertion {
    private String table;//table cible de l'insertion
    private HashMap<String,String> values;//colonne et valeur a inserer

    public Insertion(String table, HashMap<String, String> values) {
        this.table = table;
        this.values = values;
    }

    public String getTable() {
        return table;
    }

    public void setTable(String table) {
        this.table = table;
    }

    public HashMap<String, String> getValues() {
        return values;
    }

    public void setValues(HashMap<String, String> values) {
        this.values = values;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Insertion insertion = (Insertion) o;
        return Objects.equals(table, insertion.table) &&
                Objects.equals(values, insertion.values);
    }

    @Override
    public int hashCode() {
        return Objects.hash(table, values);
    }

    public String getSqlRequest(){//fonction importante
        StringBuilder result = new StringBuilder("insert into ");
        if(table.equals("tous")){//juste au cas ou on oulie de changer l'étiquette tous en DataImported
            result.append("DataImported (");
        }else{
            result.append(table+" (");
        }
        for(String k : values.keySet()){
            if(!values.get(k).equals("")&&values.get(k)!=null){
                if(!result.toString().endsWith(" (")){
                    result.append(", ");
                }
                result.append(k);
            }
        }
        result.append(") values (");
        for(String v : values.values()){
            if(!v.equals("")&&v!=null){
                if(!result.toString().endsWith(" (")){
                    result.append(", ");
                }
                result.append("'"+v+"'");
            }
        }
        result.append(")");
        return result.toString();
    }
}
