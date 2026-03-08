SELECT DISTINCT pr.ProduktID, pr.Nazwa, pr.StanMagazynowy
FROM dbo.Produkt pr
JOIN dbo.PozycjaZamowienia pz 
    ON pr.ProduktID = pz.ProduktID
JOIN dbo.Sprzedaz s 
    ON s.SprzedazID = pz.SprzedazID
JOIN dbo.StatusZamowienia st 
    ON st.StatusID = s.StatusID
WHERE pr.StanMagazynowy = 0
  AND st.NazwaStatusu IN (N'Nowe', N'W realizacji');
