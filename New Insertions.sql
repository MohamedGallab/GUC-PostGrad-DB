USE PostGradDB;

-- Insert 2 Admins
	INSERT INTO PostGradUser (email, password) VALUES ('AlbusDumbledoreEmail', 'DumbledorePass');
	INSERT INTO PostGradUser (email, password) VALUES ('MinervaMcGonagallEmail', 'MinervaPass');

GO
	-- all declares
	DECLARE @ThesisID INT;
	DECLARE @ThesisPaymentID INT;
	DECLARE @SupervisorID INT;
	DECLARE @StudentID INT;
	DECLARE @SuccessThesisPayment BIT;
	DECLARE @ProgressReportNum INT;
	DECLARE @examiner_id1 INT;
	DECLARE @examiner_id2 INT;
	DECLARE @Pub_ID INT;
	DECLARE @CourseID INT;
	DECLARE @Fees DECIMAL;
	DECLARE @CoursePaymentId INT;

	-- 1 supervisor, 2 students, 3 phone numbers, 3 thesis, 4 progress reports, 4 defenses, 2 examiners, 2 courses, 3 publictaions

	-- supervisor
	EXEC SupervisorRegister @first_name = 'Remus', @last_name = 'Lupin', @password = 'RemusLupinPass', @faculty = 'Gryffindor', @email = 'RemusLupinEmail';
	SET @SupervisorID = IDENT_CURRENT ('PostGradUser');

	-- gucian Studnet with 2 phones and 2 thesis and 3 progress reports and 3 defenses
	EXEC StudentRegister @first_name = 'Harry' , @last_name = 'Potter',@password = 'HarryPotterPass',
		@faculty = 'Gryffindor', @Gucian = 1, @email = 'HarryPotterPassEmail', @address = '4 Privet Drive';
	SET @StudentID = IDENT_CURRENT ('PostGradUser');
	EXEC  addUndergradID @studentID = @StudentID, @undergradID = 111;

	-- phones
	EXEC addMobile @ID = @StudentID, @mobile_number = 'Harry Mobile 1';
	EXEC addMobile @ID = @StudentID, @mobile_number = 'Harry Mobile 2';

	-- thesis 1, 2 reports, 2 defenses, 1 pub
	-- thesis 1 & grade
	INSERT INTO Thesis (field, type, title, startDate, endDate) VALUES ('field', 'type', 'title', '2020-01-01', '2021-01-01');
	SET @ThesisID = IDENT_CURRENT ('Thesis');

	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 50000, @noOfInstallments = 2,
		@fundPercentage = 100, @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2020-01-01';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	print (@StudentID);
	print (@SupervisorID);
	print (@ThesisID);

	INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) VALUES(@StudentID, @SupervisorID ,@ThesisID);
	
	print (@StudentID);
	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 100.00;

	-- 2 progress reports
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2021-01-01';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 50, @description = 'this is description 1';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 3;
	--
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2021-06-06';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 100, @description = 'this is description 2';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 2;

	-- defenses and publications
	-- 2 defenses
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-06-09', @DefenseLocation = 'DefenseLocation';
	EXEC AddExaminer @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-06-09', @ExaminerName = 'ExaminerName', @National = 1, @fieldOfWork = 'fieldOfWork';
	set @examiner_id1 = IDENT_CURRENT ('PostGradUser');
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-06-09', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-06-09', @examinerId = @examiner_id1, @comments = 'comments';

	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @DefenseLocation = 'DefenseLocation';
	EXEC AddExaminer @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @ExaminerName = 'ExaminerName', @National = 0, @fieldOfWork = 'fieldOfWork';
	set @examiner_id2 = IDENT_CURRENT ('PostGradUser');
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @examinerId = @examiner_id2, @comments = 'comments';

	EXEC addPublication @title = 'title', @pubDate = '2021-11-19', @host = 'host', @place = 'place', @accepted = 1;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;



	-- thesis 2 with 1 progress report
	INSERT INTO Thesis (field, type, title, startDate, endDate) VALUES ('field', 'type', 'title', '2020-01-01', 'endDate');
	SET @ThesisID = IDENT_CURRENT ('Thesis');

	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 'amount', @noOfInstallments = 'noOfInstallments',
	@fundPercentage = 'fundPercentage', @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2020-01-01';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	INSERT INTO GUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);

	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 100.00;

	-- 1 progress report
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2021-01-01';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 50, @description = 'this is description 1';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 3;

	-- 1 defenses with old examiners and publication
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @DefenseLocation = 'DefenseLocation';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2021-12-09', @ThesisID, @examiner_id1);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @examinerId = @examiner_id1, @comments = 'comments';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2021-12-09', @ThesisID, @examiner_id2);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @examinerId = @examiner_id2, @comments = 'comments';

	EXEC addPublication @title = 'title', @pubDate = 'pubDateTime', @host = 'host', @place = 'place', @accepted = 1;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;

	-------------------------

	-- none gucian Studnet with 1 phones and 1 thesis and 1 progress reports and 1 defenses
	EXEC StudentRegister @first_name = 'Harry' , @last_name = 'Potter',@password = 'HarryPotterPass',
	@faculty = 'Gryffindor', @Gucian = 1, @email = 'HarryPotterPassEmail', @address = '4 Privet Drive';
	SET @StudentID = IDENT_CURRENT ('PostGradUser');

	-- phones
	EXEC addMobile @ID = @StudentID, @mobile_number = 'Harry Mobile 1';

	-- thesis 1, 2 reports, 2 defenses, 1 pub
	-- thesis 1 & grade
	INSERT INTO Thesis (field, type, title, startDate, endDate) VALUES ('field', 'type', 'title', '2020-01-01', 'endDate');
	SET @ThesisID = IDENT_CURRENT ('Thesis');

	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 'amount', @noOfInstallments = 'noOfInstallments',
	@fundPercentage = 'fundPercentage', @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2020-01-01';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	INSERT INTO NonGUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);

	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 100.00;

	-- 1 progress reports
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2021-01-01';
	SET @ProgressReportNum = IDENT_CURRENT ('NonGUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 50, @description = 'this is description 1';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 3;

	-- ADDING COURSE --

	
	EXEC AddCourse @courseCode = 'Code', @creditHrs = 8, @fees = 100999;
	SET @CourseID = IDENT_CURRENT('Course');

	EXEC linkCourseStudent @courseID = @CourseID, @studentID = @StudentID;

	EXEC addStudentCourseGrade @courseID = @CourseID, @studentID = @StudentID, @grade = 100.0;

	
	SELECT @Fees = fees FROM Course WHERE id = @CourseID;
	
	INSERT INTO PAYMENT (amount, no_Installments, fundPercentage) VALUES (@Fees, 4, 100);
	SET @CoursePaymentId = IDENT_CURRENT ('Payment');

	EXEC AdminIssueInstallPayment @paymentID = @CoursePaymentId, @InstallStartDate = '2020-01-01';

	INSERT INTO NonGucianStudentPayForCourse VALUES (@StudentID, @CoursePaymentId, @CourseID);

	-- defenses and publications
	-- 1 defenses
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @DefenseLocation = 'DefenseLocation';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2021-12-09', @ThesisID, @examiner_id1);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-09', @examinerId = @examiner_id1, @comments = 'comments';


	EXEC addPublication @title = 'title', @pubDate = 'pubDateTime', @host = 'host', @place = 'place', @accepted = 1;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;
GO