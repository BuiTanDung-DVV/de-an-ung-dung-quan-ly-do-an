package com.example.api.Firebase;

import com.google.cloud.storage.Acl;
import com.google.cloud.storage.Blob;
import com.google.firebase.cloud.StorageClient;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Service
public class FirebaseService {

    public String uploadFile(MultipartFile file) throws IOException {
        String fileName = file.getOriginalFilename();
        Blob blob = StorageClient.getInstance().bucket().create(fileName, file.getBytes(), file.getContentType());
        blob.createAcl(Acl.of(Acl.User.ofAllUsers(), Acl.Role.READER));
        // Tạo URL công khai dựa trên bucket và tên tệp
        return String.format("https://firebasestorage.googleapis.com/v0/b/%s/o/%s?alt=media",
                StorageClient.getInstance().bucket().getName(),
                URLEncoder.encode(fileName, StandardCharsets.UTF_8.toString()));

    }


    public void deleteFile(String fileName) {
        StorageClient.getInstance().bucket().get(fileName).delete();
    }
}

