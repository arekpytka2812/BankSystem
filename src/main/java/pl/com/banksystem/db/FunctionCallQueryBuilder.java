package pl.com.banksystem.db;
public class FunctionCallQueryBuilder {

    public static String createFunctionCallQuery(String functionName, Object... parameters){

        StringBuilder queryBuilder = new StringBuilder();

        queryBuilder.append("select ")
                .append(functionName)
                .append("(");

        for(int i = 0; i < parameters.length; i++){

            if(i == parameters.length - 1){
                queryBuilder.append(ToolObject.maskToDB(parameters[i]));
                continue;
            }

            queryBuilder.append(ToolObject.maskToDB(parameters[i])).append(", ");

        }

        queryBuilder.append(");");

        return queryBuilder.toString();
    }

}
