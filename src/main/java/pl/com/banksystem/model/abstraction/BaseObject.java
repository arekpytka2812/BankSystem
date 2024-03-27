package pl.com.banksystem.model.abstraction;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.lang.reflect.Field;
import java.sql.Timestamp;

@RequiredArgsConstructor
@Getter
@Setter
@ToString
public abstract class BaseObject {

    @Column(name = "id")
    private Long ID;

    @Column(name = "insert_date")
    private Timestamp insertDate;

    @Column(name = "update_date")
    private Timestamp updateDate;

    @Column(name = "insert_user")
    private Long insertUser;

    @Column(name = "update_user")
    private Long updateUser;

    @Column(name = "business_id")
    private Long businessID;

    public void save() throws IllegalAccessException {

        Field[] fields = this.getClass().getDeclaredFields();
        String[] splitedTableName = getSplitedTableName();

        if(splitedTableName == null){
            throw new RuntimeException("No @Table annotation!");
        }

        String functionName =  splitedTableName[0] + "_add" + splitedTableName[1];

        StringBuilder query = new StringBuilder("select * from " + functionName + "(");

        for (Field field : fields){

            if(!isFieldSaveable(field)){
                continue;
            }

            Object value = field.get(this);
            query.append(value).append(",");
        }

        query.append(");");

        // execute query
    }

    private boolean isFieldSaveable(Field field){
        return field.getAnnotation(Column.class).name().equals("id")
                || field.getAnnotation(Column.class).name().equals("insert_date")
                || field.getAnnotation(Column.class).name().equals("update_date")
                || field.getAnnotation(Column.class).name().equals("business_date");
    }

    public void update() throws IllegalAccessException {

        Field[] fields = this.getClass().getDeclaredFields();
        String[] splitedTableName = getSplitedTableName();

        if(splitedTableName == null){
            throw new RuntimeException("No @Table annotation!");
        }

        String functionName =  splitedTableName[0] + "_update" + splitedTableName[1];

        StringBuilder query = new StringBuilder("select * from " + functionName + "(");

        for (Field field : fields){

            Object value = field.get(this);
            query.append(value).append(",");
        }
    }

    public void load(){

    }

    public void delete() throws NoSuchFieldException, IllegalAccessException {

        Field idField = this.getClass().getDeclaredField("ID");
        String[] splitedTableName = getSplitedTableName();

        if(splitedTableName == null){
            throw new RuntimeException("No @Table annotation!");
        }

        String functionName =  splitedTableName[0] + "_delete" + splitedTableName[1];

        if(!idField.isAnnotationPresent(Column.class)){
            throw new RuntimeException("No @column annotation!");
        }

        Long value = (Long) idField.get(this);

        String query = "select * from " + functionName + "(" + value + ");";

    }

    private String[] getSplitedTableName(){

        if(!this.getClass().isAnnotationPresent(Table.class)){
            return null;
        }

        String tableName = this.getClass().getAnnotation(Table.class).name();
        String[] result = new String[2];

        result[0] = tableName.substring(0, 3);
        result[1] = tableName.substring(3);

        return result;
    }
}
