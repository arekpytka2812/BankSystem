package pl.com.banksystem.frontend.utils;

import javafx.scene.Node;
import javafx.scene.layout.StackPane;
import pl.com.banksystem.frontend.ICenterPane;

import java.util.Stack;

public class PageNavigator {

    private StackPane root;

    private final Stack<ICenterPane> pagesStack;

    private static PageNavigator instance = null;

    private PageNavigator(){
        this.pagesStack = new Stack<>();
    }

    public static PageNavigator getInstance(){

        if(instance == null){
            instance = new PageNavigator();
        }

        return instance;
    }

    public void setRoot(StackPane root){

        if(this.root != null){
            return;
        }

        this.root = root;
    }

    public ICenterPane top(){
        return this.pagesStack.peek();
    }

    public void push(ICenterPane pane){
        this.pagesStack.push(pane);
    }

    public void pop(){

        this.pagesStack.pop();

        if(this.pagesStack.size() == 0){
            return;
        }

        this.reload();

        this.pagesStack.peek().refresh();
    }

    private void reload(){

        this.root.getChildren().clear();
        this.root.getChildren().add((Node) this.pagesStack.peek());
    }
}
