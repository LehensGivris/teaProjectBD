import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class DBComunicator {
    Connection connection;
    public HashMap<String,String[]> base;//pour mettre les tables en premier element puis la liste en deuxieme contient toutes les colonnes
    public DBComunicator() throws Exception{
        connection = DriverManager.getConnection( "jdbc:postgresql://localhost/postgres" , "postgres" , "pgAdmin" );
        DatabaseMetaData metaData = connection.getMetaData();//tout a partir de la dans le constructeur sert a initialiser base
        Statement statement = connection.createStatement();
        ResultSet tables = metaData.getTables(null,null,"%",null);
        while(tables.next()){
            String tmpTable = tables.getString("TABLE_NAME");
            ResultSetMetaData tmpMeta = statement.executeQuery("select * from "+tmpTable+";").getMetaData();
            String[] tmpColumns = new String[tmpMeta.getColumnCount()];
            for(int i=0; i<tmpMeta.getColumnCount();i++){
                tmpColumns[i] = tmpMeta.getColumnName(i);
            }
            base.put(tmpTable,tmpColumns);
        }
        tables.close();
        statement.close();
    }
    public ArrayList<String[]> sendRequest(Requete r)throws Exception{
        ArrayList<String[]> result = new ArrayList<String[]>();
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(r.getSqlRequest());
        while(resultSet.next()){
            for(int i=0;i<r.getResultats().size();i++){
                String[] s = new String[r.getResultats().size()];
                s[i]=resultSet.getNString(i);
            }
        }
        resultSet.close();
        statement.close();
        return result;
    }
}
