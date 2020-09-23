/* 
HROrgData, HRPersonData테이블을 병원용으로 사용하기위한 테이블로 다시 생성한다.
*/
----------------------------------------------------------------------------------
drop TABLE [HROrgData]

/****** Object:  Table [dbo].[HROrgData]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[HROrgData](
	[OrgName] [nvarchar](50) NOT NULL,
	[OrgCode] [nvarchar](50) NULL,
	[ParentOrgName] [nvarchar](50) NOT NULL,
	[ParentOrgCode] [nvarchar](50) NULL,
	[UpdateOption] [int] NOT NULL
) ON [PRIMARY]

GO
--------------------------------------------------------------------------------------------------------------
--임직원 HRPersonTable1
drop TABLE HRPersonTable1

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

--임직원 임시테이블 생성
CREATE TABLE [dbo].[HRPersonTable1](
	[Sabun] [nvarchar](10) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[CardNo] [nvarchar](36) NULL,
	[UserCardNo] [nvarchar](36) NULL,
	[Tel] [varchar](68) NULL,
	[Mobile] [varchar](68) NULL,
	[ParentOrgCode] [nvarchar](50) NULL,
	[ParentOrgName] [nvarchar](50) NULL,
	[OrgCode] [nvarchar](50) NULL,
	[OrgName] [nvarchar](50) NULL,
	[GradeName] [nvarchar](50) NULL,
	[PersonType] [int] NULL,
	[PersonStatus] [int] NULL,
	[CardStatus] [int] NULL,
	[IssuCnt] [int] NULL,
	[Picture] [varbinary](max) NULL,
	[Email] [varchar](50) NULL,
	[ValidDate] [datetime] NULL,
	[PersonUser1] [nvarchar](30) NULL,
	[PersonUser2] [nvarchar](30) NULL,
	[PersonUser3] [nvarchar](30) NULL,
	[PersonUser4] [nvarchar](30) NULL,
	[PersonUser5] [nvarchar](30) NULL,
	[CardUser1] [nvarchar](50) NULL,
	[CardUser2] [nvarchar](50) NULL,
	[CardUser3] [nvarchar](50) NULL,
	[CardUser4] [nvarchar](50) NULL,
	[CardUser5] [nvarchar](50) NULL,
	[InsertDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--------------------------------------------------------------------------------------------------------------
--환자용 HRPersonTable2
drop TABLE HRPersonTable2

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

--환자용 임시테이블 생성
CREATE TABLE [dbo].[HRPersonTable2](
	[Sabun] [nvarchar](10) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[CardNo] [nvarchar](36) NULL,
	[UserCardNo] [nvarchar](36) NULL,
	[Tel] [varchar](68) NULL,
	[Mobile] [varchar](68) NULL,
	[ParentOrgCode] [nvarchar](50) NULL,
	[ParentOrgName] [nvarchar](50) NULL,
	[OrgCode] [nvarchar](50) NULL,
	[OrgName] [nvarchar](50) NULL,
	[GradeName] [nvarchar](50) NULL,
	[PersonType] [int] NULL,
	[PersonStatus] [int] NULL,
	[CardStatus] [int] NULL,
	[IssuCnt] [int] NULL,
	[Picture] [varbinary](max) NULL,
	[Email] [varchar](50) NULL,
	[ValidDate] [datetime] NULL,
	[PersonUser1] [nvarchar](30) NULL,
	[PersonUser2] [nvarchar](30) NULL,
	[PersonUser3] [nvarchar](30) NULL,
	[PersonUser4] [nvarchar](30) NULL,
	[PersonUser5] [nvarchar](30) NULL,
	[CardUser1] [nvarchar](50) NULL,
	[CardUser2] [nvarchar](50) NULL,
	[CardUser3] [nvarchar](50) NULL,
	[CardUser4] [nvarchar](50) NULL,
	[CardUser5] [nvarchar](50) NULL,
	[InsertDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--------------------------------------------------------------------------------------------------------------
--삭제임직원 HRPersonTable3
drop TABLE HRPersonTable3

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

--삭제임직원 임시테이블 생성
CREATE TABLE [dbo].[HRPersonTable3](
	[Sabun] [nvarchar](10) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[CardNo] [nvarchar](36) NULL,
	[UserCardNo] [nvarchar](36) NULL,
	[Tel] [varchar](68) NULL,
	[Mobile] [varchar](68) NULL,
	[ParentOrgCode] [nvarchar](50) NULL,
	[ParentOrgName] [nvarchar](50) NULL,
	[OrgCode] [nvarchar](50) NULL,
	[OrgName] [nvarchar](50) NULL,
	[GradeName] [nvarchar](50) NULL,
	[PersonType] [int] NULL,
	[PersonStatus] [int] NULL,
	[CardStatus] [int] NULL,
	[IssuCnt] [int] NULL,
	[Picture] [varbinary](max) NULL,
	[Email] [varchar](50) NULL,
	[ValidDate] [datetime] NULL,
	[PersonUser1] [nvarchar](30) NULL,
	[PersonUser2] [nvarchar](30) NULL,
	[PersonUser3] [nvarchar](30) NULL,
	[PersonUser4] [nvarchar](30) NULL,
	[PersonUser5] [nvarchar](30) NULL,
	[CardUser1] [nvarchar](50) NULL,
	[CardUser2] [nvarchar](50) NULL,
	[CardUser3] [nvarchar](50) NULL,
	[CardUser4] [nvarchar](50) NULL,
	[CardUser5] [nvarchar](50) NULL,
	[InsertDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
