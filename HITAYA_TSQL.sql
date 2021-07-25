CREATE DATABASE HITAYA
GO

USE HITAYA
GO



CREATE TABLE EMPLOYEES
(
	[EMPID] VARCHAR(20) CONSTRAINT uniqz UNIQUE NOT NULL,
	[NAME] VARCHAR(20) NOT NULL,
	[EMAILID] VARCHAR(20)  CONSTRAINT pk_EmailId PRIMARY KEY,
	[DEPARTMENT] VARCHAR(20) NOT NULL,
	[ROLEID] VARCHAR(20) NOT NULL CONSTRAINT chk_Role CHECK ([ROLEID] IN ('JL1','JL2','JL3','JL4','JL5','JL6','JL7','JL8','JL9'))
)
GO


INSERT INTO EMPLOYEES(EMPID,NAME,EMAILID,DEPARTMENT,ROLEID) VALUES ('10800116107','Arnab Das','raj713335@gmail.com','STG','JL3')


CREATE PROCEDURE EMPLOYEE_DETAILS
(
	@EMPID VARCHAR(20),
	@NAME VARCHAR(20),
	@EMAILID VARCHAR(20),
	@DEPARTMENT VARCHAR(20),
	@ROLEID VARCHAR(20)
)
AS
BEGIN
	DECLARE @RES TINYINT
	BEGIN TRY
		INSERT INTO EMPLOYEES(EMPID,NAME,EMAILID,DEPARTMENT,ROLEID) 
		VALUES (@EMPID,@NAME,@EMAILID,@DEPARTMENT,@ROLEID)
		RETURN 1
	END TRY
	BEGIN CATCH
		RETURN -99
	END CATCH
END
GO



DECLARE @RETURNVAL INT
EXEC @RETURNVAL = EMPLOYEE_DETAILS '10800116108','Arnab Das','raj71333c5@gmail.com','STG','JL3'
SELECT @RETURNVAL AS RETURNVAL

SELECT * FROM EMPLOYEES

DROP TABLE USERDETAILS

CREATE TABLE USERDETAILS
(
	[USERID] INT IDENTITY(10000000,1),
	[EMPID] VARCHAR(20) NOT NULL,
	[NAME] VARCHAR(20) NOT NULL,
	[EMAILID] VARCHAR(20)  CONSTRAINT pk_EmailIdx PRIMARY KEY,
	[PASSWORD] VARCHAR(20) NOT NULL,
	[DEPARTMENT] VARCHAR(20) NOT NULL,
	[CRYPTO_ID] VARCHAR(200) NOT NULL,
	[LIMIT] DECIMAL(38,18) NOT NULL,
	[ROLEID] VARCHAR(20) NOT NULL CONSTRAINT chk_Rolex CHECK ([ROLEID] IN ('JL1','JL2','JL3','JL4','JL5','JL6','JL7','JL8','JL9')),
)
GO 



INSERT INTO USERDETAILS(EMPID,NAME,EMAILID,PASSWORD,DEPARTMENT,CRYPTO_ID,LIMIT,ROLEID) SELECT '10800116107','Arnab Das','raj713335@gmail.com','12345678','STG','0xdejjjjaasjw27yswshwsggs','200','JL3'


IF OBJECT_ID('USP_INSERT_USER_DETAILS')  IS NOT NULL
DROP PROC USP_INSERT_USER_DETAILS
GO

CREATE PROCEDURE USP_INSERT_USER_DETAILS
(
	@EMAILID VARCHAR(20),
	@PASSWORD VARCHAR(20),
	@CRYPTO_ID VARCHAR(200),
	@LIMIT DECIMAL(38,18)
)
AS
BEGIN
	DECLARE @EMPID VARCHAR(20),@NAME VARCHAR(20),@DEPARTMENT VARCHAR(20),@ROLEID VARCHAR(20)
	BEGIN TRY
		IF EXISTS(SELECT * FROM EMPLOYEES WHERE EMAILID=@EMAILID)
		RETURN -1
		SELECT @EMPID=EMPID,@NAME=NAME,@DEPARTMENT=DEPARTMENT,@ROLEID=ROLEID FROM EMPLOYEES WHERE @EMAILID=EMAILID
		INSERT INTO USERDETAILS(EMPID,NAME,EMAILID,PASSWORD,DEPARTMENT,CRYPTO_ID,LIMIT,ROLEID) SELECT @EMPID,@NAME,@EMAILID,@PASSWORD,@DEPARTMENT,@CRYPTO_ID,@LIMIT,@ROLEID
		RETURN 1
	END TRY
	BEGIN CATCH
		RETURN -99
	END CATCH
