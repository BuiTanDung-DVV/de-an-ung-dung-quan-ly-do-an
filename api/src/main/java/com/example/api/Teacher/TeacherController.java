package com.example.api.Teacher;

import com.example.api.Document.Document;
import com.example.api.Document.DocumentRepository;
import com.example.api.User.User;
import com.example.api.User.UserRepository;
import lombok.Getter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/teachers")
public class TeacherController {

    @Autowired
    private DocumentRepository documentRepository;

    @Autowired
    private TeacherRepository teacherRepository;

    // Lấy tất cả các tài liệu
    @GetMapping("/documents")
    public ResponseEntity<List<Document>> getAllDocuments() {
        List<Document> documents = documentRepository.findAll();
        return ResponseEntity.ok(documents);
    }

    // Đăng ký giáo viên mới
    @PostMapping("/register")
    public ResponseEntity<?> registerTeacher(@RequestBody Teacher teacher) {
        Teacher existingTeacher = teacherRepository.findByEmail(teacher.getEmail());
        if (existingTeacher != null) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Collections.singletonMap("message", "Email đã tồn tại trong hệ thống"));
        }
        teacherRepository.save(teacher);
        return ResponseEntity.ok("Đăng ký giáo viên thành công");
    }

    // Đăng nhập giáo viên
    @PostMapping("/login")
    public ResponseEntity<?> loginTeacher(@RequestBody Teacher teacher) {
        Teacher existingTeacher = teacherRepository.findByEmail(teacher.getEmail());

        if (existingTeacher == null || !existingTeacher.getPassword().equals(teacher.getPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("Tên người dùng hoặc mật khẩu không chính xác.");
        }

        return ResponseEntity.ok(new TeacherResponse(existingTeacher.getId()));
    }



    @Getter
    public static class StudentResponse {
        private int id;
        private String email;

        public StudentResponse(int id, String email) {
            this.id = id;
            this.email = email;
        }
    }

    @Getter
    public static class TeacherResponse {
        private int teacherId;

        public TeacherResponse(int teacherId) {
            this.teacherId = teacherId;
        }
    }
}