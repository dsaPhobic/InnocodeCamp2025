# Database Update Guide - Fix Interview Table Issue

## Problem
The virtual interview system is showing "Interview not found" errors because the `interviews` table may not exist or have incorrect structure.

## Solution
Run the following SQL script to create/fix the interviews table:

### Step 1: Open SQL Server Management Studio
1. Connect to your database server
2. Select the `InnocodeSt1` database

### Step 2: Run the SQL Script
Execute the contents of `src/main/resources/interviews_table_mssql_fixed.sql`

### Step 3: Verify the Table
Run this query to check if the table was created successfully:
```sql
SELECT COUNT(*) FROM interviews;
```

You should see a count of at least 1 (the test record).

## Alternative: Manual Table Creation
If the script doesn't work, run these commands manually:

```sql
USE [InnocodeSt1]
GO

-- Create the interviews table
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
    CONSTRAINT [PK_interviews] PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Add indexes
CREATE INDEX [idx_interviews_user_id] ON [dbo].[interviews] ([user_id])
GO
CREATE INDEX [idx_interviews_created_at] ON [dbo].[interviews] ([created_at])
GO
CREATE INDEX [idx_interviews_status] ON [dbo].[interviews] ([status])
GO
```

## Testing
After creating the table:
1. Restart your application
2. Try to start a virtual interview
3. Check the console logs for any remaining errors

## Debug Information
The application now includes debug logging that will show:
- Whether the interviews table exists
- Interview creation process
- Interview retrieval process
- Any SQL errors

Check the server console/logs for these messages to identify any remaining issues. 