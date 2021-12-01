USE PostGradDB

GO

-- 1

-- 2

-- 3

-- a) List all supervisors in the system.
GO
CREATE PROC AdminListSup
AS
	SELECT *
	FROM Supervisor
RETURN
GO

-- b) view the profile of any supervisor that contains all his/her information.
GO
CREATE PROC AdminViewSupervisorProfile
@supId INT
AS
	SELECT *
	FROM Supervisor
	WHERE Supervisor.id = @supId
RETURN
GO

-- c) List all Theses in the system.
GO
CREATE PROC AdminViewAllTheses
AS
	SELECT *
	FROM Thesis
RETURN
GO

-- d) List the number of on going theses.
GO
CREATE PROC AdminViewOnGoingTheses
@thesesCount INT
AS
	SELECT @thesesCount = COUNT(*)
	FROM Thesis
	WHERE Thesis.endDate IS NULL
RETURN
GO

-- e) List all supervisors’ names currently supervising students, theses title, student name.
GO
CREATE PROC AdminViewStudentThesisBySupervisor
AS
	SELECT Supervisor.first_name, Thesis.title, allStudents.firstname
	FROM 
		(
		SELECT * 
		FROM 
			GUCianStudentRegisterThesis 
			INNER JOIN GucianStudent ON GUCianStudentRegisterThesis.sid = GucianStudent.id
		UNION 
		SELECT * 
		FROM 
			NonGUCianStudentRegisterThesis
			INNER JOIN NonGucianStudent ON NonGUCianStudentRegisterThesis.sid = NonGucianStudent.id
		)
		AS allStudents
		INNER JOIN Supervisor ON allStudents.supid = Supervisor.id
		INNER JOIN Thesis ON allStudents.serial_no = Thesis.serialNumber
	WHERE
		endDate IS NULL
RETURN
GO

-- c) List all Theses in the system.
GO
CREATE PROC AdminViewAllTheses
AS
	SELECT *
	FROM Thesis
RETURN
GO

-- c) List all Theses in the system.
GO
CREATE PROC AdminViewAllTheses
AS
	SELECT *
	FROM Thesis
RETURN
GO

-- c) List all Theses in the system.
GO
CREATE PROC AdminViewAllTheses
AS
	SELECT *
	FROM Thesis
RETURN
GO










-- 4

-- a) Evaluate a student’s progress report, and give evaluation value 0 to 3. DONE
GO
	CREATE PROC EvaluateProgressReport
	@supervisorid INT,
	@thesisserialno INT,
	@progressreportno INT,
	@evaluation INT
	AS
		UPDATE GucianProgressReport
		SET GUCianProgressReport.eval = @evaluation
		WHERE @supervisorid = GUCianProgressReport.supid AND @thesisserialno = GUCianProgressReport.thesisserialnumber and @progressreportno = GUCianProgressReport.no
		UPDATE NonGUCianProgressReport
		SET NonGUCianProgressReport.eval = @evaluation
		WHERE @supervisorid = GUCianProgressReport.supid AND @thesisserialno = GUCianProgressReport.thesisserialnumber and @progressreportno = GUCianProgressReport.no

RETURN

-- b) View all my students’s names and years spent in the thesis. TWO SOLUTIONS, THIS ONE BETTER THAN COMMENTED
--GO
--	CREATE PROC ViewSupStudentsYears
--	@supervisorID INT
--	AS
--		SELECT allStudents.firstname, allStudents.lastname, Thesis.years
--		FROM 
--			(
--			SELECT * 
--			FROM 
--				GUCianStudentRegisterThesis 
--				INNER JOIN GucianStudent ON GUCianStudentRegisterThesis.sid = GucianStudent.id
--			UNION 
--			SELECT * 
--			FROM 
--				NonGUCianStudentRegisterThesis
--				INNER JOIN NonGucianStudent ON NonGUCianStudentRegisterThesis.sid = NonGucianStudent.id
--			)
--			AS allStudents
--			INNER JOIN Supervisor ON allStudents.supid = Supervisor.id
--			INNER JOIN Thesis ON allStudents.serial_no = Thesis.serialNumber
--			WHERE @supervisorID = NonGUCianStudentRegisterThesis.supid
	
--RETURN

