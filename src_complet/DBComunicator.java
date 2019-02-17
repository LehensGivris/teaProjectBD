
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Properties;

public class DBComunicator {

    Connection connection;

    public ArrayList<String> litables;
    public HashMap<String, String[]> base;//pour mettre les tables en premier element puis la liste en deuxieme contient toutes les colonnes

    public DBComunicator() throws Exception {
        Properties props = new Properties();
        connection = null;
        
        try {
            FileInputStream fis = new FileInputStream("src/db.properties");
            props.load(fis);
            connection = DriverManager.getConnection("jdbc:postgresql://"+props.getProperty("db.url")+"/"+props.getProperty("db.name"), props.getProperty("db.user"), props.getProperty("db.password"));
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        base = new HashMap<>();
        litables = new ArrayList();
        
        DatabaseMetaData metaData = connection.getMetaData();//tout a partir de la dans le constructeur sert a initialiser base
        Statement statement = connection.createStatement();
        ResultSet tables = metaData.getTables(null, "public", "%", new String[]{"TABLE"});
        while (tables.next()) {
            String tmpTable = tables.getString("TABLE_NAME");
            litables.add(new String(tmpTable));
            ResultSetMetaData tmpMeta = statement.executeQuery("select * from " + tmpTable + ";").getMetaData();
            String[] tmpColumns = new String[tmpMeta.getColumnCount()];
            for (int i = 0; i < tmpMeta.getColumnCount(); i++) {
                tmpColumns[i] = tmpMeta.getColumnName(i+1);
            }
            base.put(tmpTable, tmpColumns);
        }
        tables.close();
        statement.close();
    }

    public ArrayList<String[]> sendRequest(Requete r) throws Exception {
        ArrayList<String[]> result = new ArrayList<String[]>();
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(r.getSqlRequest());
        while (resultSet.next()) {
            for (int i = 0; i < r.getResultats().size(); i++) {
                String[] s = new String[r.getResultats().size()];
                s[i] = resultSet.getNString(i);
            }
        }
        resultSet.close();
        statement.close();
        return result;
    }
}
