package com.example.api.Document;


import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface DocumentRepository extends JpaRepository<Document,Long> {
    List<Document> findByUserId(int userId);
}