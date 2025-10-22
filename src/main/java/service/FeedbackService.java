/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import java.sql.SQLException;
import java.util.List;
import model.Feedback;
import userDAO.FeedbackDAO;

/**
 *
 * @author Administrator
 */
public class FeedbackService {
    private FeedbackDAO feedbackDAO = new FeedbackDAO();

    public boolean addFeedback(Feedback feedback) throws SQLException {
        return feedbackDAO.insertFeedback(feedback);
    }
    
    public Feedback getFeedbackById(int id) throws SQLException{
        return feedbackDAO.getFeedbackById(id);
    }
    
    public void updateStatus(int id, String status) throws SQLException{
        feedbackDAO.updateStatus(id, status);
    }
}
