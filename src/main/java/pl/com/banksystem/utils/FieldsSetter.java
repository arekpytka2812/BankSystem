package pl.com.banksystem.utils;

import pl.com.banksystem.model.abstraction.BaseObject;
import pl.com.banksystem.model.abstraction.Column;
import pl.com.banksystem.model.abstraction.Table;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class FieldsSetter {
    public static <T extends BaseObject> void setFieldsFromDB(T object, ResultSet resultSet) throws NoSuchMethodException, InvocationTargetException, InstantiationException, IllegalAccessException, SQLException {

        List<Field> fields = new ArrayList<>(Arrays.stream(object.getClass().getDeclaredFields()).toList());
        Class<? extends BaseObject> clazz = object.getClass();

        //
        while(clazz.getSuperclass() != null){
            fields.addAll(Arrays.stream(clazz.getSuperclass().getDeclaredFields()).toList());
            clazz = (Class<? extends BaseObject>) clazz.getSuperclass();
        }

        for(Field field : fields){

            // model has to have @Column
//            if(!field.isAnnotationPresent(Column.class)){
//                continue;
//            }

            field.setAccessible(true);

            // solves @Table object in another @Table object
            if(BaseObject.class.isAssignableFrom(field.getType())){
                BaseObject subObject = (BaseObject) field.getType().getConstructor().newInstance();
                setFieldsFromDB(subObject, resultSet);

                field.set(object, subObject);
                continue;
            }

            String columnName = field.getAnnotation(Column.class).name();

            try{
                resultSet.findColumn(columnName);
            }
            catch (SQLException e){
                continue;
            }

            Object value =  resultSet.getObject(columnName);
            field.set(object, value);
        }

    }
}
