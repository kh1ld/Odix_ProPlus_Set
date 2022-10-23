USE [A_Resturant]
GO

/****** Object:  Table [dbo].[COMPANY]    Script Date: 14/09/2022 09:10:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[COMPANY](
	[ID_COM] [int] IDENTITY(1,1) NOT NULL,
	[COMPANY] [nvarchar](max) NULL,
	[databasename] [nvarchar](max) NULL,
	[dt_yaer] [nvarchar](max) NULL,
 CONSTRAINT [PK_COMPANY] PRIMARY KEY CLUSTERED 
(
	[ID_COM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


