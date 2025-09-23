package utils;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtil {

    public static void sendEmail(String toEmail, String subject, String htmlContent) throws MessagingException {
        // Hardcode Gmail SMTP settings cho dễ sử dụng
        final String smtpHost = "smtp.gmail.com";
        final String smtpPort = "587";
        final String smtpUser = "huynhbahieu456@gmail.com";
        final String smtpPass = "cjprjekjkhucinru"; // App Password
        final String fromEmail = "huynhbahieu456@gmail.com";
        //

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPass);
            }
        });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(fromEmail));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject);
        msg.setContent(htmlContent, "text/html; charset=UTF-8");

        Transport.send(msg);
    }
}


