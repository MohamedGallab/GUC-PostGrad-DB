USE PostGradDB

DELETE FROM PostGradUser;

-- insert Admin
DBCC CHECKIDENT (PostGradUser, RESEED, 0); -- reseeds the entity starting from 1
INSERT INTO PostGradUser VALUES ('AlbusDumbledoreEmail', 'AlbusDumbledorePass');
INSERT INTO Admin VALUES (SCOPE_IDENTITY());

---- Proc to insert admins
--GO
--CREATE PROC InsertAdmin
--@email VARCHAR(50), @password VARCHAR(20)
--AS
--	INSERT INTO PostGradUser VALUES(@email, @password);
--	INSERT INTO Admin VALUES (SCOPE_IDENTITY());
--RETURN

--GO
--EXEC InsertAdmin 'AlbusDumbledoreEmail', 'AlbusDumbledorePass';
--EXEC InsertAdmin 'MinervaMcGonagallEmail', 'MinervaMcGonagallPass';

GO
-- insert Students 4 gucian, 3 nongucian, 2 supervisors, 2 examiners, 2 admin
EXEC StudentRegister 'Harry', 'Potter', 'HarryPotterPass', 'Gryffindor', 1, 'HarryPotterPassEmail ', '4 Privet Drive';
EXEC StudentRegister 'Ronald', 'Weasley', 'RonaldWeasleyPass', 'Gryffindor', 1, 'RonaldWeasleyPassEmail', 'The Burrow';
EXEC StudentRegister 'Hermione', 'Granger', 'HermioneGrangerPass', 'Gryffindor', 1, 'HermioneGrangerEmail', 'Hampstead Garden Suburb';
EXEC StudentRegister 'Neville ', 'Longbottom ', 'NevilleLongbottomPass', 'Gryffindor', 1, 'NevilleLongbottomEmail', 'The Leaky Cauldron';

EXEC StudentRegister 'Draco', 'Malfoy', 'DracoMalfoyPass', 'Slytherin', 0, 'DracoMalfoyEmail', ' The Malfoy Mansion';
EXEC StudentRegister 'Cedric', 'Diggory', 'CedricDiggoryPass', 'Hufflepuff', 0, 'CedricDiggoryEmail', 'Ottery St Catchpole';
EXEC StudentRegister 'Luna', 'Lovegood ', 'LunaLovegoodPass', 'Ravenclaw', 0, 'LunaLovegoodEmail	', 'The Lovegood House';

GO
--EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';
--EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';
--EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';

--EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';
--EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';
--EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';

GO
-- insert Supervisors
EXEC SupervisorRegister 'Remus', 'Lupin', 'RemusLupinPass', 'Gryffindor', 'RemusLupinEmail';
EXEC SupervisorRegister 'Severus', 'Snape', 'SeverusSnapePass', 'Slytherin', 'SeverusSnapeEmail';
EXEC SupervisorRegister 'Filius', 'Flitwick', 'FiliusFlitwickPass', 'Ravenclaw', 'FiliusFlitwickEmail';

--EXEC SupervisorRegister 'Super firstname 1', 'Super lastname 1', 'Super password 1', 'Super faculty 1', 'Super email 1';

-- insert Thesis
INSERT INTO Thesis (field, type, title, startDate, endDate, grade, noExtension) 	
VALUES ('thesis field 1', 'type 1', 'title 1', '2020-01-01', '2021-01-01', 4.0, 1);
INSERT INTO Thesis (field, type, title, startDate, endDate, grade, noExtension) 	
VALUES ('thesis field 2', 'type 2', 'title 2', '2020-01-01', '2023-01-01', 4.0, 1);
INSERT INTO Thesis (field, type, title, startDate, endDate, grade, noExtension) 	
VALUES ('thesis field 3', 'type 3', 'title 3', '2020-01-01', '2025-01-01', 4.0, 1);
INSERT INTO Thesis (field, type, title, startDate, endDate, grade, noExtension) 	
VALUES ('thesis field 4', 'type 4', 'title 4', '2020-01-01', '2021-01-01', 4.0, 1);

