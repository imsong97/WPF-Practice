-- 임직원 RF카드 프로시저
-- 
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'WEB_ADMIN_HRDBFROMACCESSCONTROLEMPL_SCHEDULER')
BEGIN
	DROP PROCEDURE WEB_ADMIN_HRDBFROMACCESSCONTROLEMPL_SCHEDULER
END
GO
CREATE PROCEDURE [dbo].[WEB_ADMIN_HRDBFROMACCESSCONTROLEMPL_SCHEDULER]
	@UpdateIP 				VARCHAR(15)		= '127.0.0.1'
WITH ENCRYPTION
AS 
BEGIN 
	-----Procedure 중복실행 방지
	DECLARE @CNTPROC INT=0
	SELECT @CNTPROC=COUNT(obj.name)
	FROM   (SELECT s2.objectid, s2.text
			FROM   sys.dm_exec_requests AS s1
			CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2) AS q
		 , sys.objects obj
	WHERE  obj.object_id = q.objectid
	AND	   obj.name = 'WEB_ADMIN_HRDBFROMACCESSCONTROLEMPL_SCHEDULER';
	IF (@CNTPROC>1) 
	BEGIN
	    SELECT 'Already Executing'
		RETURN
	END 
	-- 임직원 프로시저
	-- 변수 선언
	DECLARE @tmpHRPersonMaxCnt	INT			=	0
	DECLARE @HRPersonWhileCnt	INT			=	1
	
	DECLARE @Sabun				VARCHAR(10)	=	NULL
	DECLARE	@OrgNameID			INT			=	NULL
	DECLARE	@GradeNameID		INT			=	NULL

	DECLARE @Name				VARCHAR(50)	=	NULL
	DECLARE	@CardNo				VARCHAR(50)	=	NULL
	DECLARE	@UserCardNo			VARCHAR(50)	=	NULL
	DECLARE	@Tel				VARCHAR(68)	=	NULL
	DECLARE	@Mobile				VARCHAR(68)	=	NULL

	DECLARE	@OrgName			VARCHAR(30)	=	NULL
	DECLARE	@GradeName			VARCHAR(30)	=	NULL
	 
	DECLARE	@ParentOrgCode		VARCHAR(30)	=	NULL
	DECLARE	@ParentOrgName		VARCHAR(30)	=	NULL
	DECLARE	@OrgCode			VARCHAR(30)	=	NULL
	DECLARE @ParentOrgID        INT 		= 	NULL

	DECLARE @PersonStatus		INT			=	NULL
	DECLARE @PersonDeleteOption INT			=	NULL
	DECLARE @PersonInfoKeep		INT			=	NULL
	
	DECLARE @CardStatus			INT			=	NULL
	DECLARE @ValidDate          DATETIME    =   NULL
	DECLARE @InsertDate         DATETIME 	=   NULL
	DECLARE @TestFlag		    INT			=	NULL
	DECLARE @Today    			DATETIME    =	CAST(FLOOR(CAST(GETDATE() as FLOAT)) as DATETIME)

	DECLARE @NewGroupID			INT			=	0
	DECLARE @PreOrgNameID		INT			=	0
	DECLARE @OldGroupID			INT			=	0
	DECLARE @MasterGroup		VARCHAR(50)	=	'마스터'

	-- 임시 HRPersonTable1 테이블 생성
	
	CREATE TABLE #tmpHRPersonTable1_0(
		Seq					INT IDENTITY(1,1) NOT NULL,
			Sabun			VARCHAR(10)		COLLATE KOREAN_WANSUNG_CI_AS
		,	Name			NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardNo			VARCHAR(50)		COLLATE KOREAN_WANSUNG_CI_AS
		,	UserCardNo		VARCHAR(50)		COLLATE KOREAN_WANSUNG_CI_AS
		,	Tel				VARCHAR(68)		COLLATE KOREAN_WANSUNG_CI_AS
		,	Mobile			VARCHAR(68)		COLLATE KOREAN_WANSUNG_CI_AS
		,	ParentOrgCode	NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	ParentOrgName	NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	OrgCode			NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	OrgName			NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	GradeName		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	PersonType		INT			
		,	PersonStatus	INT
		,	CardStatus		INT
		,	IssuCnt			INT
		--,	Picture			varbinary(max)   추가개발필요
		,	Email			VARCHAR(50)		COLLATE KOREAN_WANSUNG_CI_AS
		,	ValidDate		DATETIME
		,	PersonUser1		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	PersonUser2		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	PersonUser3		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	PersonUser4		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	PersonUser5		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardUser1		NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardUser2		NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardUser3		NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardUser4		NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardUser5		NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	InsertDate		DATETIME
	)
	CREATE TABLE #tmpHRPersonTable1_1(
		Seq					INT IDENTITY(1,1) NOT NULL
		,	Sabun			VARCHAR(10)		COLLATE KOREAN_WANSUNG_CI_AS
		,	Name			NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardNo			VARCHAR(50)		COLLATE KOREAN_WANSUNG_CI_AS
		,	UserCardNo		VARCHAR(50)		COLLATE KOREAN_WANSUNG_CI_AS
		,	Tel				VARCHAR(68)		COLLATE KOREAN_WANSUNG_CI_AS
		,	Mobile			VARCHAR(68)		COLLATE KOREAN_WANSUNG_CI_AS
		,	ParentOrgCode	NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	ParentOrgName	NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	OrgCode			NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	OrgName			NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	GradeName		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	PersonType		INT			
		,	PersonStatus	INT
		,	CardStatus		INT
		,	IssuCnt			INT
		--,	Picture			varbinary(max)   추가개발필요
		,	Email			VARCHAR(50)		COLLATE KOREAN_WANSUNG_CI_AS
		,	ValidDate		DATETIME
		,	PersonUser1		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	PersonUser2		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	PersonUser3		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	PersonUser4		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	PersonUser5		NVARCHAR(30)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardUser1		NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardUser2		NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardUser3		NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardUser4		NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	CardUser5		NVARCHAR(50)	COLLATE KOREAN_WANSUNG_CI_AS
		,	InsertDate		DATETIME
	)
		
	INSERT INTO HRPersonTable1
	(
		[Sabun]
		,[Name]
		,[CardNo]
		,[UserCardNo]
		,[Tel]
		,[Mobile]
		,[ParentOrgCode]
		,[ParentOrgName]
		,[OrgName]
		,[GradeName]
		,[PersonType]
		,[PersonStatus]
		,[CardStatus]
		,[IssuCnt]
		,[ValidDate]
		,[InsertDate]
	)
 	SELECT  Sabun as Sabun,
			Name as Name,
			'4' + UserCardNo + '1000' as CardNo,
			UserCardNo as UserCardNo,--,카드번호 13자리 확정????
			null as Tel,
			null as Mobile,
			null as ParentOrgCode,
			null as ParentOrgName,
			OrgName as OrgName,
			'직원' as GradeName,--,직원 확정????
			0 as PersonType,
			PersonStatus as PersonStatus,--,근무중  ????
			0 as CardStatus,
			0 as IssuCnt,
			CONVERT(datetime, ValidDate, 120) + '23:59:59' as ValidDate,
			getdate() as InsertDate
	FROM OPENQUERY(M2, 'select * from PUB.HRPERSONTABLE1')
	
	INSERT INTO #tmpHRPersonTable1_0
	(
		[Sabun]
		,[Name]
		,[CardNo]
		,[UserCardNo]
		,[Tel]
		,[Mobile]
		,[ParentOrgCode]
		,[ParentOrgName]
		,[OrgCode]
		,[OrgName]
		,[GradeName]
		,[PersonType]
		,[PersonStatus]
		,[CardStatus]
		,[IssuCnt]
		,[ValidDate]
		,[InsertDate]
	)
 	SELECT	Sabun, Name, CardNo, UserCardNo, Tel, Mobile, ParentOrgCode, 
			ParentOrgName, OrgCode, OrgName, GradeName,
			PersonType, PersonStatus, CardStatus, IssuCnt,
			ValidDate, InsertDate
	FROM HRPersonTable1

		-- 임시테이블 마지막 ROWNUM 추출
	SELECT @tmpHRPersonMaxCnt = COUNT(*) FROM #tmpHRPersonTable1_0
