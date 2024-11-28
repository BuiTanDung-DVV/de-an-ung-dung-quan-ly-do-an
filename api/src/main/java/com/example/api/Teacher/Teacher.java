package com.example.api.Teacher;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Entity
@Table(name = "teachers")
public class Teacher {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(unique = true, length = 255, nullable = false)
    private String email;

    @Column(length = 255, nullable = false)
    private String password;

    // Constructors
    public Teacher() {}

    public Teacher(String email, String password) {
        this.email = email;
        this.password = password;
    }
}