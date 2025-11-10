-- Database Migration Script for Withdrawal System
-- Tạo các bảng mới cho hệ thống rút tiền và admin giữ tiền

-- 1. Bảng HostBalances - Lưu số dư của host
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HostBalances]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[HostBalances] (
        [HostBalanceID] INT IDENTITY(1,1) PRIMARY KEY,
        [HostID] INT NOT NULL,
        [AvailableBalance] DECIMAL(18,2) DEFAULT 0.00,
        [PendingBalance] DECIMAL(18,2) DEFAULT 0.00,
        [TotalEarnings] DECIMAL(18,2) DEFAULT 0.00,
        [LastUpdated] DATETIME DEFAULT GETDATE(),
        CONSTRAINT [FK_HostBalances_Users] FOREIGN KEY ([HostID]) REFERENCES [dbo].[Users]([UserID]),
        CONSTRAINT [UQ_HostBalances_HostID] UNIQUE ([HostID])
    );
    
    PRINT 'Table HostBalances created successfully';
END
ELSE
BEGIN
    PRINT 'Table HostBalances already exists';
END
GO

-- 2. Bảng HostEarnings - Chi tiết thu nhập từ từng booking
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HostEarnings]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[HostEarnings] (
        [HostEarningID] INT IDENTITY(1,1) PRIMARY KEY,
        [HostID] INT NOT NULL,
        [BookingID] INT NOT NULL,
        [PaymentID] INT NOT NULL,
        [TotalAmount] DECIMAL(18,2) NOT NULL,
        [CommissionAmount] DECIMAL(18,2) NOT NULL,
        [HostAmount] DECIMAL(18,2) NOT NULL,
        [Status] VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING', 'AVAILABLE', 'WITHDRAWN'
        [CheckOutDate] DATE NOT NULL,
        [AvailableAt] DATETIME NOT NULL,
        [CreatedAt] DATETIME DEFAULT GETDATE(),
        CONSTRAINT [FK_HostEarnings_Users] FOREIGN KEY ([HostID]) REFERENCES [dbo].[Users]([UserID]),
        CONSTRAINT [FK_HostEarnings_Bookings] FOREIGN KEY ([BookingID]) REFERENCES [dbo].[Bookings]([BookingID]),
        CONSTRAINT [FK_HostEarnings_Payments] FOREIGN KEY ([PaymentID]) REFERENCES [dbo].[Payments]([PaymentID]),
        CONSTRAINT [CK_HostEarnings_Status] CHECK ([Status] IN ('PENDING', 'AVAILABLE', 'WITHDRAWN'))
    );
    
    CREATE INDEX [IX_HostEarnings_HostID] ON [dbo].[HostEarnings]([HostID]);
    CREATE INDEX [IX_HostEarnings_Status] ON [dbo].[HostEarnings]([Status]);
    CREATE INDEX [IX_HostEarnings_AvailableAt] ON [dbo].[HostEarnings]([AvailableAt]);
    
    PRINT 'Table HostEarnings created successfully';
END
ELSE
BEGIN
    PRINT 'Table HostEarnings already exists';
END
GO

-- 3. Bảng Withdrawals - Lịch sử rút tiền
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Withdrawals]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Withdrawals] (
        [WithdrawalID] INT IDENTITY(1,1) PRIMARY KEY,
        [HostID] INT NOT NULL,
        [Amount] DECIMAL(18,2) NOT NULL,
        [BankAccount] VARCHAR(50) NOT NULL,
        [BankName] VARCHAR(100) NOT NULL,
        [AccountHolderName] NVARCHAR(100) NOT NULL,
        [Status] VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING', 'APPROVED', 'REJECTED', 'COMPLETED'
        [RequestedAt] DATETIME DEFAULT GETDATE(),
        [ProcessedAt] DATETIME NULL,
        [ProcessedBy] INT NULL,
        [RejectionReason] NVARCHAR(500) NULL,
        [Notes] NVARCHAR(1000) NULL,
        CONSTRAINT [FK_Withdrawals_Users] FOREIGN KEY ([HostID]) REFERENCES [dbo].[Users]([UserID]),
        CONSTRAINT [FK_Withdrawals_ProcessedBy] FOREIGN KEY ([ProcessedBy]) REFERENCES [dbo].[Users]([UserID]),
        CONSTRAINT [CK_Withdrawals_Status] CHECK ([Status] IN ('PENDING', 'APPROVED', 'REJECTED', 'COMPLETED'))
    );
    
    CREATE INDEX [IX_Withdrawals_HostID] ON [dbo].[Withdrawals]([HostID]);
    CREATE INDEX [IX_Withdrawals_Status] ON [dbo].[Withdrawals]([Status]);
    CREATE INDEX [IX_Withdrawals_RequestedAt] ON [dbo].[Withdrawals]([RequestedAt]);
    
    PRINT 'Table Withdrawals created successfully';
END
ELSE
BEGIN
    PRINT 'Table Withdrawals already exists';
END
GO

-- 4. Bảng WithdrawalEarnings - Liên kết withdrawal với earnings
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WithdrawalEarnings]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[WithdrawalEarnings] (
        [WithdrawalEarningID] INT IDENTITY(1,1) PRIMARY KEY,
        [WithdrawalID] INT NOT NULL,
        [HostEarningID] INT NOT NULL,
        CONSTRAINT [FK_WithdrawalEarnings_Withdrawals] FOREIGN KEY ([WithdrawalID]) REFERENCES [dbo].[Withdrawals]([WithdrawalID]) ON DELETE CASCADE,
        CONSTRAINT [FK_WithdrawalEarnings_HostEarnings] FOREIGN KEY ([HostEarningID]) REFERENCES [dbo].[HostEarnings]([HostEarningID]),
        CONSTRAINT [UQ_WithdrawalEarnings] UNIQUE ([WithdrawalID], [HostEarningID])
    );
    
    CREATE INDEX [IX_WithdrawalEarnings_WithdrawalID] ON [dbo].[WithdrawalEarnings]([WithdrawalID]);
    CREATE INDEX [IX_WithdrawalEarnings_HostEarningID] ON [dbo].[WithdrawalEarnings]([HostEarningID]);
    
    PRINT 'Table WithdrawalEarnings created successfully';
END
ELSE
BEGIN
    PRINT 'Table WithdrawalEarnings already exists';
END
GO

PRINT 'All tables created successfully!';
GO
