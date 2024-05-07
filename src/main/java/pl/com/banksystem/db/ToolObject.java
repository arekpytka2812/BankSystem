package pl.com.banksystem.db;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

/**
 * Class that masks Java objects into SQL representations.
 * If data type might need casting, adds necessary cast
 */
public class ToolObject {

    public static Object maskToDB(Object object){

        if(object instanceof String){
            return "'" + object + "'";
        }

        if(object instanceof Date){
            String pattern = "yyyy-MM-dd";
            SimpleDateFormat format = new SimpleDateFormat(pattern);

            return "'" + format.format(object) + "'::date";
        }

        if(object instanceof LocalDateTime){
            String pattern = "yyyy-MM-dd hh:mm:ss";
            DateTimeFormatter format = DateTimeFormatter.ofPattern(pattern);

            return "'" + ((LocalDateTime) object).format(format) + "'::timestamp";
        }

        return object;
    }
}