insert into GUCianStudentRegisterThesis(serial_no, sid, supid) values (2,3,1);
insert into NonGUCianStudentRegisterThesis(serial_no, sid, supid) values (4,7,1);


GO
CREATE PROC AddThesis
@field VARCHAR(20), @type VARCHAR(10), @title VARCHAR(50), @startDate DATE, @endDate DATE, @grade DECIMAL(5,2), @noExtension INT
AS
	INSERT INTO Thesis (field, type, title, startDate, endDate, grade, noExtension) 	
	VALUES (@field, @type, @title, @startDate, @endDate, @grade, @noExtension);
RETURN

insert into GUCianStudentRegisterThesis values (1,2,1);
declare @thesesCount int;
exec AdminViewOnGoingTheses @thesesCount OUTPUT;
print @thesesCount;

GO
EXEC AddThesis 'thesis field 1', 'type 1', 'title 1', '2020-01-01', '2021-01-01', 4.0, 1;
EXEC AddThesis 'thesis field 1', 'type 1', 'title 1', '2020-01-01', '2021-01-01', 4.0, 1;
EXEC AddThesis 'thesis field 1', 'type 1', 'title 1', '2020-01-01', '2021-01-01', 4.0, 1;
EXEC AddThesis 'thesis field 1', 'type 1', 'title 1', '2020-01-01', '2021-01-01', 4.0, 1;

GO
-- insert Thesis payment
DECLARE @SuccessOut BIT
EXEC AdminIssueThesisPayment @ThesisSerialNo = 1, @amount = 1000, @noOfInstallments = 4, @fundPercentage = 10, @Success = @SuccessOut OUTPUT
PRINT @SuccessOut

GO
-- link thesis studnet and supervisor
INSERT INTO GUCianStudentRegisterThesis VALUES (1,2,1)

GO
-- insert publication and link to thesis
INSERT INTO Publication VALUES('PUB title 1', '2020-02-02', 'PUB place 1', 1, 'PUB host 1')
INSERT INTO ThesisHasPublication VALUES (1,1);
INSERT INTO Publication VALUES('PUB title 2', '2020-02-02', 'PUB place 2', 0, 'PUB host 2')
INSERT INTO ThesisHasPublication VALUES (1,2);
INSERT INTO Publication VALUES('PUB title 3', '2020-02-02', 'PUB place 3', 1, 'PUB host 3')
INSERT INTO ThesisHasPublication VALUES (2,3);
INSERT INTO Publication VALUES('PUB title 4', '2020-02-02', 'PUB place 4', 1, 'PUB host 4')
INSERT INTO ThesisHasPublication VALUES (2,4);

-- COURSES
EXEC AddCourse 'CSEN 1', 8, 1000;
EXEC linkCourseStudent 1,3;
EXEC addStudentCourseGrade 1,3,10;
EXEC linkCourseStudent 1,4;
EXEC addStudentCourseGrade 1,4,50;
EXEC linkCourseStudent 1,5;
EXEC addStudentCourseGrade 1,5,100;

EXEC AddCourse 'MATH 1', 6, 2000;
EXEC linkCourseStudent 2,3;
EXEC addStudentCourseGrade 2,3,15;
EXEC linkCourseStudent 2,4;
EXEC addStudentCourseGrade 2,4,55;


-- INSERTING THESIS --
GO
DECLARE @ThesisID INT;
INSERT INTO Thesis (field, type, title, startDate, endDate) VALUES ('field','type','title', 'startDate','endDate');
SET @ThesisID = SCOPE_IDENTITY();
DECLARE @ThesisPaymentID INT;
EXEC AdminIssueThesisPayment @ThesisID,	amount, noOfInstallments, fundPercentage, Success;
SET @ThesisPaymentID = SCOPE_IDENTITY();

GO
DECLARE @StudentID INT;
EXEC StudentRegister 'first_name', 'last_name', 'password', 'faculty', 1, 'email ', 'address';
SET @StudentID = SCOPE_IDENTITY();
PRINT @StudentID;
IF (GUCIAN = 1)
BEGIN
	EXEC addMobile @StudentID, 'mobile_number';
END

DECLARE @SupervisorID INT;
EXEC SupervisorRegister 'first_name', 'last_name', 'password', 'faculty', 'email';
SET @SupervisorID = SCOPE_IDENTITY();
RETURN

