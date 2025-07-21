/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;

public class PasswordUtil {
    
    // SHA-256 encryption method
    public static String encryptSHA256(String password) {
        if (password == null || password.isEmpty()) {
            return null;
        }
        try {
            // Tạo MessageDigest instance cho SHA-256
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            // Chuyển đổi password thành byte array và hash
            byte[] hashBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            // Chuyển đổi byte array thành hex string
            StringBuilder hexString = new StringBuilder();
            for (byte hashByte : hashBytes) {
                String hex = Integer.toHexString(0xff & hashByte);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            System.err.println("SHA-256 algorithm not available: " + e.getMessage());
            return null;
        } catch (Exception e) {
            System.err.println("Error during SHA-256 encryption: " + e.getMessage());
            return null;
        }
    }
    
    
}