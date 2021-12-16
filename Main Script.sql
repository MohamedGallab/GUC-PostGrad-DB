USE PostGradDB;

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
PRINT (@thesesCountOut);

-- e)
EXEC AdminViewStudentThesisBySupervisor;

-- f)
EXEC AdminListNonGucianCourse 2;
-- g)
EXEC AdminUpdateExtension 1;
-- h)
DECLARE @Success BIT;
EXEC AdminIssueThesisPayment 2, 200000, 6, 0, @Success OUTPUT;
-- i)
EXEC AdminViewStudentProfile 1;

-- j)
EXEC AdminIssueInstallPayment 2, '2020-12-01';

DECLARE @no_installments INT = 
		(SELECT Payment.no_installments
		FROM Payment
		WHERE Payment.id = 1)
print(@no_installments)

delete from Installment;

-- k)
EXEC AdminListAcceptPublication;
-- l)
	-- DONE
-- m)
select Thesis.defenseDate
from Thesis
EXEC ViewExamSupDefense '2021-10-07 00:00:00.000';