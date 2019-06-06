import java.util.ArrayList;
import java.util.HashMap;

public class Test {
    /*public static void main(String[] args){
        ArrayList<Line> lines = new ArrayList<Line>();
        lines.add(new Line("Iconographique","index_Icono",0));
        lines.add(new Line("Support","taille",0));
        lines.add(new Line("Metier","designation",2));
        lines.add(new Line("Fichier","NomFichier",1));
        lines.add(new Line("Lambert93","CoordX",0));
        lines.add(new Line("Date","annee",0));
        ArrayList<Criteria> crits = new ArrayList<Criteria>();
        crits.add(new Criteria(new Line("Iconographique","index_Icono",0),0,new Line("Support","taille",0)));
        crits.add(new Criteria(new Line("Lambert93","CoordX",0),1,new Expression("0")));
        crits.add(new Criteria(new Line("Date","annee",0),0,new Expression("1998")));
        crits.add(new Criteria(new Line("Iconographique","index_Icono",0),7,new Expression("'test'")));
        HashMap<Line,Boolean> order = new HashMap<Line,Boolean>();
        order.put(new Line("Support","taille",0),Boolean.TRUE);
        Requete requete = new Requete(lines,crits,3,order);
        System.out.println(requete.getSqlRequest());
    }*/
}
