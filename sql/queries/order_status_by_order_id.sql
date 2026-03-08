SELECT st.StatusID, 
       st.NazwaStatusu, 
       st.OpisStatusu
FROM dbo.Sprzedaz s
JOIN dbo.StatusZamowienia st 
    ON s.StatusID = st.StatusID
WHERE s.SprzedazID = 1234;
