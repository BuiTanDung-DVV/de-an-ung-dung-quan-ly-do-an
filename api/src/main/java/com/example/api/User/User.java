package com.example.api.User;

import com.example.api.Document.Document;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Setter
@Getter
@Entity
@Table(name = "users")
public class User implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @NotNull(message = "Email là bắt buộc")
    @Column(unique = true, length = 255, nullable = false)
    private String email;

    @NotNull(message = "Mật khẩu là bắt buộc")
    @Column(length = 255, nullable = false)
    private String password;

    // Quan hệ một-nhiều với Document
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Document> documents;

    // Constructors
    public User() {}

    public User(String password, String email) {
        this.email = email;
        this.password = password;
    }
}
