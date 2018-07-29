package org.davromalc.tutorial.model;

import org.springframework.data.annotation.Id;

import lombok.Data;


@Data
public class Customer {

    @Id
    public String id;

    public String firstName;
    public String lastName;
    public String title;
    public String location;
    public String country;
    public String phonenumber;
    public String middleName;

}
