USE PostGradDB

-- Custome Procedures & Functions & Views

GO
CREATE VIEW allStudentsRegisterThesis AS
(
	SELECT *
	FROM
		GUCianStudentRegisterThesis 
		INNER JOIN GucianStudent ON GUCianStudentRegisterThesis.sid = GucianStudent.id
	UNION
	SELECT *, NULL
	FROM
		NonGUCianStudentRegisterThesis
		INNER JOIN NonGucianStudent ON NonGUCianStudentRegisterThesis.sid = NonGucianStudent.id
)

GO
CREATE VIEW allStudents AS
(
	SELECT *
	FROM GucianStudent
	UNION
	SELECT *, NULL
	FROM NonGucianStudent
)

-- Custom Procedures & Functions & Views

-- 1

-- a) Register to the website by using my name (First and last name), password, faculty, email, and address.

	-- i) student

GO
CREATE PROC StudentRegister
@first_name VARCHAR(20), @last_name VARCHAR(20), @password VARCHAR(20), @faculty VARCHAR(20), @Gucian BIT, @email VARCHAR(50), @address VARCHAR(50)
AS
	INSERT INTO PostGradUser VALUES(@email, @password);
	IF (@Gucian = 1)
	-- if gucian insert into table gucian
	BEGIN
		INSERT INTO GucianStudent (id, firstname, lastname, faculty, address) VALUES (SCOPE_IDENTITY(), @first_name, @last_name, @faculty, @address);
	END

	ELSE
	--else insert into table nongucian
	BEGIN
		INSERT INTO NonGucianStudent (id, firstname, lastname, faculty, address) VALUES (SCOPE_IDENTITY(), @first_name, @last_name, @faculty, @address)
	END	
RETURN

	-- ii) supervisor

GO
CREATE PROC SupervisorRegister
@first_name VARCHAR(20), @last_name VARCHAR(20), @password VARCHAR(20),@faculty VARCHAR(20),@email VARCHAR(50)
AS
	INSERT INTO PostGradUser VALUES(@email, @password);
	INSERT INTO Supervisor (id, first_name,last_name,faculty) VALUES (SCOPE_IDENTITY(), @first_name, @last_name, @faculty);
RETURN

-- 2

-- a) login using my username and password.

GO
CREATE PROC userLogin
@ID INT,@password VARCHAR(20), @Success BIT OUTPUT
AS
	SET @Success  = 0;

	IF(
			EXISTS	( 
				SELECT *
				FROM PostGradUser U
				WHERE U.ID=@ID AND U.Password=@password
				)
	)
	BEGIN
		SET @Success=1;
	END

RETURN 

-- b) add my mobile number(s).
GO
CREATE PROC addMobile
@ID INT,@mobile_number VARCHAR(20)
AS
	--if ID is in gucian table 
	IF(EXISTS (SELECT *
			  FROM Gucian
			  WHERE Gucian.ID=@ID))
	BEGIN
		INSERT INTO GUCStudentPhoneNumber VALUES(@ID,@mobile_number);
	END

	--if id in non gucian table
	ELSE
	BEGIN
		IF(EXISTS (SELECT *
				  FROM NonGucian
				  WHERE NonGucian.ID=@ID))
		BEGIN
			INSERT INTO NonGUCStudentPhoneNumber VALUES(@ID,@mobile_number);
		END
	END

RETURN 



-- 3

-- a) List all supervisors in the system.
GO
CREATE PROC AdminListSup
AS
	SELECT *
	FROM Supervisor
RETURN

-- b) view the profile of any supervisor that contains all his/her information.
GO
CREATE PROC AdminViewSupervisorProfile
@supId INT
AS
	SELECT *
	FROM Supervisor
	WHERE Supervisor.id = @supId
RETURN

-- c) List all Theses in the system.
GO
CREATE PROC AdminViewAllTheses
AS
	SELECT *
	FROM Thesis
RETURN

-- d) List the number of on going theses.
GO
CREATE PROC AdminViewOnGoingTheses
@thesesCount INT OUTPUT
AS
	SELECT @thesesCount = COUNT(*)
	FROM Thesis
	WHERE Thesis.endDate IS NULL
RETURN

-- e) List all supervisors’ names currently supervising students, theses title, student name.
-- what should the output be exactly
GO
CREATE PROC AdminViewStudentThesisBySupervisor
AS
	SELECT Supervisor.first_name + Supervisor.last_name, Thesis.title, allStudentsRegisterThesis.firstname + allStudentsRegisterThesis.lastname
	FROM 
		allStudentsRegisterThesis
		INNER JOIN Supervisor ON allStudentsRegisterThesis.supid = Supervisor.id
		INNER JOIN Thesis ON allStudentsRegisterThesis.serial_no = Thesis.serialNumber
	WHERE
		endDate IS NULL
