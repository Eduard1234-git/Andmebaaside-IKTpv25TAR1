CREATE DATABASE Eduard

--tabel linnad
CREATE TABLE linnad(
linnId int primary key identity(1,1),
linnanimi varchar(50) unique,
rahvaarv int not null);

--tabel logi
CREATE TABLE logi(
Id int primary key identity(1,1),
kuupaev datetime,
andmed TEXT);

--Insert Triger
CREATE TRIGGER linnalisamine
ON linnad
FOR INSERT
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
    getdate(), inserted.linnanimi
FROM inserted;

--kontrollimiseks tuleb lisada uus linn tabelisse linnad
INSERT INTO linnad(linnanimi, rahvaarv)
VALUES ('Narva', 60000)
SELECT * FROM linnad;
SELECT * FROM logi;


-- kustutame triger
drop trigger linnalisamine;

CREATE TRIGGER linnaLisamine
ON linnad
FOR INSERT
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
GETDATE(),
CONCAT('lisatud linn: ', inserted.linnanimi,
' | rahvaarv: ', inserted.rahvaarv, ' | id: ', inserted.linnId)
FROM inserted;

SELECT * FROM linnad;
SELECT * FROM logi;

--DELETE TRIGGER

CREATE TRIGGER linnaKustutamine
ON linnad
FOR DELETE
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
    getdate(),
    CONCAT('kustutatud linn: ', deleted.linnanimi,
           ' rahvaarv: ', deleted.rahvaarv,
           ' id: ', deleted.linnId)
FROM deleted;

delete from linnad WHERE linnId=1;
SELECT * FROM linnad;
SELECT * FROM logi;

-- UPDATE TRIGGER
CREATE TRIGGER linnaUuendamine
ON linnad
FOR UPDATE
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
    GETDATE(),
    CONCAT('vana linna andmed: ', d.linnanimi,
           ' | ', d.rahvaarv,
           ' | id: ', d.linnId,
           ' uued linna andmed: ', i.linnanimi,
           ' | ', i.rahvaarv,
           ' | id: ', i.linnId)
FROM deleted d
INNER JOIN inserted i
ON d.linnId = i.linnId;


-- kontrollimiseks uuendame linna andmed
SELECT * FROM linnad;

UPDATE linnad 
SET linnanimi = 'Tartu uus', rahvaarv = 25
WHERE linnId = 2;

SELECT * FROM linnad;
SELECT * FROM logi;

--lisame kasutajaNimi logi tabelisse
ALTER TABLE logi add kasutaja varchar(50)

CREATE TRIGGER linnaLisamineKustutamine
ON linnad
FOR INSERT, DELETE
AS
BEGIN
SET NOCOUNT ON;

INSERT INTO logi(kuupaev, andmed, kasutaja)
SELECT 
    getdate(),
    CONCAT('lisatud linn: ', inserted.linnanimi, 
           ' | rahvaarv: ', inserted.rahvaarv, 
           ' | id: ', inserted.linnId),
    SYSTEM_USER
FROM inserted

UNION ALL

SELECT 
 getdate(),
    CONCAT('lisatud linn: ', deleted.linnanimi, 
           ' | rahvaarv: ', deleted.rahvaarv, 
           ' | id: ', deleted.linnId),
    SYSTEM_USER
	FROM deleted 
END;
--deaktiveerimine linnalisamine ja linnaKasutamine
DISABLE TRIGGER linnaLisamine ON linnad;
DISABLE TRIGGER linnaKustutamine on linnad;

--kontroll
INSERT INTO linnad (linnanimi, rahvaarv)
VALUES ('Kelle34', 6000);
SELECT * FROM linnad;
SELECT * FROM logi;

DELETE FROM linnad WHERE linnID=5
