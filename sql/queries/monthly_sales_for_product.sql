SELECT 
    FORMAT(s.DataZlozenia, 'yyyy-MM') AS Miesiac,
    SUM(pz.Ilosc) AS LiczbaSprzedanychSztuk,
    SUM(pz.Ilosc * pz.CenaZakupu) AS LacznaWartoscSprzedazy
FROM dbo.Produkt pr
JOIN dbo.PozycjaZamowienia pz 
    ON pr.ProduktID = pz.ProduktID
JOIN dbo.Sprzedaz s 
    ON s.SprzedazID = pz.SprzedazID
WHERE pr.Nazwa = N'Sluchawki bezprzewodowe'   -- wybrany produkt
GROUP BY FORMAT(s.DataZlozenia, 'yyyy-MM')
ORDER BY Miesiac;