RETURN

-- f) List nonGucians names, course code, and respective grade.
-- what do I do with this input ?
GO
CREATE PROC AdminListNonGucianCourse
@courseID INT
AS
	SELECT NonGucianStudent.firstname + NonGucianStudent.lastname, Course.courseCode, NonGucianStudentTakeCourse.grade
	FROM 
		NonGucianStudentTakeCourse
		INNER JOIN NonGucianStudent ON NonGucianStudentTakeCourse.sid = NonGucianStudent.id
		INNER JOIN Course ON NonGucianStudentTakeCourse.cid = Course.id
	WHERE 
		@courseID = Course.id
RETURN

-- g) Update the number of thesis extension by 1.
GO
CREATE PROC AdminUpdateExtension
@ThesisSerialNo INT
AS
	UPDATE Thesis
	SET Thesis.noExtension = Thesis.noExtension + 1
	WHERE Thesis.serialNumber = @ThesisSerialNo
RETURN

-- h) Issue a thesis payment.
-- CHECK SCOPE IDENTITY & SUCCESS BIT
GO
CREATE PROC AdminIssueThesisPayment
@ThesisSerialNo INT, @amount DECIMAL, @noOfInstallments INT, @fundPercentage DECIMAL,
@Success BIT OUTPUT
AS
	INSERT INTO Payment
	VALUES (@amount, @noOfInstallments, @fundPercentage);

	UPDATE Thesis
	SET Thesis.payment_id = SCOPE_IDENTITY()
	WHERE Thesis.serialNumber = @ThesisSerialNo;

	SET @Success = 1;
RETURN

-- i) view the profile of any student that contains all his/her information.
GO
CREATE PROC AdminViewStudentProfile
@sid INT
AS
	IF (EXISTS (SELECT * FROM GucianStudent WHERE GucianStudent.id = @sid))
		SELECT * FROM GucianStudent WHERE GucianStudent.id = @sid
	ELSE
		SELECT * FROM NonGucianStudent WHERE NonGucianStudent.id = @sid
RETURN

-- j) Issue installments as per the number of installments for a certain payment every six months starting from the entered date.
--  amount, done FROM WHERE ????
GO
CREATE PROC AdminIssueInstallPayment
@paymentID INT, @InstallStartDate DATE
AS
	DECLARE @i INT = 0;
	DECLARE @InstallmentDate DATE = @InstallStartDate;
	DECLARE @no_installments INT = 
		(SELECT Payment.no_installments
		FROM Payment
		WHERE Payment.id = @paymentID)

	WHILE @i < @no_installments
	BEGIN
		INSERT INTO Installment(date, paymentId)
		VALUES (@InstallmentDate, @paymentID);
		SET @InstallmentDate = DATEADD(month, 6, @InstallmentDate);
		SET @i = @i + 1;
	END
RETURN

-- k) List the title(s) of accepted publication(s) per thesis.
-- CHECK THE GROUP BY AND BIT CHECK
GO
CREATE PROC AdminListAcceptPublication
AS
	SELECT Thesis.title, Publication.title
	FROM
		ThesisHasPublication
		INNER JOIN Thesis ON ThesisHasPublication.serialNo = Thesis.serialNumber
		INNER JOIN Publication ON Publication.id = ThesisHasPublication.pubid
	WHERE
		Publication.accepted = 1
	GROUP BY Thesis.title, Publication.title
RETURN

-- l) Add courses and link courses to students.

-- DECIMAL PARAMETERS ????
GO
CREATE PROC AddCourse
@courseCode VARCHAR(10), @creditHrs INT, @fees DECIMAL
AS
	INSERT INTO Course VALUES (@fees, @creditHrs, @courseCode)
RETURN


-- NonGucianStudentPayForCourse ??????
GO
CREATE PROC linkCourseStudent
@courseID INT, @studentID INT
AS
	INSERT INTO NonGucianStudentTakeCourse (sid, cid) VALUES (@studentID, @courseID)
RETURN

-- GRADE DECIMAL ????
GO
CREATE PROC addStudentCourseGrade
@courseID INT, @studentID INT, @grade DECIMAL (5,2)
AS
	UPDATE NonGucianStudentTakeCourse
	SET grade = @grade
	WHERE cid = @courseID AND sid = @studentID
