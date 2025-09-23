/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package service;

import java.sql.SQLException;
import model.User;

/**
 *
 * @author Admin
 */

public interface IUserService {
    User authenticate(String email, String password) throws SQLException;
    boolean emailExists(String email) throws SQLException;
    User createUser(String fullName, String email, String password, String phone, String role) throws SQLException;
    boolean resetPassword(String token, String newPassword) throws SQLException;
    void savePasswordResetToken(int userId, String token) throws SQLException;
    boolean validateResetToken(String token) throws SQLException;
    User findUserByEmail(String email) throws SQLException;
    void sendResetEmail(String email, String resetLink);
}