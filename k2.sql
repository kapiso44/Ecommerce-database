SELECT p.PlatnoscID,
       p.SprzedazID,
       p.DataPlatnosci,
       p.Kwota,
       p.TypPlatnosci,
       p.StatusPlatnosci
FROM dbo.Platnosc p
WHERE p.PlatnoscID = 1234;
