USE [DomSprzedazyWysylkowej];
GO
SET NOCOUNT ON;
GO

BEGIN TRAN;

DECLARE @OldStatusID INT = 1;
DECLARE @NewStatusID INT = 101;

PRINT '--- PRZED: sprzedaze ze statusem = 1 ---';
SELECT SprzedazID, StatusID
FROM dbo.Sprzedaz
WHERE StatusID = @OldStatusID;

PRINT '--- UPDATE PK w tabeli nadrzednej (StatusZamowienia) ---';
UPDATE dbo.StatusZamowienia
SET StatusID = @NewStatusID
WHERE StatusID = @OldStatusID;

PRINT '--- PO: status w Sprzedaz powinien skaskadowac na 101 ---';
SELECT SprzedazID, StatusID
FROM dbo.Sprzedaz
WHERE StatusID IN (@OldStatusID, @NewStatusID);

ROLLBACK;
GO
