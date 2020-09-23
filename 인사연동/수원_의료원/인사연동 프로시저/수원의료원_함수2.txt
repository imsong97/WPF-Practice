IF EXISTS (SELECT name FROM sys.objects WHERE name = 'fnPatientToUserCardNo')
BEGIN
	DROP FUNCTION fnPatientToUserCardNo
END
GO
CREATE FUNCTION fnPatientToUserCardNo
(
	@Sabun	varchar(8)
)
RETURNS NVARCHAR(13)
WITH ENCRYPTION 
AS
BEGIN
	DECLARE @Rtn NVARCHAR(13)
	IF (CHARINDEX('-', @Sabun)=0)
	BEGIN
		SET @Rtn = '00000' + @Sabun
	END ELSE
	BEGIN
		IF (LEN(@Sabun) = 4)
		BEGIN
			SET @Rtn = '20000000' + LEFT(@Sabun, 2) + '45' + RIGHT(@Sabun, 1)
		END ELSE
		IF (LEN(@Sabun) = 5)
		BEGIN
			SET @Rtn = '3000000' + LEFT(@Sabun, 2) + '45' + RIGHT(@Sabun, 2)
		END ELSE
		IF (LEN(@Sabun) = 6)
		BEGIN
			SET @Rtn = '400000' + LEFT(@Sabun, 2) + '45' + RIGHT(@Sabun, 3)
		END ELSE
		IF (LEN(@Sabun) = 7)
		BEGIN
			SET @Rtn = '50000' + LEFT(@Sabun, 2) + '45' + RIGHT(@Sabun, 4)
		END ELSE
		IF (LEN(@Sabun) = 8)
		BEGIN
			SET @Rtn = '6000' + LEFT(@Sabun, 2) + '45' + RIGHT(@Sabun, 5)
		END
	END
	RETURN @Rtn
END
GO