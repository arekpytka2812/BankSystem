package pl.com.banksystem.utils;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.util.Properties;

public class PropertyInjector {

    public static void inject(Object object) throws IOException, IllegalAccessException {

        Class<?> clazz = object.getClass();

        String propertiesFilePath = "src/main/resources/properties/";

        if(clazz.isAnnotationPresent(PropertySource.class)){
            propertiesFilePath += clazz.getAnnotation(PropertySource.class).filename();
        }
        else{
            propertiesFilePath += "application.properties";
        }

        InputStream inputStream = PropertyInjector.class.getClassLoader()
                .getResourceAsStream(propertiesFilePath);

        Properties properties = new Properties();
        properties.load(inputStream);

        Field[] fields = clazz.getDeclaredFields();

        for(Field field : fields){

            if(!field.isAnnotationPresent(Property.class)){
                continue;
            }

            field.setAccessible(true);

            String propertyName = field.getAnnotation(Property.class).name();
            String propertyValue = properties.getProperty(propertyName);

            field.set(object, propertyValue);

        }

    }
}
