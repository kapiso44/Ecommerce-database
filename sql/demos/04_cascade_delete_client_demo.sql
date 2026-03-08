USE [DomSprzedazyWysylkowej];
GO
SET NOCOUNT ON;
GO

BEGIN TRAN;

DECLARE @KlientID INT = 2;

PRINT '--- PRZED: ile rekordow zalezy od klienta ---';
SELECT COUNT(*) AS SprzedazeKlienta
FROM dbo.Sprzedaz
WHERE KlientID = @KlientID;

SELECT COUNT(*) AS PozycjeKlienta
FROM dbo.PozycjaZamowienia p
JOIN dbo.Sprzedaz s ON s.SprzedazID = p.SprzedazID
WHERE s.KlientID = @KlientID;

SELECT COUNT(*) AS PlatnosciKlienta
FROM dbo.Platnosc pl
JOIN dbo.Sprzedaz s ON s.SprzedazID = pl.SprzedazID
WHERE s.KlientID = @KlientID;

PRINT '--- DELETE Klient (powinno skaskadowac w dol) ---';
DELETE FROM dbo.Klient
WHERE KlientID = @KlientID;

PRINT '--- PO: wszystko powinno byc 0 (w ramach transakcji) ---';
SELECT COUNT(*) AS SprzedazeKlienta
FROM dbo.Sprzedaz
WHERE KlientID = @KlientID;

SELECT COUNT(*) AS PozycjeKlienta
FROM dbo.PozycjaZamowienia p
JOIN dbo.Sprzedaz s ON s.SprzedazID = p.SprzedazID
WHERE s.KlientID = @KlientID;

SELECT COUNT(*) AS PlatnosciKlienta
FROM dbo.Platnosc pl
JOIN dbo.Sprzedaz s ON s.SprzedazID = pl.SprzedazID
WHERE s.KlientID = @KlientID;

ROLLBACK;
GO
