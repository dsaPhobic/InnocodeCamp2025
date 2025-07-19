-- Create interviews table for virtual interview feature (SQL Server)
USE [InnocodeSt1]
GO

-- Check if table exists and drop it if needed
IF OBJECT_ID('dbo.interviews', 'U') IS NOT NULL
    DROP TABLE dbo.interviews
GO

CREATE TABLE [dbo].[interviews](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL,
    [topic] [nvarchar](255) NOT NULL,
    [question] [nvarchar](max) NOT NULL,
    [user_answer] [nvarchar](max) NULL,
    [ai_feedback] [nvarchar](max) NULL,
    [score] [int] DEFAULT 0,
    [suggestions] [nvarchar](max) NULL,
    [created_at] [datetime] DEFAULT GETDATE(),
    [status] [nvarchar](20) DEFAULT 'in_progress',
    CONSTRAINT [PK_interviews] PRIMARY KEY CLUSTERED 
    (
        [id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Add foreign key constraint (only if Users table exists)
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[interviews] WITH CHECK ADD CONSTRAINT [FK_interviews_Users] 
    FOREIGN KEY([user_id]) REFERENCES [dbo].[Users] ([id])
END
GO

-- Add indexes for better performance
CREATE INDEX [idx_interviews_user_id] ON [dbo].[interviews] ([user_id])
GO

CREATE INDEX [idx_interviews_created_at] ON [dbo].[interviews] ([created_at])
GO

CREATE INDEX [idx_interviews_status] ON [dbo].[interviews] ([status])
GO

-- Add default constraints
ALTER TABLE [dbo].[interviews] ADD CONSTRAINT [DF_interviews_score] DEFAULT (0) FOR [score]
GO

ALTER TABLE [dbo].[interviews] ADD CONSTRAINT [DF_interviews_created_at] DEFAULT (GETDATE()) FOR [created_at]
GO

ALTER TABLE [dbo].[interviews] ADD CONSTRAINT [DF_interviews_status] DEFAULT ('in_progress') FOR [status]
GO

-- Insert a test record to verify the table works
INSERT INTO [dbo].[interviews] ([user_id], [topic], [question], [status])
VALUES (1, 'Test Interview', 'This is a test question to verify the table works correctly.', 'completed')
GO

PRINT 'Interviews table created successfully!'
GO 