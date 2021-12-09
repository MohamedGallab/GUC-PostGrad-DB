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

-- f)

-- g)

-- h)