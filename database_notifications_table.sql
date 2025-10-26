-- TẠO BẢNG NOTIFICATIONS
-- Chạy script này trong SQL Server

CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    NotificationType NVARCHAR(50) CHECK (NotificationType IN ('Booking','HostRequest','ListingRequest','Feedback','Payment')),
    Status NVARCHAR(20) DEFAULT 'Unread' CHECK (Status IN ('Unread','Read')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    CONSTRAINT FK_Notifications_User
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Tạo indexes để tăng tốc
CREATE INDEX IDX_Notifications_UserID ON Notifications(UserID);
CREATE INDEX IDX_Notifications_Status ON Notifications(Status);
CREATE INDEX IDX_Notifications_CreatedAt ON Notifications(CreatedAt DESC);

-- Kiểm tra
SELECT * FROM Notifications;

PRINT 'Bảng Notifications đã được tạo thành công!';
