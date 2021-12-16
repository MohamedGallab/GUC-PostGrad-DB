USE PostGradDB;

GO
CREATE PROC TheInsert

	-- thesis
	@Thesis_field VARCHAR(20),
	@Thesis_type VARCHAR(10),
	@Thesis_title VARCHAR(50),
	@Thesis_startDate DATE,
	@Thesis_endDate DATE,
	@Thesis_grade DECIMAL(5,2),
	@ThesisPayment_amount DECIMAL(8,2),
	@ThesisPayment_noOfInstallments INT,
	@ThesisPayment_fundPercentage DECIMAL(5,2),

	-- student
	@student_firstname VARCHAR(20),
	@student_lastname VARCHAR(20),
	@student_faculty VARCHAR(20),
	@student_address VARCHAR(50),
	@student_email VARCHAR(50),
	@student_password VARCHAR(20),
	@student_isGUCIAN BIT,

	-- phone
	@student_phone VARCHAR(20),

	-- for gucian
	@student_undergradID INT,

	-- supervisor
	@supervisor_firstname VARCHAR(20),
	@supervisor_lastname VARCHAR(20),
	@supervisor_faculty VARCHAR(20),
	@supervisor_address VARCHAR(50),
	@supervisor_email VARCHAR(50),
	@supervisor_password VARCHAR(20),

	-- report
	@report_date DATE,
	@report_eval INT,
	@report_state INT,
	@report_description varchar(200),

	-- courses 
	@course_fees DECIMAL(8,2), -- type ?
	@course_creditHours INT,
	@course_courseCode VARCHAR(10),
	@course_grade DECIMAL(5,2),
	@coursePayment_noOfInstallments INT,
	@coursePayment_fundPercentage DECIMAL(5,2),

	-- defense
	@defense_date DATETIME,
	@defense_location VARCHAR(15),
	@defense_grade DECIMAL(5,2),
	@defense_comments VARCHAR(300),

	-- examiner
	@examiner_name VARCHAR(20),
	@examiner_fieldOfWork VARCHAR(20),
	@examiner_isNational BIT,

	-- publication
	@publication_title VARCHAR(50),
	@publication_date DATETIME,
	@publication_place VARCHAR(50),
	@publication_accepted BIT,
	@publication_host VARCHAR(50)

AS
	

	-- insert thesis
	DECLARE @ThesisID INT;
	INSERT INTO Thesis (field, type, title, startDate, endDate) VALUES (@Thesis_field, @Thesis_type, @Thesis_title, @Thesis_startDate, @Thesis_endDate);
	SET @ThesisID = SCOPE_IDENTITY();
	EXEC AdminUpdateExtension @ThesisID;

	-- add payment
	DECLARE @ThesisPaymentID INT;
	DECLARE @SuccessThesisPayment BIT;
	EXEC AdminIssueThesisPayment @ThesisID,	@ThesisPayment_amount, @ThesisPayment_noOfInstallments, @ThesisPayment_fundPercentage, @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = SCOPE_IDENTITY();

	
	-- register student
	DECLARE @StudentID INT;
	EXEC StudentRegister @student_firstname, @student_lastname, @student_password, @student_faculty, @student_isGUCIAN, @student_email, @student_address;
	SET @StudentID = SCOPE_IDENTITY();

	-- add phone
	EXEC addMobile @StudentID, @student_phone;

	-- register supervisor
	DECLARE @SupervisorID INT;
	EXEC SupervisorRegister @supervisor_firstname, @supervisor_lastname, @supervisor_password, @supervisor_faculty, @supervisor_email;
	SET @SupervisorID = SCOPE_IDENTITY();

	-- add thesis & grade
	IF (@student_isGUCIAN = 1)
	BEGIN
		INSERT INTO GUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);
		EXEC  addUndergradID @StudentID, @student_undergradID;
	END
	ELSE
	BEGIN
		INSERT INTO NonGUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);
	END

	EXEC AddGrade @ThesisID, @Thesis_grade;

	-- add progress report
	DECLARE @ProgressReportNo INT;
	EXEC AddProgressReport @ThesisID, @report_date;
	SET @ProgressReportNo = SCOPE_IDENTITY();

	EXEC FillProgressReport @ThesisID, @ProgressReportNo, @report_state, @report_description;

	EXEC EvaluateProgressReport @SupervisorID, @ThesisID, @ProgressReportNo, @report_eval;

	-- ADDING COURSE --

	DECLARE @CourseID INT;
	EXEC AddCourse @course_courseCode, @course_creditHours, @course_fees;
	SET @CourseID = SCOPE_IDENTITY();

	EXEC linkCourseStudent @CourseID, @StudentID;

	EXEC addStudentCourseGrade @CourseID, @StudentID, @course_grade;

	DECLARE @Fees DECIMAL;
	SELECT @Fees = fees FROM Course WHERE id = @CourseID;

	DECLARE @CoursePaymentId INT;
	INSERT INTO PAYMENT (amount, no_Installments, fundPercentage) VALUES (@Fees, @coursePayment_noOfInstallments, @coursePayment_fundPercentage);
	SET @CoursePaymentId = SCOPE_IDENTITY();

	INSERT INTO NonGucianStudentPayForCourse VALUES (@StudentID, @CoursePaymentId, @CourseID);

	-- ADDING DEFENSE --
	IF (@student_isGUCIAN = 1)
		EXEC AddDefenseGucian @ThesisID, @defense_date, @defense_location;
	ELSE
		EXEC AddDefenseNonGucian @ThesisID, @defense_date, @defense_location;

	-- examiner
	EXEC AddExaminer @ThesisID, @defense_date, @examiner_name, @examiner_isNational, @examiner_fieldOfWork;

	EXEC AddDefenseGrade @ThesisID, @defense_date, @defense_grade;

	EXEC AddCommentsGrade @ThesisID, @defense_date, @defense_comments;

	-- Adding publication

	DECLARE @PubID INT;
	EXEC addPublication @publication_title, @publication_date, @publication_host, @publication_place, @publication_accepted;
	SET @PubID = SCOPE_IDENTITY();
	EXEC linkPubThesis @PubID, @ThesisID;

RETURN