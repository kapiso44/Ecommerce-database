SELECT s.SprzedazID,
       s.DataZlozenia,
       k.Imie, 
       k.Nazwisko, 
       k.Email
FROM dbo.Sprzedaz s
LEFT JOIN dbo.Platnosc p 
    ON p.SprzedazID = s.SprzedazID
JOIN dbo.Klient k 
    ON k.KlientID = s.KlientID
WHERE p.PlatnoscID IS NULL;
