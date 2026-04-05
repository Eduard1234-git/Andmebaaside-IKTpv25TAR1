CREATE DATABASE praktikabas;
use praktikabas;
CREATE TABLE firma(
    firmaID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    firmanimi VARCHAR(20),
    aadress VARCHAR(20),
    telefon VARCHAR(20)
);



CREATE TABLE praktikajuhendaja(
    praktikajuhendajaID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    eesnimi VARCHAR(50),
    perekonnanimi VARCHAR(50),
    synniaeg DATE,
    telefon VARCHAR(20)
);

CREATE TABLE praktikabaas(
    praktikabaasID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    firmaID INT,
    praktikatingimused VARCHAR(100),
    arvutiprogramm VARCHAR(50),
    juhendajaID INT,
    FOREIGN KEY (firmaID) REFERENCES firma(firmaID),
    FOREIGN KEY (juhendajaID) REFERENCES praktikajuhendaja(praktikajuhendajaID)
);

select * from firma
select * from praktikajuhendaja
select * from praktikabaas

INSERT INTO firma (firmanimi, aadress, telefon) VALUES 
('IT-Keskus', 'Tallinn 1', '555111'),
('WebSolutions', 'Tartu 5', '555222'),
('DataSystems', 'Narva 10', '555333'),
('Apple-X', 'Pärnu 2', '555444'),
('Alpha Beta', 'Tallinn 3', '555555');

INSERT INTO praktikajuhendaja (eesnimi, perekonnanimi, synniaeg, telefon) VALUES 
('Jüri', 'Tamm', '1985-09-15', '444111'), 
('Mari', 'Kask', '1990-10-20', '444222'), 
('Ivan', 'Ivanov', '1982-11-05', '444333'), 
('Peeter', 'Oja', '1975-03-12', '444444'),
('Anna', 'Sepp', '1995-06-25', '444555');

INSERT INTO praktikabaas (firmaID, praktikatingimused, arvutiprogramm, juhendajaID) VALUES 
(1, 'Hea kontor', 'VS Code', 1),
(1, 'Kaugpöö', 'Python', 2),
(2, 'Lauaarvuti', 'SQL Server', 3),
(3, 'Tasuta lõuna', 'IntelliJ', 4),
(5, 'Modernne', 'Excel', 5);

SELECT * FROM firma
WHERE firmanimi LIKE '%a%';

SELECT *
FROM praktikabaas, firma
WHERE firma.firmaID = praktikabaas.firmaID
ORDER BY firmanimi;

SELECT firmanimi, COUNT(praktikabaasID) AS kogus
FROM praktikabaas, firma
WHERE firma.firmaID = praktikabaas.firmaID
GROUP BY firmanimi;

SELECT *
FROM praktikajuhendaja
WHERE MONTH(synniaeg) IN (9, 10, 11);

SELECT eesnimi, perekonnanimi, COUNT(praktikabaasID) AS kohtade_arv
FROM praktikajuhendaja
LEFT JOIN praktikabaas ON praktikajuhendaja.praktikajuhendajaID = praktikabaas.juhendajaID
GROUP BY eesnimi, perekonnanimi;

ALTER TABLE praktikajuhendaja ADD palk DECIMAL(10, 2);

UPDATE praktikajuhendaja SET palk = 1500.00 WHERE praktikajuhendajaID = 1;
UPDATE praktikajuhendaja SET palk = 1850.50 WHERE praktikajuhendajaID = 2;
UPDATE praktikajuhendaja SET palk = 1200.00 WHERE praktikajuhendajaID = 3;
UPDATE praktikajuhendaja SET palk = 2100.00 WHERE praktikajuhendajaID = 4;
UPDATE praktikajuhendaja SET palk = 1600.00 WHERE praktikajuhendajaID = 5;

SELECT AVG(palk) AS keskmine_palk, SUM(palk) AS kogupalk FROM praktikajuhendaja;

