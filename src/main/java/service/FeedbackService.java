package service;

import java.sql.SQLException;
import java.util.List;
import model.Feedback;
import userDAO.FeedbackDAO;
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
    
    public Feedback getLatestResolvedFeedbackByUserId(int userId) throws SQLException {
        return feedbackDAO.getLatestResolvedFeedbackByUserId(userId);
    }
    
    public Feedback getLatestFeedbackByUserId(int userId) throws SQLException {
        return feedbackDAO.getLatestFeedbackByUserId(userId);
    }
    
    public boolean deleteFeedback(int id) throws SQLException {
        return feedbackDAO.deleteFeedback(id);
    }
}
