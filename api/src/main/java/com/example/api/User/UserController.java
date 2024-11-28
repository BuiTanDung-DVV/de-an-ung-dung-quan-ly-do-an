package com.example.api.User;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    // Đăng ký người dùng mới
    @PostMapping("/register")
    public ResponseEntity<?> Register(@RequestBody User user) {
        User existingUser = userRepository.findByEmail(user.getEmail());
        if (existingUser != null) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Collections.singletonMap("message", "Email đã tồn tại trong hệ thống"));
        }
        userRepository.save(user);
        return ResponseEntity.ok("Đăng ký thành công");
    }


    // Đăng nhập
    @PostMapping("/login")
    public ResponseEntity<?> Login(@RequestBody User user) {
        User existingUser = userRepository.findByEmail(user.getEmail());

        if (existingUser == null || !existingUser.getPassword().equals(user.getPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("Tên người dùng hoặc mật khẩu không chính xác.");
        }

        return ResponseEntity.ok(new UserResponse(existingUser.getId()));
    }
    @Getter
    public static class UserResponse {
        private int userId;

        public UserResponse(int userId) {
            this.userId = userId;
        }

    }
}
