package com.example.api.Document;


import com.example.api.Email.EmailService;
import com.example.api.Firebase.FirebaseService;
import com.example.api.User.User;
import com.example.api.User.UserRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping(path = "/documents")
public class DocumentController {

    private final DocumentRepository documentRepository;
    private final FirebaseService firebaseService;
    private final UserRepository userRepository;
    private final EmailService emailService;

    @Autowired
    public DocumentController(DocumentRepository documentRepository, FirebaseService firebaseService, UserRepository userRepository, EmailService emailService) {
        this.documentRepository = documentRepository;
        this.firebaseService = firebaseService;
        this.userRepository = userRepository;
        this.emailService = emailService;
    }

    @GetMapping
    public ResponseEntity<List<Document>> getDocuments(@RequestParam int userId) {
        List<Document> documents = documentRepository.findByUserId(userId);
        return new ResponseEntity<>(documents, HttpStatus.OK);
    }

    @PostMapping("/add")
    public ResponseEntity<Document> addDocument(
            @RequestParam int userId,
            @Valid @RequestPart("document") Document document,
            @RequestPart("file") MultipartFile file) throws IOException {

        // Tìm người dùng hiện tại
        Optional<User> User = userRepository.findById(userId);
        if (User.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        // Liên kết tài liệu với người dùng
        document.setUser(User.get());

        // Tải file lên Firebase Storage và lấy URL
        String fileUrl = firebaseService.uploadFile(file);
        document.setPdfFileName(file.getOriginalFilename());
        document.setPdfUrl(fileUrl);

        // Gửi email thông báo nộp tài liệu thành công
        String emailSubject = "Thông báo nộp tài liệu thành công";
        String emailBody = "Chúc mừng bạn đã nộp tài liệu thành công! Tên tài liệu: " + document.getTitle();
        emailService.sendEmail(User.get().getEmail(), emailSubject, emailBody);

        Document savedDocument = documentRepository.save(document);
        return new ResponseEntity<>(savedDocument, HttpStatus.CREATED);
    }

    // Phương thức xóa tài liệu
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteDocument(@PathVariable Long id) {
        Optional<Document> documentOptional = documentRepository.findById(id);
        if (documentOptional.isPresent()) {
            Document document = documentOptional.get();

            // Xóa file PDF khỏi Firebase Storage
            firebaseService.deleteFile(document.getPdfFileName());

            // Xóa tài liệu khỏi cơ sở dữ liệu
            documentRepository.delete(document);

            return new ResponseEntity<>("Document deleted successfully", HttpStatus.OK);
        }
        return new ResponseEntity<>("Document not found", HttpStatus.NOT_FOUND);
    }
}