GO
CREATE VIEW v_firma_praktikakohad AS
SELECT firmanimi, COUNT(praktikabaasID) AS kogus
FROM praktikabaas
JOIN firma ON firma.firmaID = praktikabaas.firmaID
GROUP BY firmanimi;

GO
CREATE VIEW v_sygis_juhendajad AS
SELECT * FROM praktikajuhendaja
WHERE MONTH(synniaeg) IN (9, 10, 11);

SELECT * FROM v_firma_praktikakohad 
WHERE kogus = 1;

SELECT * FROM v_sygis_juhendajad;


GO
CREATE PROCEDURE AddFirma
    @nimi VARCHAR(50), 
    @adr VARCHAR(100), 
    @tel VARCHAR(20)
AS
BEGIN
    INSERT INTO firma(firmanimi, aadress, telefon) 
    VALUES (@nimi, @adr, @tel);
	SELECT * FROM firma;
END;

EXEC AddFirma 'Super IT', 'Tallinn', '5559988';
EXEC AddFirma 'FSDSDB', 'Tallinn', '5559988';



CREATE PROCEDURE AddFirmaEmail
    @ID INT,            
    @uusEmail VARCHAR(50) 
AS
BEGIN
    UPDATE firma 
    SET email = @uusEmail 
    WHERE firmaID = @ID;
    
    SELECT * FROM firma WHERE firmaID = @ID;
END;
EXEC AddFirmaEmail @ID = 5, @uusEmail = 'alpha-x@office.ee';
SELECT * FROM firma;

GO
CREATE PROCEDURE GetAvgSalary
AS
BEGIN
    SELECT AVG(palk) AS KeskminePalk FROM praktikajuhendaja;
END;

INSERT INTO praktikajuhendaja (eesnimi, perekonnanimi, palk) 
VALUES ('Petja', 'Ivanov', 5000.00);
VALUES ('Ivan', 'Ivanov', 5000.00);

EXEC GetAvgSalary;


CREATE FUNCTION fnPracticeDuration(@StartDate DATETIME)
RETURNS NVARCHAR(100)
AS 
BEGIN
    DECLARE @tempdate DATETIME, @years INT, @months INT, @days INT
    SET @tempdate = @StartDate


    SELECT @years = DATEDIFF(YEAR, @tempdate, GETDATE()) - 
           CASE WHEN (MONTH(@StartDate) > MONTH(GETDATE())) OR 
           (MONTH(@StartDate) = MONTH(GETDATE()) AND DAY(@StartDate) > DAY(GETDATE())) 
           THEN 1 ELSE 0 END
    SET @tempdate = DATEADD(YEAR, @years, @tempdate)


    SELECT @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - 
           CASE WHEN DAY(@StartDate) > DAY(GETDATE()) THEN 1 ELSE 0 END
    SET @tempdate = DATEADD(MONTH, @months, @tempdate)


    SELECT @days = DATEDIFF(DAY, @tempdate, GETDATE())

    DECLARE @Duration NVARCHAR(100)
    SET @Duration = 'Kestvus: ' + CAST(@years AS NVARCHAR(5)) + ' a., ' + 
                    CAST(@months AS NVARCHAR(5)) + ' k., ' + 
                    CAST(@days AS NVARCHAR(5)) + ' p.'
    
    RETURN @Duration
END;

SELECT eesnimi, perekonnanimi, 
       dbo.fnPracticeDuration(synniaeg) AS Tegevusaeg
FROM praktikajuhendaja;

CREATE FUNCTION CalculateAge(@DOB DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    
    SET @Age = DATEDIFF(YEAR, @DOB, GETDATE()) - 
               CASE 
                   WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR 
                        (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE())) 
                   THEN 1 ELSE 0 
               END;
    RETURN @Age;
END;

SELECT dbo.CalculateAge('1995-05-15') AS Vanus;