--1차적으로 중복되는 레코드는 빼고 삽입한다.	

	WHILE(@HRPersonWhileCnt <= @tmpHRPersonMaxCnt)
	BEGIN
		BEGIN TRY
			-- 변수 초기화

			IF ( NOT EXISTS (SELECT * FROM #tmpHRPersonTable1_1 WHERE
					Sabun = (SELECT TOP(1) Sabun FROM #tmpHRPersonTable1_0 WHERE Seq = @HRPersonWhileCnt) ) )
			BEGIN
				INSERT INTO #tmpHRPersonTable1_1
				(
					[Sabun],[Name],[CardNo],[UserCardNo],[Tel],[Mobile],
					[ParentOrgCode],[ParentOrgName],[OrgCode],[OrgName],
					[GradeName],[PersonType],[PersonStatus],[CardStatus],
					[IssuCnt],[ValidDate],[InsertDate]
				)
				SELECT  					
					[Sabun],[Name],[CardNo],[UserCardNo],[Tel],[Mobile],
					[ParentOrgCode],[ParentOrgName],[OrgCode],[OrgName],
					[GradeName],[PersonType],[PersonStatus],[CardStatus],
					[IssuCnt],[ValidDate],[InsertDate]
				FROM #tmpHRPersonTable1_0 WHERE Seq = @HRPersonWhileCnt
			END
			ELSE
			BEGIN
				SET @TestFlag=1
			END
		END TRY
		BEGIN CATCH
			INSERT INTO ServiceLog
			(
				DateTime,ServiceLog
			)
			VALUES ( GETDATE() , 'ERROR #tmpHRPersonTable1_0 : ' +  ERROR_MESSAGE() )
		END CATCH
		SET @HRPersonWhileCnt = @HRPersonWhileCnt + 1
	END
	
	
------------------------------------------------------------------------------------ 
	-- 변수 선언
	DECLARE @tmpCardMaxCnt			INT				=	0
	DECLARE @CardWhileCnt			INT				=	1
	DECLARE @CardID					INT				=	NULL
	DECLARE @CardIDF				INT				=	NULL
	DECLARE	@CardNoF				VARCHAR(50)		=	NULL
	DECLARE	@PIDF					INT				=	NULL
	
	DECLARE @LocationID				INT				=	NULL
	DECLARE @EqMasterData			VARCHAR(8000)	=	NULL	 -- 현재 시점의 EqMaster Table에 속한 순차적인 EqMasterID
	DECLARE @MasterkWhileCnt		INT				 =	1
	DECLARE @IsSecurity				VARCHAR(10)		=	''
	DECLARE @IsSecurityEqMasterID	VARCHAR(500)	=	''
	DECLARE @IsAccess				VARCHAR(32)		=	''
	DECLARE @IsAccessEqMasterID		VARCHAR(500)	=	''
	DECLARE @tmpMasterkMaxCnt		INT				 =	0
	DECLARE @EqMasterID				INT				=	NULL
	DECLARE @EqCodeID				INT				=	NULL
	DECLARE @Master					INT				=	NULL
	DECLARE @EqMasterChkKey			VARCHAR(8000)	=	NULL	 -- 현재 시점의 EqMasterID
	DECLARE @CardKind				VARCHAR(2)		=	NULL
	DECLARE @LocationUse			INT				=	0		 -- 같은 위치값인지에대한 비교값
	DECLARE @FingerAuthTypeID		INT
	DECLARE @LocationData			VARCHAR(8000)	=	NULL	 -- 공용부로 지정된 전체 출입위치값 : [Value: 1|3|7|9]
	
	DECLARE @OldValidDate           DATETIME	-- 퇴원환자 재입원 시 출입기한만료로 출입이 안될 때

	DECLARE @tmpPersonGroupLinkMaxCnt	INT			=	0
	DECLARE @PersonGroupLinWhileCnt		INT			=	1
	DECLARE @tmpPID						INT			=	1
	DECLARE @tmpPersonGroupID			INT			=	1
	DECLARE @tmpGroupName	            VARCHAR(50) =	NULL
	DECLARE @tmpIsDeleted               INT         =   0

	DECLARE @CursorCardID 			CURSOR 			   --8.29

	SET @HRPersonWhileCnt =	1
	SELECT @tmpHRPersonMaxCnt = COUNT(*) FROM #tmpHRPersonTable1_1 -- 임시테이블 마지막 ROWNUM 추출 #tmpHRPersonTable1_1
	/* 기기권한용 */
	--------------------------------------------------------------------------------------------
	WHILE(@HRPersonWhileCnt <= @tmpHRPersonMaxCnt)
	BEGIN
		BEGIN TRY
			-- 변수 초기화
			SET @OrgNameID = 0
			SET @ParentOrgID = NULL

			SET @PreOrgNameID = NULL
			SET @GradeNameID = NULL

			SET @NewGroupID = NULL
			SET @OldGroupID = NULL
			
			
			SELECT @Sabun = Sabun, @Name = Name, @CardNo = CardNo, @Tel = Tel, @Mobile = Mobile, @OrgName = OrgName
				, @GradeName = GradeName, @PersonStatus = PersonStatus, @UserCardNo = UserCardNo, @CardStatus = CardStatus  
				, @OrgCode = OrgCode, @ParentOrgCode = ParentOrgCode, @ParentOrgName = ParentOrgName
				, @ValidDate=ValidDate, @InsertDate=InsertDate 
				FROM #tmpHRPersonTable1_1 WHERE Seq = @HRPersonWhileCnt
			SELECT @OldValidDate = ValidDate FROM Card WHERE UserCardNo = @UserCardNo
--------------------------------------------------------------------------------	
			
			IF NOT EXISTS (SELECT * FROM Org WHERE OrgName=@OrgName) 
			BEGIN
				insert into Org ( OrgName, ParentOrgID, ReservedWord, InsertDate, UpdateID, UpdateIP, orgcode )
					values ( @OrgName, 0, 0, GETDATE(), 0, 'HR', @orgcode )
			END
			SELECT @OrgNameID = OrgID FROM Org WHERE OrgName = @OrgName
		
			
			-----------------------------------------------------------------------
			IF NOT EXISTS (SELECT * FROM Grade WHERE GradeName=@GradeName) 
			BEGIN
				EXEC WEB_ADMIN_GRADE_REG @PageType='I', @GradeName=@GradeName
			END
			SELECT @GradeNameID = GradeID FROM Grade WHERE GradeName = @GradeName
			
			
			-- 신규 그룹ID 구함. GroupComment 에 팀코드 넣음.??????????????????그룹 구별 유무
			select @NewGroupID = PersonGroupID from PersonGroup where GroupName = @MasterGroup 
			IF ( @NewGroupID is null ) -- 그룹이 없으면 그룹생성
			BEGIN
				Insert into PersonGroup (GroupName,GroupComment,InsertDate,UpdateID,UpdateIP)
					values (@MasterGroup , '마스터', GETDATE(), 0, 'HR')
				select @NewGroupID = PersonGroupID from PersonGroup where GroupName = @MasterGroup				
			END
--------------------------------------------------------------------------------	
			--상위부서명 가져오기
			SELECT @ParentOrgID = OrgID FROM Org 
				WHERE OrgName = @ParentOrgName and OrgCode = @ParentOrgCode 
			
			--부서명 가져오기
			SELECT @OrgNameID = OrgID FROM Org 
				WHERE OrgName = @OrgName and OrgCode = @OrgCode and ParentOrgID = @ParentOrgID 

-----------------------------------------------------------------------------------------------------------------------------------------
			-- 임시 상태 저장
			declare @tmppersonstatus int = (select personstatusid from person where sabun = @sabun)
			declare @tmpcardstatus int = (select TOP(1) cardstatusid from card c inner join person p on c.pid in (p.pid) 
				where p.sabun = @sabun ) 
			

---------------------------------------------------------------------------------------------------		
-- 1. Person 추가 및 수정
---------------------------------------------------------------------------------------------------		
			-- 동일한 사번이있는경우 수정
			IF EXISTS (SELECT * FROM Person WHERE Sabun = @Sabun)
			BEGIN
				UPDATE Person
				SET Name = b.Name
					,	Tel = b.Tel
					,	Mobile = b.Mobile
					,	OrgID = @OrgNameID
					,	GradeID = @GradeNameID
					,	PersonTypeID = b.PersonType
					,	PersonStatusID = b.PersonStatus
					,	Email = b.Email
					,	ValidDate = ISNULL( b.ValidDate, '2099-12-31 23:59:59')
					,	PersonUser1 = b.PersonUser1
					,	PersonUser2 = b.PersonUser2
					,	PersonUser3 = b.PersonUser3
					,	PersonUser4 = b.PersonUser4
					,	PersonUser5 = b.PersonUser5
					,	UpdateDate = GETDATE()
					,	UpdateID = 0
				FROM Person a JOIN #tmpHRPersonTable1_1 b
				ON a.Sabun = b.Sabun
				WHERE Seq = @HRPersonWhileCnt

			END
			ELSE
			BEGIN
				INSERT INTO Person
				(
					Sabun,	Name, Tel, Mobile, OrgID, GradeID, PersonTypeID, 
					PersonStatusID, Email, ValidDate, PersonUser1, PersonUser2, 
					PersonUser3, PersonUser4, PersonUser5, InsertDate, UpdateID
				)
				SELECT Sabun, Name, Tel, Mobile, @OrgNameID, @GradeNameID, 
					PersonType, PersonStatus, Email, ValidDate, PersonUser1, PersonUser2, 
					PersonUser3, PersonUser4, PersonUser5, InsertDate, 0
				FROM #tmpHRPersonTable1_1 WHERE Seq = @HRPersonWhileCnt AND PersonStatus = 0
			END
---------------------------------------------------------------------------------------------------		
-- 2. Card 추가 및 수정코드는 삭제 
---------------------------------------------------------------------------------------------------		
			IF (LEN(@CardNo)<=18) --@CardNo길이가 18이하의 경우만 업데이트 한다
			BEGIN
---------------------------------------------------------------------------------------------------		
-- 2-1. 1인 1Card 인데 기존에 같은 PID로 다른 CardNo가 있으면 휴면카드(4) 

				IF ( EXISTS (select * from card c inner join person p on c.pid = p.pid where p.sabun = @Sabun and p.personstatusid = 0 and c.usercardno = @UserCardNo) ) --기존의 카드가 존재 
				BEGIN
					
					SET @CursorCardID=CURSOR FOR SELECT C.CardID, P.PID, C.CardNo
											FROM Card C 
											INNER JOIN 
												(SELECT Person.Sabun, Person.PID  
													FROM Person	WHERE Person.Sabun=@Sabun) P
												ON C.PID=P.PID where c.usercardno = @UserCardNo
					Open @CursorCardID; 
					Fetch Next From @CursorCardID Into @CardIDF, @PIDF, @CardNoF
					
					While(@@FETCH_STATUS <> -1) 
					Begin; 
						IF(@CardNo<>@CardNoF) --기존의 카드와 카드번호가 다르면 휴면으로 처리 
						BEGIN
							EXEC WEB_ADMIN_CARD_REG @PageType='M', @CardID=@CardIDF, @CardStatusID=4
							UPDATE c 
								SET ValidDate = GetDate() 
							FROM card c					
							WHERE c.CardID = @CardIDF AND CardStatusID!=4
						END
						Fetch Next From @CursorCardID Into @CardIDF, @PIDF , @CardNoF
					End; 
					Close @CursorCardID; 
					Deallocate @CursorCardID;
				END

---------------------------------------------------------------------------------------------------		
				-- 카드정보가 없을시 기본 데이터 등록
				IF ( NOT EXISTS (SELECT * FROM Card WHERE userCardNo = @userCardNo)    )   
				BEGIN
					IF ( @CardNo IS NOT NULL and @CardStatus <> 3 )	-- 카드 삭제가 아닐때.
					BEGIN
						INSERT INTO 
							Card(  CardNo, PID, 
								   CardStatusID, CardTypeID, ValidDate, InsertDate, UpdateID, 
								   CardUser1, CardUser2, CardUser3, CardUser4, CardUser5, UserCardNo)
							SELECT @CardNo, (SELECT PID FROM Person WHERE Sabun = tp.Sabun), 
								   CardStatus, 0, ISNULL(ValidDate, '2099-12-31 23:59:59'), GETDATE(), 0, 
								   CardUser1, CardUser2, CardUser3, CardUser4, CardUser5 , @UserCardNo
							FROM #tmpHRPersonTable1_1 tp WHERE Seq = @HRPersonWhileCnt AND CardStatus=0	--#tmpHRPersonTable1_1
					END
				END
				ELSE
				BEGIN
					SET @CardID = (select CardID from Card where userCardNo = @userCardNo)

					IF ( @CardStatus = 3 )	-- 카드상태가 3이면 업데이트하지 않고 바로 삭제
					BEGIN
						EXEC WEB_ADMIN_CARD_REG 'D', @CardID, 0
					END
					ELSE IF(@CardStatus = 4)
				    BEGIN
					   EXEC WEB_ADMIN_CARD_REG @PageType='M', @CardID=@CardID, @CardStatusID=4
				    END
					ELSE 
					BEGIN
						UPDATE c 
							SET PID = (SELECT PID FROM Person WHERE Sabun = tp.Sabun),
								CardNo = @CardNo,
								CardStatusID = tp.CardStatus, 
								ValidDate = ISNULL(tp.ValidDate, ( CONVERT(VARCHAR,tp.ValidDate,111) + ' 23:59:59' ) ), 
								UpdateDate = GETDATE(), 
								UpdateID = 0, 
								CardUser1 = tp.CardUser1, 
								CardUser2 = tp.CardUser2, 
								CardUser3 = tp.CardUser3, 
								CardUser4 = tp.CardUser4, 
								CardUser5 = tp.CardUser5,
								UserCardNo = @UserCardNo
						FROM card c, ( select top 1 * from #tmpHRPersonTable1_1 WHERE Seq = @HRPersonWhileCnt ) tp					
						WHERE c.CardID = @CardID 
						-- exec시 
						-- UPDATE CardToEqMaster Set DownFlag = 1 where CardID = @CardID 
					END
				END
			END

---------------------------------------------------------------------------------------------------		
-- 3. 사원 상태에 따른 처리
---------------------------------------------------------------------------------------------------		
			IF(@PersonStatus in ( 1, 2) ) --  v3.2 부터 삭제하지 않고 퇴사처리 한다.  ( 사원 상태 변경, 카드 유효기간 변경 )
			BEGIN
				-- 카드 유효기간 변경 
				-- 카드 삭제 상태인데 유효기간이 남아있으면 삭제로 처리하기위하여 유효날짜를 당일 00:00:00으로 처리한다.
				-- *** ValidDate까지 유효기간으로 처리하기로 요청에 의하여 오늘 날짜를 유효날짜로 처리
				IF @ValidDate > dateadd(day, datediff(day, 1, GETDATE()) ,0)
				BEGIN
					SET @ValidDate = dateadd(day, datediff(day, 0, GETDATE()), 0)
				END
				UPDATE Card
				SET ValidDate = @ValidDate
					,UpdateDate = GETDATE()
					,UpdateID = 0
				WHERE PID = (SELECT PID FROM Person WHERE Sabun = @Sabun)

				UPDATE CardToEqMaster
				SET DownFlag = 1
				WHERE CardID in (Select CardID from Card where PID = (SELECT PID FROM Person WHERE Sabun = @Sabun) )

				-- 사원상태 및 유효기간 변경
				UPDATE dbo.Person
				SET PersonStatusID = @PersonStatus
					, ValidDate = @ValidDate
					, UpdateDate = GETDATE()
					, UpdateID = 0
				WHERE Sabun = @Sabun
				-- 퇴사처리된 데이터 PersonGroupLink에서 삭제
				-------------------------------------------------------------------------------------------------------
				SET @tmpPersonGroupLinkMaxCnt	=	0
				SET @PersonGroupLinWhileCnt		=	1
				SET @tmpPID						=	1
				SET @tmpPersonGroupID			=	1
				-- 임시 PersonGroupLink 테이블 생성
				CREATE TABLE #tmpPersonGroupLink(
					Seq					INT IDENTITY(1,1) NOT NULL
					,	PID			    INT
					,	PersonGroupID	INT
				)
				INSERT INTO #tmpPersonGroupLink(PID,PersonGroupID) 
					SELECT P.PID, L.PersonGroupID FROM Person P 
					RIGHT OUTER JOIN PersonGroupLink L ON P.PID=L.PID WHERE P.Sabun=@Sabun
				-- 임시테이블 마지막 ROWNUM 추출
				SELECT @tmpPersonGroupLinkMaxCnt = COUNT(*) FROM #tmpPersonGroupLink
				
				WHILE(@PersonGroupLinWhileCnt <= @tmpPersonGroupLinkMaxCnt)
				BEGIN
					SELECT @tmpPID=PID, @tmpPersonGroupID=PersonGroupID FROM #tmpPersonGroupLink WHERE Seq=@PersonGroupLinWhileCnt
					EXEC WEB_ADMIN_PERSONGROUP_SET_ACCESS 'DEL' , @Sabun, @tmpPersonGroupID
					UPDATE CardToEqMaster Set DownFlag = 1 where CardID in (Select CardID from Card where PID = (SELECT PID FROM Person WHERE Sabun = @Sabun) )
					SET @PersonGroupLinWhileCnt = @PersonGroupLinWhileCnt + 1
				END
				DROP TABLE #tmpPersonGroupLink
				DELETE PersonGroupLink	WHERE PID = (select PID from Person where Sabun = @Sabun)
				-- 퇴사처리 PersonGroupLink삭제, Person/Card정보는 그대로 남겨둔다
			END
			ELSE
			BEGIN
				--------------------------------------------------------------------	
				if(@NewGroupID IS NOT NULL)
				BEGIN
					-- 신규팀 권한 설정
					SET @OldGroupID=NULL
					IF EXISTS (select PersonGroupID FROM PersonGroup WHERE 
						PersonGroupID=
							(SELECT TOP(1) PersonGroupID FROM PersonGroupLink L INNER JOIN Person P ON L.PID=P.PID WHERE Sabun=@Sabun))
					BEGIN
						select @OldGroupID = PersonGroupID FROM PersonGroup WHERE 
							PersonGroupID=
								(SELECT TOP(1) PersonGroupID FROM PersonGroupLink L INNER JOIN Person P ON L.PID=P.PID WHERE Sabun=@Sabun)
					END
			--		select @OldGroupID = PersonGroupID from PersonGroup where GroupName = (select OrgName from org where OrgID = @PreOrgNameID)
					--                   조직별 출입그룹설정
					IF (@OldGroupID IS NULL OR @NewGroupID <> @OldGroupID or @tmppersonstatus <> @PersonStatus or @tmpcardstatus IS NULL or @tmpcardstatus <> @CardStatus or @OldValidDate <> @ValidDate)
					BEGIN
						-- 이전 그룹 권한 삭제
						IF ( @OldGroupID is not null AND @OldGroupID<>0)
						BEGIN
							-- 그룹에서 제거
							exec dbo.[WEB_ADMIN_PERSONGROUP_SET_ACCESS] @Type='DEL' , @Sabun= @Sabun, @GroupID= @OldGroupID
						END
						-- 그룹에 권한 넣음.			
						exec dbo.[WEB_ADMIN_PERSONGROUP_SET_ACCESS] @Type='ADD' , @Sabun= @Sabun, @GroupID= @NewGroupID
						UPDATE CardToEqMaster Set DownFlag = 1 where CardID in (Select CardID from Card where PID = (SELECT PID FROM Person WHERE Sabun = @Sabun) )
					END
				END
				--------------------------------------------------------------------	
				SET @ParentOrgID = NULL
				SET @OrgNameID = NULL
			END

---------------------------------------------------------------------------------------------------		
-- 4. HRPersonTable1 임시 데이터 삭제
---------------------------------------------------------------------------------------------------		
			delete HRPersonTable1 where Sabun = @Sabun	--HRPersonTable1
		END TRY
		BEGIN CATCH
			INSERT INTO ServiceLog
			(
				DateTime,ServiceLog
			)
			VALUES ( GETDATE() , 'ERROR #tmpHRPersonTable1 : ' +  ERROR_MESSAGE() )

		END CATCH


		SET @HRPersonWhileCnt = @HRPersonWhileCnt + 1
	END

	DROP TABLE #tmpHRPersonTable1_1
	DROP TABLE #tmpHRPersonTable1_0	

END
GO