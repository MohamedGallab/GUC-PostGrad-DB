USE PostGradDB;

-- 1

-- a)

-- i) student
	EXEC StudentRegister 'Abd El Ghafour', 'El Boray', '123456','MET',1,'barbora@gmail.com','Wekalet El Balah, St 2, Apt 5';
	EXEC StudentRegister 'Fatma', 'Koshary', 'as@45asfg%!gAGAs','Pharmacy',0,'zawgatabdelghafourelboray@yahoo.com','Wekalet El Balah, St 2, Apt 5';

-- ii) supervisor
	EXEC SupervisorRegister 'Tenen', 'Elkemya', 'loveChemistry33&','Pharmacy', 'ahmedabdelwaged@hotmail.com';

-- 2

-- a)
	-- correct password
	DECLARE @Success BIT;
	EXEC userLogin '1','wrongPassword', @Success OUTPUT;
	print(@Success);

	-- false password
	DECLARE @Success BIT;
	EXEC userLogin '1','DumbledorePass', @Success OUTPUT;
	PRINT(@Success);

-- b) 
	-- gucian
	EXEC addMobile '4', '01020304050';
	-- nongucian
	EXEC addMobile '7', '01020304055';

-- 3

-- a)
	EXEC AdminListSup;

-- b)
	EXEC AdminViewSupervisorProfile @supId = 3;

-- c)
	EXEC AdminViewAllTheses;

-- d)
	DECLARE @thesesCountOut INT;
	EXEC AdminViewOnGoingTheses @thesesCount = @thesesCountOut OUTPUT;
	PRINT @thesesCountOut;
-- e)
	EXEC AdminViewStudentThesisBySupervisor;

-- f)
	EXEC AdminListNonGucianCourse 1;

-- g)
	EXEC AdminUpdateExtension @ThesisSerialNo = 1;

-- h)
	-- successful
	DECLARE @SuccessOut BIT;
	EXEC AdminIssueThesisPayment @ThesisSerialNo = 1, @amount = 9900, @noOfInstallments = 3, @fundPercentage = 25, @Success = @SuccessOut OUTPUT;
	PRINT @SuccessOut
	
	-- unsuccessful
	DECLARE @SuccessOut BIT;
	EXEC AdminIssueThesisPayment @ThesisSerialNo = 1000000000000, @amount = 9900, @noOfInstallments = 3, @fundPercentage = 25, @Success = @SuccessOut OUTPUT;
	PRINT @SuccessOut

-- i)
	-- gucian
	EXEC AdminViewStudentProfile @sid = 4;

	-- non gucian
	EXEC AdminViewStudentProfile @sid = 7;

-- j) --add an extra test payment
	EXEC AdminIssueInstallPayment @paymentID = 2, @InstallStartDate = '2020-12-01';

-- k) --add thesis with 2 publications accepted
	EXEC AdminListAcceptPublication;
	

-- l)
	EXEC AddCourse @courseCode = 'CSEN 501', @creditHrs = 8, @fees = 12000

	EXEC linkCourseStudent @courseID = 1, @studentID = 1

	EXEC addStudentCourseGrade @courseID = 1, @studentID = 1, @grade = 100.0

-- m)
	EXEC ViewExamSupDefense '2012-05-09';

-- 4
-- a)
	EXEC EvaluateProgressReport 13, 7, 7, 0;

	EXEC EvaluateProgressReport 3, 3, 1, 0;

-- b)
	EXEC ViewSupStudentsYears 3;

-- c)
	EXEC SupViewProfile 3;

	EXEC UpdateSupProfile 3, 'StillRemus', 'ALWAYSGRYF';

-- d)
	EXEC ViewAStudentPublications 14;

	EXEC ViewAStudentPublications 7;

-- e)
	EXEC AddDefenseGucian 1, '10/7/2021', 'Cairo';

	EXEC AddDefenseNonGucian 3, '12/17/2021', 'Berlin';

-- f)
	EXEC AddExaminer 1, '10/7/2021 12:00:00 AM', 'Albus', 1, 'Master of Death';

-- g)
	EXEC EvaluateProgressReport 13, 8, 9, 0;
	EXEC CancelThesis 8;

-- h)
	EXEC AddGrade 1, 4;

-- 5) 

-- a)

EXEC AddDefenseGrade 1, '2020/12/9 12:12:12', 5.2;

-- b)
INSERT Into ExaminerEvaluateDefense (date,serialNo,examinerId) values ('2020/12/9 12:12:12',1,19)
EXEC AddCommentsGrade 1,'2020/12/9 12:12:12',19, 'very very very very bad'
select* from ExaminerEvaluateDefense



--6)
--a)
EXEC viewMyProfile 9
EXEC viewMyProfile 12
--b)
EXEC editMyProfile 9, 'lord', 'seventh', 'finallyHokage', 'rasenganAndDhadowGotMeHere@gmail.com', ' The uzumaki residence', 'Phd'
--c)
EXEC addUndergradID 9, '4923423'
--d)
EXEC ViewCoursesGrades 12
--e
	--i)
	EXEC ViewCoursePaymentsInstall 12 --non gucian so it gives data
	EXEC ViewCoursePaymentsInstall 9  --gucian so no output
	--ii)
	EXEC ViewThesisPaymentsInstall 9 --gucian
	EXEC ViewThesisPaymentsInstall 12 --non gucian (doesnt make a difference but both cases anyways)
	
	--iii)
	EXEC ViewUpcomingInstallments 9 --gucian
	EXEC ViewUpcomingInstallments 12 --non gucian (doesnt make a difference but both cases anyways)
	--iv)
	EXEC ViewMissedInstallments 9 --gucian	
	EXEC ViewMissedInstallments 12 --non gucian (doesnt make a difference but both cases anyways)
--f
	--i)
	EXEC AddProgressReport 5, '2022-11-09'
	--ii)
	EXEC FillProgressReport 5, 4, 75, 'i am gonna pass out cause this uses more chakra than what i get from the ramen'
--g)
EXEC ViewEvalProgressReport 6, 1
--h)
EXEC addPublication 'i think i did it too well,they wanna make me hokage now' ,'2024-07-07' ,'konoha news' ,'konoha' ,1
--i)
EXEC linkPubThesis 10, 5