END
GO


DECLARE @RETURNVAL INT
EXEC @RETURNVAL = USP_INSERT_USER_DETAILS 'raj71333c5@gmail.com','12345678','0x77263289191FGSH1b','200.00'
SELECT @RETURNVAL AS RETURNVAL


SELECT * FROM USERDETAILS

SELECT * FROM EMPLOYEES



CREATE PROCEDURE usp_LoginValidation
(
	@EMAILID VARCHAR(20),
	@PASSWORD VARCHAR(20)
)
AS
BEGIN
	DECLARE @RoleId TINYINT
	BEGIN TRY
		IF EXISTS (SELECT * FROM USERDETAILS WHERE EMAILID=@EMAILID AND PASSWORD=@PASSWORD)
			RETURN 1
		ELSE
			RETURN -1
	END TRY
	BEGIN CATCH
		RETURN -99
	END CATCH
END
GO



DECLARE @RETURNVAL INT
EXEC @RETURNVAL = usp_LoginValidation 'raj7163335@gmail.com', '12345678'
SELECT @RETURNVAL AS RETURNVAL

DROP TABLE TRANSACTIONS

CREATE TABLE TRANSACTIONS
(
	[TRANS_ID] INT IDENTITY(1000000,1),
	[DEBIT_ID] VARCHAR(20) NOT NULL,
	[CREDIT_ID] VARCHAR(20) NOT NULL,
	[AMOUNT] DECIMAL(38,18) NOT NULL,
	[SYS_TRNS_DATE] DATETIME2 DEFAULT SYSDATETIME()
)
GO



INSERT INTO TRANSACTIONS(DEBIT_ID,CREDIT_ID,AMOUNT) VALUES ('raj713335@gmail.com','raj713335c@gmail.com','1.0221')





CREATE PROCEDURE USP_TRANSACTIONS
(
	@DEBIT_ID VARCHAR(20),
	@CREDIT_ID VARCHAR(20),
	@AMOUNT DECIMAL(38,18)
)
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT * FROM USERDETAILS WHERE EMAILID=@DEBIT_ID AND LIMIT>=@AMOUNT)
		RETURN -1
		IF NOT EXISTS(SELECT * FROM USERDETAILS WHERE EMAILID=@CREDIT_ID)
		RETURN -1
		INSERT INTO TRANSACTIONS(DEBIT_ID,CREDIT_ID,AMOUNT) VALUES (@DEBIT_ID,@CREDIT_ID,@AMOUNT)
		UPDATE USERDETAILS SET LIMIT=LIMIT-@AMOUNT WHERE EMAILID=@DEBIT_ID
		UPDATE USERDETAILS SET LIMIT=LIMIT+@AMOUNT WHERE EMAILID=@CREDIT_ID
		RETURN 1
	END TRY
	BEGIN CATCH
		RETURN -99
	END CATCH
END
GO



DECLARE @RETURNVAL INT
EXEC @RETURNVAL = USP_TRANSACTIONS 'raj713335@gmail.com','raj71333c5@gmail.com','200'
SELECT @RETURNVAL AS RETURNVAL

SELECT * FROM TRANSACTIONS

SELECT * FROM USERDETAILS


UPDATE USERDETAILS SET LIMIT=LIMIT+20 WHERE EMAILID='raj713335@gmail.com' 


SELECT * FROM USERDETAILS WHERE EMAILID='raj713335@gmail.com'  AND LIMIT>=20