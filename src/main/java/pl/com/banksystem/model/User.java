package pl.com.banksystem.model;

import lombok.*;
import pl.com.banksystem.model.abstraction.BaseObject;
import pl.com.banksystem.model.abstraction.Column;
import pl.com.banksystem.model.abstraction.Table;

@Table(name = "cr_user")
@RequiredArgsConstructor
@Getter
@Setter
@ToString(callSuper = true)
public class User extends BaseObject {

    @Column(name = "login")
    private String login;

    @Column(name = "password")
    private String password;
}
