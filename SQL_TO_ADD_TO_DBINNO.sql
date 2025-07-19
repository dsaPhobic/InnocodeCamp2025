-- Thêm vào cuối file dbinno.sql để tạo bảng interviews
USE [InnocodeSt1]
GO

-- Tạo bảng interviews cho chức năng phỏng vấn ảo
CREATE TABLE [dbo].[interviews](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL,
    [topic] [nvarchar](50) NOT NULL,
    [question] [nvarchar](max) NOT NULL,
    [user_answer] [nvarchar](max) NULL,
    [ai_feedback] [nvarchar](max) NULL,
    [score] [int] NULL,
    [suggestions] [nvarchar](max) NULL,
    [created_at] [datetime] NULL,
    [status] [nvarchar](20) NULL,
    CONSTRAINT [PK_interviews] PRIMARY KEY CLUSTERED 
    (
        [id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Thêm foreign key constraint
ALTER TABLE [dbo].[interviews] WITH CHECK ADD CONSTRAINT [FK_interviews_Users] 
FOREIGN KEY([user_id]) REFERENCES [dbo].[Users] ([id])
GO

-- Thêm indexes để tối ưu hiệu suất
CREATE INDEX [idx_interviews_user_id] ON [dbo].[interviews] ([user_id])
GO

CREATE INDEX [idx_interviews_created_at] ON [dbo].[interviews] ([created_at])
GO

CREATE INDEX [idx_interviews_status] ON [dbo].[interviews] ([status])
GO

-- Thêm default constraints
ALTER TABLE [dbo].[interviews] ADD CONSTRAINT [DF_interviews_score] DEFAULT (0) FOR [score]
GO

ALTER TABLE [dbo].[interviews] ADD CONSTRAINT [DF_interviews_created_at] DEFAULT (GETDATE()) FOR [created_at]
GO

ALTER TABLE [dbo].[interviews] ADD CONSTRAINT [DF_interviews_status] DEFAULT ('in_progress') FOR [status]
GO 