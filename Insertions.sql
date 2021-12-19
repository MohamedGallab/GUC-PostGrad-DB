USE PostGradDB;

-- Insert 2 Admins
	INSERT INTO PostGradUser (email, password) VALUES ('AlbusDumbledoreEmail', 'DumbledorePass');
	INSERT INTO Admin VALUES (IDENT_CURRENT ('PostGradUser'));
	INSERT INTO PostGradUser (email, password) VALUES ('MinervaMcGonagallEmail', 'MinervaPass');
	INSERT INTO Admin VALUES (IDENT_CURRENT ('PostGradUser'));


----------------------- YOUSEF -------------------------------------

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
	EXEC StudentRegister @first_name = 'Neville' , @last_name = 'Longbottom', @password = 'NevilleLongbottomPass',
		@faculty = 'Gryffindor', @Gucian = 1, @email = 'NevilleLongbottomEmail', @address = 'The Leaky Cauldron';
	SET @StudentID = IDENT_CURRENT ('PostGradUser');
	EXEC addUndergradID @studentID = @StudentID, @undergradID = 0710;

	UPDATE GucianStudent set GPA = 3.85;

	-- phones
	EXEC addMobile @ID = @StudentID, @mobile_number = '01097123419';
	EXEC addMobile @ID = @StudentID, @mobile_number = '01123583732';

	-- thesis 1, 2 reports, 2 defenses, 1 pub
	-- thesis 1 & grade
	INSERT INTO Thesis (field, type, title, startDate, endDate, noExtension) VALUES ('Charms', 'Masters', 'Patronus', '2011-07-11', '2014-08-03', 0);
	SET @ThesisID = IDENT_CURRENT ('Thesis');

	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 50000, @noOfInstallments = 2,
		@fundPercentage = 100, @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2011-08-11';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) VALUES(@StudentID, @SupervisorID ,@ThesisID);
	
	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 80.00;

	-- 2 progress reports
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2012-01-21';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 50, @description = 'Defintion for the patronus charm';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 3;
	--
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2013-06-06';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 100, @description = 'More info about the patronus charm';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 2;

	-- defenses and publications
	-- 2 defenses
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2012-05-09', @DefenseLocation = 'Gryffindor Tower, Hogwarts';
	EXEC AddExaminer @ThesisSerialNo = @ThesisID, @DefenseDate = '2012-05-09', @ExaminerName = 'Rolanda Hooch', @National = 1, @fieldOfWork = 'Flying';
	set @examiner_id1 = IDENT_CURRENT ('PostGradUser');
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2012-05-09', @grade = 95.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2012-05-09', @examinerId = @examiner_id1, @comments = 'More info is needed';

	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2013-08-09', @DefenseLocation = 'Dumbledore Office Tower';
	EXEC AddExaminer @ThesisSerialNo = @ThesisID, @DefenseDate = '2013-08-09', @ExaminerName = 'Dolores Umbridge', @National = 0, @fieldOfWork = 'fieldOfWork';
	set @examiner_id2 = IDENT_CURRENT ('PostGradUser');
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2013-08-09', @grade = 97.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2013-08-09', @examinerId = @examiner_id2, @comments = 'Perfect Job';

	EXEC addPublication @title = 'Relations of the Patronus', @pubDate = '2013-11-10', @host = 'Dumbledore', @place = 'Divination', @accepted = 1;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;



	-- thesis 2 with 1 progress report
	INSERT INTO Thesis (field, type, title, startDate, endDate, noExtension) VALUES ('Dark Arts Defence', 'PHD', 'The Cruciatus Curse', '2019-07-03', '2022-01-09', 0);
	SET @ThesisID = IDENT_CURRENT ('Thesis');

	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 100, @noOfInstallments = 3,
		@fundPercentage = 75, @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2020-01-01';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	INSERT INTO GUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);

	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 100.00;

	-- 1 progress report
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2020-01-03';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 50, @description = 'How does the Cruciatus curse effect the brain?';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 2;

	-- 1 defenses with old examiners and publication
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2020-06-09', @DefenseLocation = 'Ravenclaw Tower';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2020-06-09', @ThesisID, @examiner_id1);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2020-06-09', @grade = 75.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2020-06-09', @examinerId = @examiner_id1, @comments = 'Lacks the magical info';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2020-06-09', @ThesisID, @examiner_id2);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2020-06-09', @grade = 90.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2020-06-09', @examinerId = @examiner_id2, @comments = 'Accurate info medical wise';

	EXEC addPublication @title = 'Effect of the Cruciatus curse', @pubDate = '2021-05-07', @host = 'Hedwig', @place = 'Owlery', @accepted = 0;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;

	-------------------------

	-- Nongucian Student with 1 phones and 1 thesis and 1 progress reports and 1 defenses
	EXEC StudentRegister @first_name = 'Luna' , @last_name = 'Lovegood',@password = 'LunaLovegoodPass',
	@faculty = 'Ravenclaw', @Gucian = 0, @email = 'LunaLovegoodEmail', @address = 'The Lovegood House';
	SET @StudentID = IDENT_CURRENT ('PostGradUser');

	UPDATE NonGucianStudent set GPA = 3.50;

	-- phones
	EXEC addMobile @ID = @StudentID, @mobile_number = '01002124331';

	-- thesis 1, 2 reports, 2 defenses, 1 pub
	-- thesis 1 & grade
	INSERT INTO Thesis (field, type, title, startDate, endDate, noExtension) VALUES ('Potions', 'PHD', 'Felix Felicis', '2020-11-11', '2023-09-04', 0);
	SET @ThesisID = IDENT_CURRENT ('Thesis');


	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 100, @noOfInstallments = 3,
	@fundPercentage = 75, @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2020-12-11';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	INSERT INTO NonGUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);

	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 99.00;

	-- 1 progress reports
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2021-01-05';
	SET @ProgressReportNum = IDENT_CURRENT ('NonGUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 50, @description = 'Liquid luck and its effect on the real world';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 0;

	-- ADDING COURSE --

	
	EXEC AddCourse @courseCode = 'Transfiguration 101', @creditHrs = 8, @fees = 100999;
	SET @CourseID = IDENT_CURRENT('Course');

	EXEC linkCourseStudent @courseID = @CourseID, @studentID = @StudentID;

	EXEC addStudentCourseGrade @courseID = @CourseID, @studentID = @StudentID, @grade = 75.0;

	
	SELECT @Fees = fees FROM Course WHERE id = @CourseID;
	
	INSERT INTO PAYMENT (amount, no_Installments, fundPercentage) VALUES (@Fees, 4, 100);
	SET @CoursePaymentId = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @CoursePaymentId, @InstallStartDate = '2021-04-07';

	INSERT INTO NonGucianStudentPayForCourse VALUES (@StudentID, @CoursePaymentId, @CourseID);

	-- defenses and publications
	-- 1 defenses
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-08', @DefenseLocation = 'Astronomy Tower';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2021-12-08', @ThesisID, @examiner_id1);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-08', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2021-12-08', @examinerId = @examiner_id1, @comments = 'Well presented';


	EXEC addPublication @title = 'The Luck by Liquid Luck', @pubDate = '2022-07-07', @host = 'Sybill Trelawney', @place = 'Astronomy Tower', @accepted = 1;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;
