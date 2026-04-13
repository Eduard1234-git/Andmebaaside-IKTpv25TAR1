CREATE TABLE auto (
    autoID INT PRIMARY KEY IDENTITY(1,1),
    autonr VARCHAR(10),
    omanik VARCHAR(50),
    mark VARCHAR(30),
    aasta INT
);


CREATE TABLE logi (
    id INT PRIMARY KEY IDENTITY(1,1),
    kuupaev DATETIME,
    andmed TEXT,
    kasutaja VARCHAR(50)
);

CREATE TRIGGER autoLisamine
ON auto
FOR INSERT
AS
INSERT INTO logi(kuupaev, andmed, kasutaja)
SELECT 
    GETDATE(),
    CONCAT('LISATUD: ', autonr, ' | ', mark, ' | Omanik: ', omanik),
    SYSTEM_USER
FROM inserted;

CREATE TRIGGER autoKustutamine
ON auto
FOR DELETE
AS
INSERT INTO logi(kuupaev, andmed, kasutaja)
SELECT 
    GETDATE(),
    CONCAT('KUSTUTATUD: ', autonr, ' | ', mark, ' | Endine omanik: ', omanik),
    SYSTEM_USER
FROM deleted;

CREATE TRIGGER autoUuendamine
ON auto
FOR UPDATE
AS
INSERT INTO logi(kuupaev, andmed, kasutaja)
SELECT 
    GETDATE(),
    CONCAT('MUUDETUD: ', d.autonr, ' | Vana omanik: ', d.omanik, ' -> Uus omanik: ', i.omanik),
    SYSTEM_USER
FROM deleted d
INNER JOIN inserted i ON d.autoID = i.autoID;

INSERT INTO auto (autonr, omanik, mark, aasta)
VALUES ('123 ABC', 'Marek', 'BMW', 2020);

SELECT * FROM logi;

INSERT INTO auto (autonr, omanik, mark, aasta) VALUES ('555 TTT', 'Jüri', 'Audi', 2015);

UPDATE auto 
SET omanik = 'Andres' 
WHERE autonr = '555 TTT';

SELECT * FROM logi;