RETURN

-- m) View examiners and supervisor(s) names attending a thesis defense taking place on a certain date.

-- HOW TO GET SUPEVISOR ???
GO
CREATE PROC ViewExamSupDefense
@defenseDate datetime
AS
	
RETURN

-- 4

-- a) Evaluate a student’s progress report, and give evaluation value 0 to 3.
GO
	CREATE PROC EvaluateProgressReport
	@supervisorid INT,
	@thesisserialno INT,
	@progressreportno INT,
	@evaluation INT
	AS
		IF (@evaluation in (0,1,2,3))
		BEGIN
			UPDATE GucianProgressReport
			SET GUCianProgressReport.eval = @evaluation
			WHERE @supervisorid = GUCianProgressReport.supid AND @thesisserialno = GUCianProgressReport.thesisserialnumber and @progressreportno = GUCianProgressReport.no;
			
			UPDATE NonGUCianProgressReport
			SET NonGUCianProgressReport.eval = @evaluation
			WHERE  NonGUCianProgressReport.supid = @supervisorid AND @thesisserialno = NonGUCianProgressReport.thesisserialnumber and @progressreportno = NonGUCianProgressReport.no
		END
RETURN

-- b) View all my students’s names and years spent in the thesis. TWO SOLUTIONS, THIS ONE BETTER THAN COMMENTED

GO 
CREATE PROC ViewSupStudentsYears
@supervisorID INT
AS
	SELECT AllStudents.firstname, AllStudents.lastname, AllStudents.years
	FROM
	(
	SELECT GucianStudent.firstname, GucianStudent.lastname, Thesis.years
	FROM GUCianStudentRegisterThesis
		INNER JOIN GucianStudent ON GUCianStudentRegisterThesis.sid = GucianStudent.id
		INNER JOIN Thesis ON GUCianStudentRegisterThesis.serial_no = Thesis.serialNumber
	WHERE GUCianStudentRegisterThesis.supid = @supervisorID
	UNION
	SELECT NonGucianStudent.firstname, NonGucianStudent.lastname, Thesis.years
	FROM NonGUCianStudentRegisterThesis
		INNER JOIN NonGucianStudent ON NonGUCianStudentRegisterThesis.sid = NonGucianStudent.id
		INNER JOIN Thesis ON NonGUCianStudentRegisterThesis.serial_no = Thesis.serialNumber
	WHERE NonGUCianStudentRegisterThesis.supid = @supervisorID
	)
	AS AllStudents
RETURN

-- c) View my profile
GO 
	CREATE PROC SupViewProfile
	@supervisorID INT
	AS
	SELECT * 
	FROM Supervisor
	WHERE Supervisor.id = @supervisorID
RETURN

-- Update my personal information.
GO
	CREATE PROC UpdateSupProfile
	@supervisorID INT,
	@name VARCHAR(20),
	@faculty VARCHAR(20)
	AS
	UPDATE Supervisor
	SET Supervisor.name = @name, Supervisor.faculty = @faculty
	WHERE Supervisor.id = @supervisorID
RETURN

-- d) View all publications of a student.

GO
	CREATE PROC ViewAStudentPublications
	@StudentID INT
	AS
		SELECT * 
		FROM GUCianStudentRegisterThesis
			INNER JOIN ThesisHasPublication ON ThesisHasPublication.serialNo = GUCianStudentRegisterThesis.serial_no
			INNER JOIN Publication ON Publication.id = ThesisHasPublication.pubid
		WHERE GUCianStudentRegisterThesis.sid = @StudentID
		UNION
		SELECT * 
		FROM NonGUCianStudentRegisterThesis
			INNER JOIN ThesisHasPublication ON ThesisHasPublication.serialNo = NonGUCianStudentRegisterThesis.serial_no
			INNER JOIN Publication ON Publication.id = ThesisHasPublication.pubid
		WHERE NonGUCianStudentRegisterThesis.sid = @StudentID
RETURN

-- e) Add defense for a thesis GUCIAN
GO
	CREATE PROC AddDefenseGucian
	@ThesisSerialNo INT,
	@DefenseDate DATETIME, 
	@DefenseLocation VARCHAR(15)
	AS
	INSERT INTO DEFENSE (serialNumber, date, location) VALUES (@ThesisSerialNo, @DefenseDate, @DefenseLocation)
	UPDATE Thesis
	SET defenseDate = @DefenseDate
	WHERE THESIS.serialNumber = @ThesisSerialNo
RETURN

-- Add defense for a thesis NONGUCIAN.

