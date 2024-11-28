package com.example.api.Document;

import com.example.api.User.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
@Entity
@Table(name = "documents")
public class Document implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull(message = "Người hướng dẫn là bắt buộc")
    @Column(length = 255, nullable = false)
    private String advisor;

    @NotNull(message = "Tác giả là bắt buộc")
    @Column(length = 255, nullable = false)
    private String author;

    @NotNull(message = "Năm tốt nghiệp là bắt buộc")
    @Column(nullable = false)
    private int graduationYear;

    @NotNull(message = "Dạng tài liệu là bắt buộc")
    @Column(length = 50, nullable = false)
    private String type;

    @NotNull(message = "Chuyên ngành là bắt buộc")
    @Column(length = 100, nullable = false)
    private String specialization;

    @NotNull(message = "Tóm tắt là bắt buộc")
    @Column(columnDefinition = "TEXT", nullable = false)
    private String abstractText;

    @NotNull(message = "Ngôn ngữ là bắt buộc")
    @Column(length = 50, nullable = false)
    private String language;

    @NotNull(message = "Nhà xuất bản là bắt buộc")
    @Column(length = 255, nullable = false)
    private String publisher;

    @NotNull(message = "Nhan đề là bắt buộc")
    @Column(length = 255, nullable = false)
    private String title;

    @NotNull(message = "Từ khóa là bắt buộc")
    @Column(columnDefinition = "TEXT", nullable = false)
    private String keywords;

    @Column(length = 255, nullable = false)
    private String pdfFileName;

    @Column(length = 255, nullable = false)
    private String pdfUrl;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userId", nullable = false)
    @JsonIgnore // Tránh vòng lặp khi tuần tự hóa JSON
    private User user;

    // Constructors
    public Document() {
    }

    public Document(String advisor, String author, int graduationYear, String type,
                    String specialization, String abstractText, String language,
                    String publisher, String title, String keywords, String pdfFileName,String pdfUrl) {
        this.advisor = advisor;
        this.author = author;
        this.graduationYear = graduationYear;
        this.type = type;
        this.specialization = specialization;
        this.abstractText = abstractText;
        this.language = language;
        this.publisher = publisher;
        this.title = title;
        this.keywords = keywords;
        this.pdfFileName = pdfFileName;
        this.pdfUrl = pdfUrl;
    }

}