GO

----------------------- WAGDY -------------------------------------

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
	EXEC SupervisorRegister @first_name = 'kakashi', @last_name = 'hatake', @password = 'copycat', @faculty = 'jonin', @email = 'iStoleMySharingan@gmail.com';
	SET @SupervisorID = IDENT_CURRENT ('PostGradUser');

	-- gucian Studnet with 2 phones and 2 thesis and 3 progress reports and 3 defenses
	EXEC StudentRegister @first_name = 'naruto' , @last_name = 'uzumaki', @password = 'dattebayo!',
		@faculty = 'genin', @Gucian = 1, @email = 'sasukePlsComeback@gmail.com', @address = 'some trash appartement';
	SET @StudentID = IDENT_CURRENT ('PostGradUser');
	EXEC  addUndergradID @studentID = @StudentID, @undergradID = 111;

	UPDATE GucianStudent set GPA = 4.00;

	-- phones
	EXEC addMobile @ID = @StudentID, @mobile_number = '07778000454';
	EXEC addMobile @ID = @StudentID, @mobile_number = '01020039955';

	-- thesis 1, 2 reports, 2 defenses, 1 pub
	-- thesis 1 & grade
	INSERT INTO Thesis (field, type, title, startDate, endDate, noExtension) VALUES ('ninjutsu', 'masters', 'shadow clone jutsu!', '2020-6-03', '2022-07-08', 0);
	SET @ThesisID = IDENT_CURRENT ('Thesis');

	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 50000, @noOfInstallments = 4,
		@fundPercentage = 100, @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2020-12-01';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) VALUES(@StudentID, @SupervisorID ,@ThesisID);
	
	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 100.00;

	-- 2 progress reports
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2021-07-01';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 50, @description = 'this is the description of how i stole my main jutsu lol';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 3;
	--
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2022-03-06';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 100, @description = 'i think i almost got it,just need to try it a few more times';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 2;

	-- defenses and publications
	-- 2 defenses
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-06-09', @DefenseLocation = 'class';
	EXEC AddExaminer @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-06-09', @ExaminerName = 'iruka umino', @National = 0, @fieldOfWork = 'academy teacher';
	set @examiner_id2 = IDENT_CURRENT ('PostGradUser');
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-06-09', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-06-09', @examinerId = @examiner_id2, @comments = 'how did you learn a forbidden jutsu literally 10 minutes apart in the same episode...you kinda sus';

	
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-04-20', @DefenseLocation = 'chunin exams arena';
	EXEC AddExaminer @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-04-20', @ExaminerName = 'hayate gekko', @National = 1, @fieldOfWork = 'proctor';
	set @examiner_id1 = IDENT_CURRENT ('PostGradUser');
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-04-20', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-04-20', @examinerId = @examiner_id1, @comments = 'this dude literally stole the forbidden scroll and he aint sorry about it';

	EXEC addPublication @title = 'my ninja way', @pubDate = '2022-11-19', @host = 'konoha news', @place = 'konoha', @accepted = 1;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;



	-- thesis 2 with 1 progress report
	INSERT INTO Thesis (field, type, title, startDate, endDate, noExtension) VALUES ('ninjutsu', 'Phd', 'rasengaaaan!', '2020-01-01', '2023-01-01', 0);
	SET @ThesisID = IDENT_CURRENT ('Thesis');

	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 100000, @noOfInstallments = 3,
		@fundPercentage = 75, @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2020-05-01';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	INSERT INTO GUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);

	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 100.00;

	-- 1 progress report
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2021-05-01';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 50, @description = 'my throat is starting to hurt cause i scream too hard when i do the jutsu';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 3;

	-- 1 defenses with old examiners and publication
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-6-09', @DefenseLocation = 'training grounds';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2022-6-09', @ThesisID, @examiner_id1);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-6-09', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-6-09', @examinerId = @examiner_id1, @comments = 'at least this one isnt stolen...or is it???';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2022-6-09', @ThesisID, @examiner_id2);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-6-09', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2022-6-09', @examinerId = @examiner_id2, @comments = 'this dude went from creating dead clones to creating a mini nuke...what klnda steroids you on ,kid?';

	EXEC addPublication @title = 'maybe i am not a one-trick after all', @pubDate = '2023-07-07', @host = 'konoha news', @place = 'konoha', @accepted = 1;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;

	-------------------------

	-- none gucian Studnet with 1 phones and 1 thesis and 1 progress reports and 1 defenses
	EXEC StudentRegister @first_name = 'boruto' , @last_name = 'uzumaki',@password = 'iUsedToHateMyDad',
	@faculty = 'genin', @Gucian = 0, @email = 'noticeMeDad@gmail.com', @address = 'i live with the hokage boiiii';
	SET @StudentID = IDENT_CURRENT ('PostGradUser');

	UPDATE NonGucianStudent set GPA = 3.00;

	-- phones
	EXEC addMobile @ID = @StudentID, @mobile_number = '01924999224';

	-- thesis 1, 2 reports, 2 defenses, 1 pub
	-- thesis 1 & grade
	INSERT INTO Thesis (field, type, title, startDate, endDate, noExtension) VALUES ('ninjutsu', 'masters', 'learning rasengan so sasuke notices me', '2020-02-01', '2023-05-01', 0);
	SET @ThesisID = IDENT_CURRENT ('Thesis');


	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 120000, @noOfInstallments = 3,
	@fundPercentage = 75, @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2020-04-01';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	INSERT INTO NonGUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);

	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 100.00;

	-- 1 progress reports
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2021-01-01';
	SET @ProgressReportNum = IDENT_CURRENT ('NonGUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 50, @description = 'i just created a rasengan the size of a pea and i am proud';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 3;

	-- ADDING COURSE --

	
	EXEC AddCourse @courseCode = 'nin501', @creditHrs = 8, @fees = 100999;
	SET @CourseID = IDENT_CURRENT('Course');

	EXEC linkCourseStudent @courseID = @CourseID, @studentID = @StudentID;

	EXEC addStudentCourseGrade @courseID = @CourseID, @studentID = @StudentID, @grade = 100.0;

	
	SELECT @Fees = fees FROM Course WHERE id = @CourseID;
	
	INSERT INTO PAYMENT (amount, no_Installments, fundPercentage) VALUES (@Fees, 4, 100);
	SET @CoursePaymentId = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @CoursePaymentId, @InstallStartDate = '2021-01-01';

	INSERT INTO NonGucianStudentPayForCourse VALUES (@StudentID, @CoursePaymentId, @CourseID);

	-- defenses and publications
	-- 1 defenses
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2023-01-09', @DefenseLocation = 'training grounds';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2023-01-09', @ThesisID, @examiner_id1);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2023-01-09', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2023-01-09', @examinerId = @examiner_id1, @comments = 'ok maybe he isnt just a spoiled kid after all';


	EXEC addPublication @title = 'sasuke finally noticed me', @pubDate = '2023-07-07', @host = 'konoha modern news', @place = 'konoha', @accepted = 1;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;