GO
	CREATE PROC AddDefenseNonGucian
	@ThesisSerialNo INT,
	@DefenseDate DATETIME,
	@DefenseLocation VARCHAR(15)
	AS
		IF (SELECT MIN(grade)
		FROM NonGUCianStudentRegisterThesis
			INNER JOIN NonGucianStudentTakeCourse ON NonGUCianStudentRegisterThesis.sid = NonGucianStudentTakeCourse.sid
		) > 50
		INSERT INTO DEFENSE (serialNumber, date, location) VALUES (@ThesisSerialNo, @DefenseDate, @DefenseLocation)
RETURN

-- g) Cancel a Thesis if the evaluation of the last progress report is zero.
GO 
	CREATE PROC CancelThesis
	@ThesisSerialNo INT
	AS
	DECLARE @evalLastReport INT
	SELECT Top 1 @evalLastReport = eval
	FROM Thesis
		INNER JOIN GUCianProgressReport ON GUCianProgressReport.thesisSerialNumber = Thesis.serialNumber
		WHERE @ThesisSerialNo = Thesis.serialNumber
	ORDER BY date DESC
	
	IF (@evalLastReport = 0)
		DELETE FROM Thesis WHERE THESIS.serialNumber = @ThesisSerialNo
RETURN

-- f) Add examiner(s) for a defense.


-- PROCEDURE WHICH TAKES INPUTS FOR THE ABOVE FUNCTION TO RETURN THE ID FOR THE NEW EXAMINER NEEDED TO INSERT THE NEWEXAMINER TO THE DEFENSE.
GO
CREATE PROC AddExaminer
	@ThesisSerialNo INT,
	@DefenseDate DATETIME,
	@ExaminerName VARCHAR(20),
	@National BIT, 
	@fieldOfWork VARCHAR(20)
	AS
		INSERT INTO PostGradUser VALUES(null, null);
		INSERT INTO Examiner VALUES (SCOPE_IDENTITY(), @ExaminerName,  @fieldOfWork, @National);
		INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES (@DefenseDate, @ThesisSerialNo, SCOPE_IDENTITY())
RETURN


-- h) QUESTION: WHERE IS THE GRADE INPUT.
GO 
	CREATE PROC AddGrade
	@ThesisSerialNo INT,
	@ThesisGrade DECIMAL(4,2)
	AS
	UPDATE THESIS
	SET grade = @ThesisGrade
	WHERE @ThesisSerialNo = Thesis.serialNumber
RETURN

-- 5
-- a) Add grade for a defense.

GO 
	CREATE PROC AddDefenseGrade
	@ThesisSerialNo INT,
	@DefenseDate DATETIME,
	@grade DECIMAL(5,2)
	AS
	UPDATE DEFENSE
	SET grade = @grade
	WHERE DEFENSE.serialNumber = @ThesisSerialNo AND DEFENSE.date = @DefenseDate
RETURN

-- b) Add comment for a defense. 

GO 
	CREATE PROC AddCommentsGrade
	@ThesisSerialNo INT,
	@DefenseDate DATETIME,
	@comments VARCHAR(300)
	AS
	UPDATE ExaminerEvaluateDefense
	SET comment = @comments
	WHERE ExaminerEvaluateDefense.serialNo = @ThesisSerialNo AND ExaminerEvaluateDefense.date = @DefenseDate
RETURN


-- 6

-- a) View my profile that contains all my information.
GO
	CREATE PROC viewMyProfile
	@studentId INT
	AS
	IF(
		EXISTS	(
				SELECT *
				FROM GucianStudent
				WHERE GucianStudent.id=@studentId
				)
	)
	BEGIN
		SELECT *
		FROM GucianStudent INNER JOIN PostGradUser ON GucianStudent.id=PostGradUser.id
		WHERE GucianStudent.id=@studentId
	END
	ELSE 
	BEGIN
		SELECT *
		FROM NonGucianStudent INNER JOIN PostGradUser ON NonGucianStudent.id=PostGradUser.id
		WHERE NonGucianStudent.id=@studentId
	END
RETURN
-- b) Edit my profile (change any of my personal information).


-- c) As a Gucian graduate, add my undergarduate ID.




-- d) As a nonGucian student, view my courses’ grades



-- e) View all my payments and installments.
	-- i)
	-- ii)
	-- iii)
	-- iv)


-- f) Add and fill my progress report(s).
	-- i)
	-- ii)



-- g) View my progress report(s) evaluations.




-- h) Add publication.



-- i) Link publication to my thesis.