IF (GUCIAN = 1)
BEGIN
	INSERT INTO GUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);
END
ELSE 
BEGIN
	INSERT INTO NonGUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);
END

DECLARE @ProgressReportNo INT;
EXEC AddProgressReport @ThesisID, 'Date';
SET @ProgressReportNo = SCOPE_IDENTITY();

EXEC EvaluateProgressReport @SupervisorID, @ThesisID, @ProgressReportNo, eval;

EXEC AddGrade @ThesisID, grade;

-- ADDING COURSE --
DECLARE @CourseID INT;
EXEC AddCourse 'Code', creditHrs, fees;
SET @CourseID = SCOPE_IDENTITY();

EXEC linkCourseStudent @CourseID, @StudentID;

EXEC addStudentCourseGrade @CourseID, @StudentID, grade;

DECLARE @Fees DECIMAL;
SELECT @Fees = fees FROM Course WHERE id = @CourseID;

DECLARE @CoursePaymentId INT;
INSERT INTO PAYMENT (amount, no_Installments, fundPercentage) VALUES (@Fees, no_Installments, fundPercentage);
SET @CoursePaymentId = SCOPE_IDENTITY();

INSERT INTO NonGucianStudentPayForCourse VALUES (@StudentID, @CoursePaymentId, @CourseID);

-- ADDING DEFENSE --

IF (GUCIAN = 1)
	EXEC AddDefenseGucian @ThesisID, 'DefenseDate', 'DefenseLocation';
ELSE
	EXEC AddDefenseNonGucian @ThesisID, 'DefenseDate', 'DefenseLocation';

EXEC AddExaminer @ThesisID, 'DefenseDate', 'ExaminerName', 'NationalBit', 'fieldOfWork';

EXEC AddDefenseGrade @ThesisID, 'DefenseDate', grade;

EXEC AddCommentsGrade @ThesisID, 'DefenseDate', 'comments';

DECLARE @PubID INT;
EXEC addPublication 'title', 'pubDateTime', 'host', 'place', accepted;
SET @PubID = SCOPE_IDENTITY();
EXEC linkPubThesis @PubID, @ThesisID;


-- ONLY INSERT AND EXEC STATEMENTS --
INSERT INTO Thesis (field, type, title, startDate, endDate) VALUES ('field','type','title', 'startDate','endDate');
EXEC AdminIssueThesisPayment @ThesisID,	amount, noOfInstallments, fundPercentage, Success;
EXEC StudentRegister 'first_name', 'last_name', 'password', 'faculty', 1, 'email ', 'address';
EXEC addMobile @StudentID, 'mobile_number';
EXEC SupervisorRegister 'first_name', 'last_name', 'password', 'faculty', 'email';
INSERT INTO GUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);
INSERT INTO NonGUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);
EXEC AddProgressReport @ThesisID, 'Date';
EXEC EvaluateProgressReport @SupervisorID, @ThesisID, @ProgressReportNo, eval;
EXEC AddGrade @ThesisID, grade;

EXEC AddCourse 'Code', creditHrs, fees;
EXEC linkCourseStudent @CourseID, @StudentID;
EXEC addStudentCourseGrade @CourseID, @StudentID, grade;
INSERT INTO PAYMENT (amount, no_Installments, fundPercentage) VALUES (@Fees, no_Installments, fundPercentage);
INSERT INTO NonGucianStudentPayForCourse VALUES (@StudentID, @CoursePaymentId, @CourseID);

EXEC AddDefenseGucian @ThesisID, 'DefenseDate', 'DefenseLocation';
EXEC AddDefenseNonGucian @ThesisID, 'DefenseDate', 'DefenseLocation';
EXEC AddExaminer @ThesisID, 'DefenseDate', 'ExaminerName', 'NationalBit', 'fieldOfWork';
EXEC AddDefenseGrade @ThesisID, 'DefenseDate', grade;
EXEC AddCommentsGrade @ThesisID, 'DefenseDate', 'comments';
EXEC addPublication 'title', 'pubDateTime', 'host', 'place', accepted;
EXEC linkPubThesis @PubID, @ThesisID;


