create database TransUlesanne;
use TransUlesanne;

CREATE TABLE MailingAddress (
    AddressId      int          NOT NULL PRIMARY KEY,
    EmployeeNumber int,
    HouseNumber    nvarchar(50),
    StreetAddress  nvarchar(50),
    City           nvarchar(10),
    PostalCode     nvarchar(50)
);

CREATE TABLE PhysicalAddress (
    AddressId      int          NOT NULL PRIMARY KEY,
    EmployeeNumber int,
    HouseNumber    nvarchar(50),
    StreetAddress  nvarchar(50),
    City           nvarchar(10),
    PostalCode     nvarchar(50)
);

INSERT INTO MailingAddress  VALUES (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW');
INSERT INTO PhysicalAddress VALUES (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW');

SELECT * FROM MailingAddress;
SELECT * FROM PhysicalAddress;

GO

Create Procedure UpdateAddress
as
Begin
 Begin Try
  Begin Transaction
   Update MailingAddress set City = 'LONDON'
   where AddressId = 1 and EmployeeNumber = 101;

   Update PhysicalAddress set City = 'LONDON'
   where AddressId = 1 and EmployeeNumber = 101;

  Commit Transaction
 End Try

 Begin Catch
  Rollback Transaction
 End Catch
End;


EXEC UpdateAddress;
SELECT * FROM MailingAddress;
SELECT * FROM PhysicalAddress;

GO
Alter Procedure UpdateAddress
as
Begin
 Begin Try
  Begin Transaction
   Update MailingAddress set City = 'LONDON12'
   where AddressId = 1 and EmployeeNumber = 101;

   Update PhysicalAddress set City = 'LONDON LONDON'
   where AddressId = 1 and EmployeeNumber = 101;

  Commit Transaction
 End Try

 Begin Catch
  Rollback Transaction
 End Catch
End;

EXEC UpdateAddress;
SELECT * FROM MailingAddress;
SELECT * FROM PhysicalAddress;

go
Update MailingAddress  set City = 'LONDON12'
where AddressId = 1 and EmployeeNumber = 101;


Update PhysicalAddress set City = 'LONDON LONDON'
where AddressId = 1 and EmployeeNumber = 101;

SELECT * FROM MailingAddress;
SELECT * FROM PhysicalAddress;

Create Table Arveldusarve
(
   KontoId int NOT NULL primary key,
   KliendiNr int,
   Omanik nvarchar(30),
   Saldo decimal(10,2) CHECK (Saldo >= 0)
)
Create Table Hoiusarve
(
   KontoId int NOT NULL primary key,
   KliendiNr int,
   Omanik nvarchar(30),
   Saldo decimal(10,2) CHECK (Saldo >= 0)
)
Insert into Arveldusarve values (1, 201, 'Mari Maasikas', 500.00)
Insert into Hoiusarve    values (1, 201, 'Mari Maasikas', 1000.00)

SELECT * FROM Arveldusarve;
SELECT * FROM Hoiusarve;

GO
Create Procedure Ulekanne
as
Begin
 Begin Try
  Begin Transaction
   Update Hoiusarve    set Saldo = Saldo + 200 where KliendiNr = 201;
   Update Arveldusarve set Saldo = Saldo - 200 where KliendiNr = 201;
  Commit Transaction
 End Try
 Begin Catch
  Rollback Transaction
 End Catch
End;


EXEC Ulekanne;
SELECT * FROM Arveldusarve;
SELECT * FROM Hoiusarve;

GO
Alter Procedure Ulekanne
as
Begin
 Begin Try
  Begin Transaction
   Update Hoiusarve    set Saldo = Saldo + 1000 where KliendiNr = 201;
   Update Arveldusarve set Saldo = Saldo - 1000 where KliendiNr = 201;

  Commit Transaction
 End Try

 Begin Catch
  Rollback Transaction
 End Catch
End;

EXEC Ulekanne;
SELECT * FROM Arveldusarve;
SELECT * FROM Hoiusarve;

Update Hoiusarve    set Saldo = Saldo + 1000 where KliendiNr = 201;
Update Arveldusarve set Saldo = Saldo - 1000 where KliendiNr = 201;



SELECT * FROM Arveldusarve;
SELECT * FROM Hoiusarve;

GO
Alter Procedure Ulekanne
@Summa decimal(10,2)
as
Begin
 Begin Try
  Begin Transaction
   Update Hoiusarve    set Saldo = Saldo + @Summa where KliendiNr = 201;
   Update Arveldusarve set Saldo = Saldo - @Summa where KliendiNr = 201;

  Commit Transaction
 End Try

 Begin Catch
  Rollback Transaction
 End Catch
End;


EXEC Ulekanne @Summa = 50;

Create Table Ladu
(
   ToodeId int NOT NULL primary key,
   Nimi nvarchar(30),
   Hind decimal(10,2),
   Kogus int CHECK (Kogus >= 0)
)
Create Table Tellimus
(
   TellimusId int NOT NULL primary key,
   ToodeId int,
   Klient nvarchar(30),
   Kogus int
)
Insert into Ladu values (1, 'Hiir',      15.00, 10)
Insert into Ladu values (2, 'Klaviatuur', 30.00,  5)
Insert into Ladu values (3, 'Monitor',  120.00,  3)

Insert into Tellimus values (1, 1, 'Mari', 1)
Insert into Tellimus values (2, 2, 'Jaan', 1)
Insert into Tellimus values (3, 3, 'Kati', 1)


GO
Create Procedure TeeTellimus
@TellimusId int, @ToodeId int, @Klient nvarchar(30), @Kogus int
as
Begin
 Begin Try
  Begin Transaction
   Insert into Tellimus values (@TellimusId, @ToodeId, @Klient, @Kogus)
   Update Ladu set Kogus = Kogus - @Kogus where ToodeId = @ToodeId;

  Commit Transaction
 End Try

 Begin Catch
  Rollback Transaction
  Select ERROR_MESSAGE() as ErrorMessage
 End Catch
End;
