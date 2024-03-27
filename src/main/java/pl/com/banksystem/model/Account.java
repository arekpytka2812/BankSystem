package pl.com.banksystem.model;

import lombok.*;
import pl.com.banksystem.model.abstraction.BaseObject;
import pl.com.banksystem.model.abstraction.Column;
import pl.com.banksystem.model.abstraction.Table;

import java.math.BigDecimal;

@Table(name = "account")
@ToString
@RequiredArgsConstructor
@Getter
@Setter
public class Account extends BaseObject {

    private User user;

    @Column(name = "money")
    private BigDecimal money;
}