GO

----------------------- MAHMOUD -------------------------------------

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
	EXEC SupervisorRegister @first_name = 'Natalie', @last_name = 'Wynn', @password = 'Darkm321@@', @faculty = 'Philosiphy', @email = 'contrapoints@gmail.com';
	SET @SupervisorID = IDENT_CURRENT ('PostGradUser');

	-- gucian Studnet with 2 phones and 2 thesis and 3 progress reports and 3 defenses
	EXEC StudentRegister @first_name = 'Abd Elghafour' , @last_name = 'El Boray', @password = 'Biro102030',
		@faculty = 'Philosiphy', @Gucian = 1, @email = 'barbora@gmail.com', @address = 'Wekalet El balah, St 1, Apt 3';
	SET @StudentID = IDENT_CURRENT ('PostGradUser');
	EXEC  addUndergradID @studentID = @StudentID, @undergradID = 111;

	UPDATE GucianStudent set GPA = 3.0;

	-- phones
	EXEC addMobile @ID = @StudentID, @mobile_number = '01066554412';
	EXEC addMobile @ID = @StudentID, @mobile_number = '01132654512';

	-- thesis 1, 2 reports, 2 defenses, 1 pub
	-- thesis 1 & grade
	INSERT INTO Thesis (field, type, title, startDate, endDate, noExtension) VALUES ('Philosiphy', 'Phd', 'Effects of catgrils on the psyche of the fragile', '2021-11-10', '2023-11-10', 0);
	SET @ThesisID = IDENT_CURRENT ('Thesis');

	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 150000, @noOfInstallments = 3,
		@fundPercentage = 50, @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2021-11-01';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) VALUES(@StudentID, @SupervisorID ,@ThesisID);
	
	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 40.00;

	-- 2 progress reports
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2022-01-07';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 50, @description = 'So far, Venician catgirls seem to ellicit the highest reaction in our subjects';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 5;
	--
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2022-02-08';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 70, @description = 'In our recent research, it has been concluded that otakus are into all kinds of catgirls. Disgusting.';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 1;

	-- defenses and publications
	-- 2 defenses
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2023-01-01', @DefenseLocation = 'Court Room';
	EXEC AddExaminer @ThesisSerialNo = @ThesisID, @DefenseDate = '2023-01-01', @ExaminerName = 'Abigaul Thorne', @National = 0, @fieldOfWork = 'Philosiphy';
	set @examiner_id1 = IDENT_CURRENT ('PostGradUser');
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2023-01-01', @grade = 0.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2023-01-01', @examinerId = @examiner_id1, @comments = 'Its abhorent to say that catgirls are disgusting';

	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2024-01-01', @DefenseLocation = 'Court Room';
	EXEC AddExaminer @ThesisSerialNo = @ThesisID, @DefenseDate = '2024-01-01', @ExaminerName = 'Berni', @National = 1, @fieldOfWork = 'Chocolate';
	set @examiner_id2 = IDENT_CURRENT ('PostGradUser');
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2024-01-01', @grade = 70.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2024-01-01', @examinerId = @examiner_id2, @comments = 'Meh';

	EXEC addPublication @title = 'Catgirls and Otakus', @pubDate = '2024-02-02', @host = 'Times', @place = 'The web', @accepted = 0;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;



	-- thesis 2 with 1 progress report
	INSERT INTO Thesis (field, type, title, startDate, endDate, noExtension) VALUES ('Sharks', 'Master', 'Sharks Swim or no?', '2030-09-11', '2033-08-08', 0);
	SET @ThesisID = IDENT_CURRENT ('Thesis');

	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 50, @noOfInstallments = 3,
		@fundPercentage = 75, @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2040-01-01';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	INSERT INTO GUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);

	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 90.00;

	-- 1 progress report
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2031-01-01';
	SET @ProgressReportNum = IDENT_CURRENT ('GUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 20, @description = 'So far sharks do seem to swim';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 1;

	-- 1 defenses with old examiners and publication
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2034-01-01', @DefenseLocation = 'Tank';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2034-01-01', @ThesisID, @examiner_id1);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2034-01-01', @grade = 90.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2034-01-01', @examinerId = @examiner_id1, @comments = 'Sharks indeed look like they are swimming';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2034-01-01', @ThesisID, @examiner_id2);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2034-01-01', @grade = 95.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2034-01-01', @examinerId = @examiner_id2, @comments = 'Sharks Swim! WOW!';

	EXEC addPublication @title = 'Sharks swim', @pubDate = '2034-01-02', @host = 'AquaNews', @place = 'Ocean', @accepted = 1;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;

	-------------------------

	-- none gucian Studnet with 1 phones and 1 thesis and 1 progress reports and 1 defenses
	EXEC StudentRegister @first_name = 'Fatma' , @last_name = 'Koshary',@password = 'aTGAs$!@gA',
	@faculty = 'MET', @Gucian = 0, @email = 'fatma.koshary@guc.edu.eg', @address = 'Wekalet ElBalah,St1,Apt2';
	SET @StudentID = IDENT_CURRENT ('PostGradUser');

	UPDATE NonGucianStudent set GPA = 0.8;

	-- phones
	EXEC addMobile @ID = @StudentID, @mobile_number = '01099654321';

	-- thesis 1, 2 reports, 2 defenses, 1 pub
	-- thesis 1 & grade
	INSERT INTO Thesis (field, type, title, startDate, endDate, noExtension) VALUES ('CS', 'Masters', 'Interuppt commands in CPU', '2024-03-04', '2026-01-01', 0);
	SET @ThesisID = IDENT_CURRENT ('Thesis');


	EXEC AdminIssueThesisPayment @ThesisSerialNo = @ThesisID, @amount = 40, @noOfInstallments = 3,
	@fundPercentage = 100, @Success = @SuccessThesisPayment OUTPUT;
	SET @ThesisPaymentID = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @ThesisPaymentID, @InstallStartDate = '2024-03-04';

	EXEC AdminUpdateExtension @ThesisID;
	EXEC AdminUpdateExtension @ThesisID;

	INSERT INTO NonGUCianStudentRegisterThesis VALUES(@StudentID, @SupervisorID ,@ThesisID);

	EXEC AddGrade @ThesisSerialNo = @ThesisID, @ThesisGrade = 99.00;

	-- 1 progress reports
	EXEC AddProgressReport @thesisSerialNo = @ThesisID, @progressReportDate = '2025-01-01';
	SET @ProgressReportNum = IDENT_CURRENT ('NonGUCianProgressReport');

	EXEC FillProgressReport @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @state = 70, @description = 'Has been successful in re impleminting interrupt commands in Intel processors, resulting in 700% faster CPUs';

	EXEC EvaluateProgressReport @supervisorID = @SupervisorID, @thesisSerialNo = @ThesisID, @progressReportNo = @ProgressReportNum, @evaluation = 3;

	-- ADDING COURSE --

	
	EXEC AddCourse @courseCode = 'CSEN901', @creditHrs = 6, @fees = 10000;
	SET @CourseID = IDENT_CURRENT('Course');

	EXEC linkCourseStudent @courseID = @CourseID, @studentID = @StudentID;

	EXEC addStudentCourseGrade @courseID = @CourseID, @studentID = @StudentID, @grade = 98.0;

	
	SELECT @Fees = fees FROM Course WHERE id = @CourseID;
	
	INSERT INTO PAYMENT (amount, no_Installments, fundPercentage) VALUES (@Fees, 3, 100);
	SET @CoursePaymentId = IDENT_CURRENT ('Payment');
	EXEC AdminIssueInstallPayment @paymentID = @CoursePaymentId, @InstallStartDate = '2025-01-01';

	INSERT INTO NonGucianStudentPayForCourse VALUES (@StudentID, @CoursePaymentId, @CourseID);

	-- defenses and publications
	-- 1 defenses
	EXEC AddDefenseGucian @ThesisSerialNo = @ThesisID, @DefenseDate = '2026-01-01', @DefenseLocation = 'C1';

	INSERT INTO ExaminerEvaluateDefense (date, serialNo, examinerId) VALUES ('2026-01-01', @ThesisID, @examiner_id1);
	EXEC AddDefenseGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2026-01-01', @grade = 100.00;
	EXEC AddCommentsGrade @ThesisSerialNo = @ThesisID, @DefenseDate = '2026-01-01', @examinerId = @examiner_id1, @comments = 'Wonderful';


	EXEC addPublication @title = 'CPU Interuppts', @pubDate = '2026-05-01', @host = 'CNN', @place = 'Internet', @accepted = 1;
	SET @Pub_ID = IDENT_CURRENT ('Publication');
	EXEC linkPubThesis @PubID = @Pub_ID, @thesisSerialNo = @ThesisID;
GO

UPDATE Installment SET done = 1 WHERE date < '2021-01-01';