GO 
CREATE PROC ViewSupStudentsYears
@supervisorID INT
AS
	SELECT AllStudents.firstname, AllStudents.lastname, AllStudents.years
	from
	(
	SELECT * 
	FROM GUCianStudentRegisterThesis
		INNER JOIN GucianStudent ON GUCianStudentRegisterThesis.sid = GucianStudent.sid
		INNER JOIN Thesis ON GUCianStudentRegisterThesis.serial_no = Thesis.serialNumber
	WHERE GUCianStudentRegisterThesis.supid = @supervisorID
	UNION
	SELECT * 
	FROM NonGUCianStudentRegisterThesis
		INNER JOIN NonGucianStudent ON NonGUCianStudentRegisterThesis.sid = NonGucianStudent.sid
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

-- Update my personal information. DONE QUESTION: SHOULD WE ASSUME ALL VALUES WILL BE AVAIABLE AS INPUTS?
GO
	CREATE PROC UpdateSupProfile
	@supervisorID INT,
	@first_name VARCHAR(20),
	@last_name VARCHAR(20),
	@email VARCHAR(50),
	@faculty VARCHAR(20)
	AS
	UPDATE Supervisor
	SET Supervisor.first_name = @first_name, Supervisor.last_name = @last_name, Supervisor.email = @email, Supervisor.faculty = @faculty
	WHERE Supervisor.id = @supervisorID
RETURN

-- d) View all publications of a student. DONE

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
	@DefenseDate Datetime, 
	@DefenseLocation varchar(15)
	AS
	INSERT INTO DEFENSE (serialNumber ,date , location) VALUES (@ThesisSerialNo, @DefenseDate, @DefenseLocation)
RETURN

-- Add defense for a thesis NONGUCIAN. DONE

GO
	CREATE PROC AddDefenseNonGucian
	@ThesisSerialNo INT,
	@DefenseDate Datetime,
	@DefenseLocation varchar(15)
	AS
	IF (SELECT MIN(grade)
	FROM NonGUCianStudentRegisterThesis
		INNER JOIN NonGucianStudentTakeCourse ON NonGUCianStudentRegisterThesis.sid = NonGucianStudentTakeCourse.sid
	) > 50
	INSERT INTO DEFENSE (serialNumber ,date , location) VALUES (@ThesisSerialNo, @DefenseDate, @DefenseLocation)
RETURN

-- g) Cancel a Thesis if the evaluation of the last progress report is zero. QUESTION : HOW WOULD I DELETE FROM A TABLE WHICH IN JOINED WITH ANOTHER?
GO 
	CREATE PROC CancelThesis
	@ThesisSerialNo INT
	AS
	SELECT Top 1 *
	FROM Thesis
		INNER JOIN GUCianProgressReport ON GUCianProgressReport.thesisSerialNumber = Thesis.serialNumber
		WHERE @ThesisSerialNo = Thesis.serialNumber
	ORDER BY date DESC
RETURN


-- h,f) Add examiner(s) for a defense. QUESTION : ARE H AND F REPEATED OR ARE THEY DIFFERENT SOMEHOW? DONE
GO
-- A FUNCTION WHICH RETURNS THE ID OF THE NEW EXAMINER TO BE USED IN THE FOLLOWING PROCEDURE 
CREATE FUNCTION NewExaminer(
@ExaminerName varchar(20),
@National bit, 
@fieldOfWork varchar(20)
)
RETURNS INT
AS 
BEGIN
	Insert INTO Examiner VALUES (@ExaminerName, @National, @fieldOfWork);
	RETURN (SELECT id
		FROM Examiner
		WHERE name = @ExaminerName AND fieldOfWork = @National AND isNational = @fieldOfWork
	)
END;

-- PROCEDURE WHICH TAKES INPUTS FOR THE ABOVE FUNCTION TO RETURN THE ID FOR THE NEW EXAMINER NEEDED TO INSERT THE NEWEXAMINER TO THE DEFENSE.
GO
CREATE PROC AddExaminer
@ThesisSerialNo int,
@DefenseDate Datetime,
@ExaminerName varchar(20),
@National bit, 
@fieldOfWork varchar(20)
AS
	SELECT NewExaminer(@ExaminerName, @National, @fieldOfWork) NewExaminerId;
	Insert INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES (@DefenseDate, @ThesisSerialNo, NewExaminerId)
RETURN



-- i) QUESTION: WHERE IS THE GRADE INPUT, SHOULDNT THE NAME BE ADDGRADE.
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

-- 6

