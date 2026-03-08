USE [DomSprzedazyWysylkowej];
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRAN;

    DELETE FROM dbo.Platnosc;
    DELETE FROM dbo.PozycjaZamowienia;
    DELETE FROM dbo.Sprzedaz;
    DELETE FROM dbo.Produkt;
    DELETE FROM dbo.Pracownik;
    DELETE FROM dbo.Klient;
    DELETE FROM dbo.Producent;
    DELETE FROM dbo.Kategoria;
    DELETE FROM dbo.StatusZamowienia;

    DBCC CHECKIDENT ('dbo.Kategoria',  RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Producent', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Klient',    RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Pracownik', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Produkt',   RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Sprzedaz',  RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Platnosc',  RESEED, 0) WITH NO_INFOMSGS;

    INSERT INTO dbo.StatusZamowienia (StatusID, NazwaStatusu, OpisStatusu) VALUES
    (1,  N'Nowe',              N'Zamowienie zarejestrowane'),
    (2,  N'W realizacji',      N'W trakcie kompletacji'),
    (3,  N'Oczekuje na towar', N'Brak w magazynie - oczekiwanie'),
    (4,  N'Skompletowane',     N'Gotowe do wysylki'),
    (5,  N'Wyslane',           N'Przekazane kurierowi'),
    (6,  N'Dostarczone',       N'Klient odebral'),
    (7,  N'Anulowane',         N'Zamowienie anulowane'),
    (8,  N'Zwrot w toku',      N'Obsluga zwrotu'),
    (9,  N'Reklamacja',        N'Obsluga reklamacji'),
    (10, N'Zakonczone',        N'Proces zamkniety');

    DECLARE @Kat TABLE (NazwaKategorii NVARCHAR(80) PRIMARY KEY, KategoriaID INT NOT NULL);

    INSERT INTO dbo.Kategoria (NazwaKategorii, OpisKategorii)
    OUTPUT inserted.NazwaKategorii, inserted.KategoriaID INTO @Kat(NazwaKategorii, KategoriaID)
    VALUES
    (N'Elektronika', N'Sprzet i akcesoria'),
    (N'AGD',         N'Urzadzenia domowe'),
    (N'Dom',         N'Wyposazenie domu'),
    (N'Ogrod',       N'Akcesoria ogrodowe'),
    (N'Moda',        N'Ubrania i dodatki'),
    (N'Sport',       N'Sprzet sportowy'),
    (N'Ksiazki',     N'Ksiazki i e-booki'),
    (N'Zabawki',     N'Zabawki dla dzieci'),
    (N'Kosmetyki',   N'Pielegnacja'),
    (N'Akcesoria',   N'Akcesoria rozne');

    DECLARE @Prod TABLE (NazwaProducenta NVARCHAR(120) PRIMARY KEY, ProducentID INT NOT NULL);

    INSERT INTO dbo.Producent (NazwaProducenta, KrajPochodzenia, StronaWWW, TelefonKontaktowy)
    OUTPUT inserted.NazwaProducenta, inserted.ProducentID INTO @Prod(NazwaProducenta, ProducentID)
    VALUES
    (N'Sony',    N'Japonia',    N'https://www.sony.com',               '123456789'),
    (N'Samsung', N'Korea Pld.', N'https://www.samsung.com',            '222333444'),
    (N'Apple',   N'USA',        N'https://www.apple.com',              '555666777'),
    (N'Bosch',   N'Niemcy',     N'https://www.bosch.com',              '111222333'),
    (N'LG',      N'Korea Pld.', N'https://www.lg.com',                 '777888999'),
    (N'Philips', N'Holandia',   N'https://www.philips.com',            '888777666'),
    (N'Xiaomi',  N'Chiny',      N'https://www.mi.com',                 '999888777'),
    (N'Huawei',  N'Chiny',      N'https://consumer.huawei.com',        '909808707'),
    (N'Anker',   N'Chiny',      N'https://www.anker.com',              '707808909'),
    (N'Lenovo',  N'Chiny',      N'https://www.lenovo.com',             '606707808'),
    (N'Adidas',  N'Niemcy',     N'https://www.adidas.com',             '101010101'),
    (N'Nike',    N'USA',        N'https://www.nike.com',               '202020202'),
    (N'LEGO',    N'Dania',      N'https://www.lego.com',               '303030303');

    DECLARE @Kl TABLE (Email NVARCHAR(254) PRIMARY KEY, KlientID INT NOT NULL);

    INSERT INTO dbo.Klient (Adres, Telefon, Email, DataRejestracji, Imie, Nazwisko)
    OUTPUT inserted.Email, inserted.KlientID INTO @Kl(Email, KlientID)
    VALUES
    (N'Gdansk, ul. Dluga 12/3',                 '500100100', N'jan.kowalski1@example.com',        '2025-03-18', N'Jan',       N'Kowalski'),
    (N'Gdansk, ul. Grunwaldzka 210/5',          '500100101', N'anna.nowak2@example.com',         '2025-04-07', N'Anna',      N'Nowak'),
    (N'Gdynia, ul. Swietojanska 2/10',          '500100102', N'piotr.wisniewski3@example.com',   '2025-04-29', N'Piotr',     N'Wisniewski'),
    (N'Warszawa, ul. Marszalkowska 10/22',      '500100103', N'ola.zielinska4@example.com',      '2025-05-12', N'Ola',       N'Pietrzak'),
    (N'Warszawa, ul. Pulawska 88/9',            '500100104', N'marek.wojcik5@example.com',       '2025-06-03', N'Marek',     N'Wojcik'),
    (N'Krakow, ul. Florianska 11/1',            '500100105', N'kasia.kaminska6@example.com',     '2025-06-21', N'Katarzyna', N'Kaminska'),
    (N'Krakow, ul. Dietla 45/7',                '500100106', N'tomasz.lewandowski7@example.com', '2025-07-02', N'Tomasz',    N'Lewandowski'),
    (N'Wroclaw, ul. Rynek 12/4',                '500100107', N'magda.dabrowska8@example.com',    '2025-07-17', N'Magda',     N'Dabrowska'),
    (N'Wroclaw, ul. Legnicka 60/12',            '500100108', N'lukasz.krawczyk9@example.com',    '2025-08-05', N'Lukasz',    N'Krawczyk'),
    (N'Poznan, ul. Polwiejska 13/8',            '500100109', N'ewa.piotrowska10@example.com',    '2025-08-19', N'Ewa',       N'Piotrowska'),
    (N'Warszawa, ul. Chmielna 17/6',            '500100110', N'karol.grabowski11@example.com',   '2025-08-26', N'Karol',     N'Grabowski'),
    (N'Gdansk, ul. Rajska 4/2',                 '500100111', N'asia.pawlowska12@example.com',    '2025-09-04', N'Joanna',    N'Pawlowska'),
    (N'Lodz, ul. Piotrkowska 14/33',            '500100112', N'michal.zajac13@example.com',      '2025-09-11', N'Michal',    N'Zajac'),
    (N'Gdansk, ul. Kartuska 120/9',             '500100113', N'agnieszka.sikora14@example.com',  '2025-09-24', N'Agnieszka', N'Sikora'),
    (N'Krakow, ul. Karmelicka 20/5',            '500100114', N'patryk.krol15@example.com',       '2025-10-02', N'Patryk',    N'Krol'),
    (N'Warszawa, ul. Wolska 50/19',             '500100115', N'natalia.wrobel16@example.com',    '2025-10-06', N'Natalia',   N'Wrobel'),
    (N'Poznan, ul. Glogowska 77/3',             '500100116', N'kuba.jablonski17@example.com',    '2025-10-15', N'Jakub',     N'Jablonski'),
    (N'Gdynia, ul. 10 Lutego 24/6',             '500100117', N'ania.mazur18@example.com',        '2025-10-22', N'Ania',      N'Mazur'),
    (N'Warszawa, ul. Aleje Jerozolimskie 120',  '500100118', N'weronika.kaczmarek19@example.com','2025-11-03', N'Weronika',  N'Kaczmarek'),
    (N'Gdansk, ul. Podwale Staromiejskie 70/1', '500100119', N'bartek.puchalski20@example.com',  '2025-11-12', N'Bartosz',   N'Puchalski');

    DECLARE @Pr TABLE (Email NVARCHAR(254) PRIMARY KEY, PracownikID INT NOT NULL);

    INSERT INTO dbo.Pracownik (Stanowisko, Dzial, Telefon, Email, Imie, Nazwisko)
    OUTPUT inserted.Email, inserted.PracownikID INTO @Pr(Email, PracownikID)
    VALUES
    (N'Sprzedawca',   N'Sprzedaz',     '600200100', N'sprzedawca1@firma.pl', N'Marta',     N'Lis'),
    (N'Sprzedawca',   N'Sprzedaz',     '600200101', N'sprzedawca2@firma.pl', N'Pawel',     N'Wilk'),
    (N'Magazynier',   N'Magazyn',      '600200102', N'magazyn1@firma.pl',    N'Robert',    N'Nowicki'),
    (N'Magazynier',   N'Magazyn',      '600200103', N'magazyn2@firma.pl',    N'Kamil',     N'Krupa'),
    (N'Zaopatrzenie', N'Zaopatrzenie', '600200104', N'zaop1@firma.pl',       N'Natalia',   N'Urban'),
    (N'Zaopatrzenie', N'Zaopatrzenie', '600200105', N'zaop2@firma.pl',       N'Konrad',    N'Zieba'),
    (N'Ksiegowosc',   N'Finanse',      '600200106', N'finanse1@firma.pl',    N'Eliza',     N'Bak'),
    (N'Ksiegowosc',   N'Finanse',      '600200107', N'finanse2@firma.pl',    N'Grzegorz',  N'Koziol'),
    (N'Kierownik',    N'Zarzad',       '600200108', N'kierownik@firma.pl',   N'Andrzej',   N'Kania'),
    (N'Sprzedawca',   N'Sprzedaz',     '600200109', N'sprzedawca3@firma.pl', N'Sara',      N'Jasinska'),
    (N'Magazynier',   N'Magazyn',      '600200110', N'magazyn3@firma.pl',    N'Marek',     N'Maj'),
    (N'Sprzedawca',   N'Sprzedaz',     '600200111', N'sprzedawca4@firma.pl', N'Olga',      N'Lew'),
    (N'Zaopatrzenie', N'Zaopatrzenie', '600200112', N'zaop3@firma.pl',       N'Piotr',     N'Zaremba'),
    (N'Ksiegowosc',   N'Finanse',      '600200113', N'finanse3@firma.pl',    N'Iwona',     N'Las'),
    (N'Sprzedawca',   N'Sprzedaz',     '600200114', N'sprzedawca5@firma.pl', N'Tomasz',    N'Kowal'),
    (N'Magazynier',   N'Magazyn',      '600200115', N'magazyn4@firma.pl',    N'Patryk',    N'Bor'),
    (N'Sprzedawca',   N'Sprzedaz',     '600200116', N'sprzedawca6@firma.pl', N'Julia',     N'Kaczor'),
    (N'Zaopatrzenie', N'Zaopatrzenie', '600200117', N'zaop4@firma.pl',       N'Kinga',     N'Wrona'),
    (N'Ksiegowosc',   N'Finanse',      '600200118', N'finanse4@firma.pl',    N'Krzysztof', N'Pawlak'),
    (N'Kierownik',    N'Zarzad',       '600200119', N'kierownik2@firma.pl',  N'Wojciech',  N'Lisowski');

    /* Produkty: laczymy po nazwie kategorii i producenta */
    WITH P AS (
        SELECT
            N'Sluchawki bezprzewodowe' AS Nazwa, N'Bluetooth 5.0, ANC' AS Opis, CAST(229.99 AS DECIMAL(10,2)) AS Cena, 28 AS Stan, N'magazyn' AS Dost,
            N'Elektronika' AS Kat, N'Sony' AS Prod
        UNION ALL SELECT N'Smartfon Galaxy A55', N'128 GB, 5G', 2399.00, 10, N'magazyn', N'Elektronika', N'Samsung'
        UNION ALL SELECT N'iPad 10.9', N'64 GB, Wi-Fi', 1799.00, 9, N'magazyn', N'Elektronika', N'Apple'
        UNION ALL SELECT N'Odkurzacz', N'Klasa A, workowy', 799.00, 5, N'magazyn', N'AGD', N'Bosch'
        UNION ALL SELECT N'Czajnik', N'1.7L, stal nierdzewna', 149.00, 22, N'magazyn', N'AGD', N'Philips'
        UNION ALL SELECT N'Telewizor 55', N'4K HDR, Smart TV', 2999.00, 3, N'na zamowienie', N'Elektronika', N'LG'
        UNION ALL SELECT N'Buty sportowe', N'Rozm. 42, biegowe', 349.00, 25, N'magazyn', N'Sport', N'Adidas'
        UNION ALL SELECT N'Koszulka treningowa', N'Oddychajaca, szybkoschnaca', 129.00, 60, N'magazyn', N'Sport', N'Nike'
        UNION ALL SELECT N'Klocki zestaw', N'500 elementow', 259.00, 15, N'magazyn', N'Zabawki', N'LEGO'
        UNION ALL SELECT N'Krem do twarzy', N'50ml', 79.99, 40, N'magazyn', N'Kosmetyki', N'Philips'
        UNION ALL SELECT N'Lampka biurkowa', N'LED, USB-C', 99.90, 18, N'magazyn', N'Dom', N'Xiaomi'
        UNION ALL SELECT N'Krzeslo', N'Drewniane, tapicerowane', 249.00, 6, N'na zamowienie', N'Dom', N'Bosch'
        UNION ALL SELECT N'Grill ogrodowy', N'Weglowy, 47 cm', 299.00, 4, N'magazyn', N'Ogrod', N'Bosch'
        UNION ALL SELECT N'Skakanka', N'Regulowana', 29.90, 100, N'magazyn', N'Sport', N'Nike'
        UNION ALL SELECT N'Pilka nozna', N'Rozm. 5', 89.00, 30, N'magazyn', N'Sport', N'Nike'
        UNION ALL SELECT N'Powerbank', N'20000mAh, PD 20W', 169.90, 22, N'magazyn', N'Elektronika', N'Anker'
        UNION ALL SELECT N'Ladowarka USB-C', N'65W GaN', 139.90, 50, N'magazyn', N'Elektronika', N'Anker'
        UNION ALL SELECT N'Suszarka do wlosow', N'2100W', 199.00, 10, N'magazyn', N'AGD', N'Philips'
        UNION ALL SELECT N'Perfumy', N'100ml', 199.00, 14, N'magazyn', N'Kosmetyki', N'Philips'
        UNION ALL SELECT N'Zestaw akcesoriow', N'Etui + szklo', 59.90, 75, N'magazyn', N'Akcesoria', N'Samsung'
        UNION ALL SELECT N'Laptop 14', N'Ryzen 5, 16GB RAM, 512GB SSD', 3299.00, 7, N'magazyn', N'Elektronika', N'Lenovo'
    )
    INSERT INTO dbo.Produkt (Nazwa, Opis, CenaJednostokowa, StanMagazynowy, RodzajDostepnosci, KategoriaID, ProducentID)
    SELECT
        p.Nazwa, p.Opis, p.Cena, p.Stan, p.Dost,
        k.KategoriaID,
        pr.ProducentID
    FROM P p
    JOIN @Kat k ON k.NazwaKategorii = p.Kat
    JOIN @Prod pr ON pr.NazwaProducenta = p.Prod;

    /* Sprzedaz: laczymy KlientID i PracownikID po emailach */
    WITH S AS (
        SELECT CAST('2025-11-01 10:00:00' AS DATETIME2(0)) AS DataZlozenia, CAST('2025-11-03' AS DATE) AS DataPlan, NULL AS DataW, NULL AS DataD, 1 AS StatusID,
               N'jan.kowalski1@example.com' AS KlEmail, N'sprzedawca1@firma.pl' AS PrEmail
        UNION ALL SELECT '2025-11-02 11:30:00','2025-11-04',NULL,NULL,2, N'anna.nowak2@example.com', N'sprzedawca2@firma.pl'
        UNION ALL SELECT '2025-11-03 09:15:00','2025-11-05','2025-11-05',NULL,4, N'piotr.wisniewski3@example.com', N'sprzedawca1@firma.pl'
        UNION ALL SELECT '2025-11-04 13:20:00','2025-11-06','2025-11-06','2025-11-08',6, N'ola.zielinska4@example.com', N'sprzedawca2@firma.pl'
        UNION ALL SELECT '2025-11-05 08:05:00','2025-11-07',NULL,NULL,3, N'marek.wojcik5@example.com', N'sprzedawca3@firma.pl'
        UNION ALL SELECT '2025-11-06 16:40:00','2025-11-08',NULL,NULL,1, N'kasia.kaminska6@example.com', N'sprzedawca1@firma.pl'
        UNION ALL SELECT '2025-11-07 12:10:00','2025-11-09','2025-11-09',NULL,5, N'tomasz.lewandowski7@example.com', N'sprzedawca2@firma.pl'
        UNION ALL SELECT '2025-11-08 14:55:00','2025-11-10','2025-11-10','2025-11-12',6, N'magda.dabrowska8@example.com', N'sprzedawca1@firma.pl'
        UNION ALL SELECT '2025-11-09 17:05:00','2025-11-11',NULL,NULL,2, N'lukasz.krawczyk9@example.com', N'sprzedawca2@firma.pl'
        UNION ALL SELECT '2025-11-10 09:45:00','2025-11-12',NULL,NULL,1, N'ewa.piotrowska10@example.com', N'sprzedawca3@firma.pl'
        UNION ALL SELECT '2025-11-11 10:20:00','2025-11-13','2025-11-13',NULL,5, N'karol.grabowski11@example.com', N'sprzedawca1@firma.pl'
        UNION ALL SELECT '2025-11-12 11:10:00','2025-11-14',NULL,NULL,1, N'asia.pawlowska12@example.com', N'sprzedawca2@firma.pl'
        UNION ALL SELECT '2025-11-13 12:00:00','2025-11-15','2025-11-15','2025-11-17',6, N'michal.zajac13@example.com', N'sprzedawca1@firma.pl'
        UNION ALL SELECT '2025-11-14 13:30:00','2025-11-16',NULL,NULL,3, N'agnieszka.sikora14@example.com', N'sprzedawca2@firma.pl'
        UNION ALL SELECT '2025-11-15 14:40:00','2025-11-17',NULL,NULL,2, N'patryk.krol15@example.com', N'sprzedawca3@firma.pl'
        UNION ALL SELECT '2025-11-16 15:25:00','2025-11-18','2025-11-18',NULL,5, N'natalia.wrobel16@example.com', N'sprzedawca1@firma.pl'
        UNION ALL SELECT '2025-11-17 16:05:00','2025-11-19',NULL,NULL,1, N'kuba.jablonski17@example.com', N'sprzedawca2@firma.pl'
        UNION ALL SELECT '2025-11-18 10:15:00','2025-11-20','2025-11-20','2025-11-22',6, N'ania.mazur18@example.com', N'sprzedawca1@firma.pl'
        UNION ALL SELECT '2025-11-19 11:45:00','2025-11-21',NULL,NULL,7, N'weronika.kaczmarek19@example.com', N'sprzedawca2@firma.pl'
        UNION ALL SELECT '2025-11-20 09:05:00','2025-11-22',NULL,NULL,1, N'bartek.puchalski20@example.com', N'sprzedawca3@firma.pl'
    )
    INSERT INTO dbo.Sprzedaz (DataZlozenia, DataPlanowanejWysylki, DataWysylki, DataDostarczenia, StatusID, KwotaRazem, KlientID, PracownikID)
    SELECT
        s.DataZlozenia, s.DataPlan, s.DataW, s.DataD, s.StatusID,
        CAST(0 AS DECIMAL(12,2)) AS KwotaRazem,
        k.KlientID,
        p.PracownikID
    FROM S s
    JOIN @Kl k ON k.Email = s.KlEmail
    JOIN @Pr p ON p.Email = s.PrEmail;

    /* mapowanie SprzedazID po DataZlozenia (u nas unikalne) */
    DECLARE @Sprz TABLE (DataZlozenia DATETIME2(0) PRIMARY KEY, SprzedazID INT NOT NULL);
    INSERT INTO @Sprz (DataZlozenia, SprzedazID)
    SELECT DataZlozenia, SprzedazID FROM dbo.Sprzedaz;

    /* laczymy sprzedaz po dacie i produkt po nazwie */
    WITH Z AS (
        SELECT CAST('2025-11-01 10:00:00' AS DATETIME2(0)) AS DataZ, N'Sluchawki bezprzewodowe' AS Prod, 1 AS Ilosc, 229.99 AS Cena
        UNION ALL SELECT '2025-11-01 10:00:00', N'Powerbank', 1, 169.90
        UNION ALL SELECT '2025-11-02 11:30:00', N'Smartfon Galaxy A55', 1, 2399.00
        UNION ALL SELECT '2025-11-02 11:30:00', N'Zestaw akcesoriow', 2, 59.90
        UNION ALL SELECT '2025-11-03 09:15:00', N'iPad 10.9', 1, 1799.00
        UNION ALL SELECT '2025-11-03 09:15:00', N'Ladowarka USB-C', 1, 139.90
        UNION ALL SELECT '2025-11-04 13:20:00', N'Odkurzacz', 1, 799.00
        UNION ALL SELECT '2025-11-04 13:20:00', N'Czajnik', 1, 149.00
        UNION ALL SELECT '2025-11-05 08:05:00', N'Telewizor 55', 1, 2999.00
        UNION ALL SELECT '2025-11-05 08:05:00', N'Sluchawki bezprzewodowe', 2, 229.99
        UNION ALL SELECT '2025-11-06 16:40:00', N'Buty sportowe', 1, 349.00
        UNION ALL SELECT '2025-11-06 16:40:00', N'Koszulka treningowa', 2, 129.00
        UNION ALL SELECT '2025-11-07 12:10:00', N'Klocki zestaw', 1, 259.00
        UNION ALL SELECT '2025-11-07 12:10:00', N'Skakanka', 3, 29.90
        UNION ALL SELECT '2025-11-08 14:55:00', N'Krem do twarzy', 2, 79.99
        UNION ALL SELECT '2025-11-08 14:55:00', N'Lampka biurkowa', 1, 99.90
        UNION ALL SELECT '2025-11-09 17:05:00', N'Krzeslo', 1, 249.00
        UNION ALL SELECT '2025-11-09 17:05:00', N'Grill ogrodowy', 1, 299.00
        UNION ALL SELECT '2025-11-10 09:45:00', N'Pilka nozna', 2, 89.00
        UNION ALL SELECT '2025-11-10 09:45:00', N'Laptop 14', 1, 3299.00
        UNION ALL SELECT '2025-11-11 10:20:00', N'Suszarka do wlosow', 1, 199.00
        UNION ALL SELECT '2025-11-11 10:20:00', N'Czajnik', 1, 149.00
        UNION ALL SELECT '2025-11-12 11:10:00', N'Powerbank', 2, 169.90
        UNION ALL SELECT '2025-11-12 11:10:00', N'Ladowarka USB-C', 1, 139.90
        UNION ALL SELECT '2025-11-13 12:00:00', N'Smartfon Galaxy A55', 1, 2399.00
        UNION ALL SELECT '2025-11-13 12:00:00', N'Sluchawki bezprzewodowe', 1, 229.99
        UNION ALL SELECT '2025-11-14 13:30:00', N'Telewizor 55', 1, 2999.00
        UNION ALL SELECT '2025-11-14 13:30:00', N'Zestaw akcesoriow', 1, 59.90
        UNION ALL SELECT '2025-11-15 14:40:00', N'Klocki zestaw', 2, 259.00
        UNION ALL SELECT '2025-11-15 14:40:00', N'Krem do twarzy', 1, 79.99
        UNION ALL SELECT '2025-11-16 15:25:00', N'iPad 10.9', 1, 1799.00
        UNION ALL SELECT '2025-11-16 15:25:00', N'Lampka biurkowa', 2, 99.90
        UNION ALL SELECT '2025-11-17 16:05:00', N'Buty sportowe', 1, 349.00
        UNION ALL SELECT '2025-11-17 16:05:00', N'Pilka nozna', 1, 89.00
        UNION ALL SELECT '2025-11-18 10:15:00', N'Odkurzacz', 1, 799.00
        UNION ALL SELECT '2025-11-18 10:15:00', N'Czajnik', 2, 149.00
        UNION ALL SELECT '2025-11-19 11:45:00', N'Koszulka treningowa', 1, 129.00
        UNION ALL SELECT '2025-11-19 11:45:00', N'Skakanka', 1, 29.90
        UNION ALL SELECT '2025-11-20 09:05:00', N'Powerbank', 1, 169.90
        UNION ALL SELECT '2025-11-20 09:05:00', N'Sluchawki bezprzewodowe', 1, 229.99
    )
    INSERT INTO dbo.PozycjaZamowienia (SprzedazID, ProduktID, Ilosc, CenaZakupu)
    SELECT
        s.SprzedazID,
        p.ProduktID,
        z.Ilosc,
        CAST(z.Cena AS DECIMAL(10,2))
    FROM Z z
    JOIN @Sprz s ON s.DataZlozenia = z.DataZ
    JOIN dbo.Produkt p ON p.Nazwa = z.Prod;

    UPDATE s
    SET KwotaRazem = x.Suma
    FROM dbo.Sprzedaz s
    JOIN (
        SELECT SprzedazID, SUM(CAST(Ilosc AS DECIMAL(12,2)) * CenaZakupu) AS Suma
        FROM dbo.PozycjaZamowienia
        GROUP BY SprzedazID
    ) x ON x.SprzedazID = s.SprzedazID;

    /* platnosci laczymy po dacie sprzedazy */
    WITH Pay AS (
        SELECT CAST('2025-11-03 09:15:00' AS DATETIME2(0)) AS DataZ, CAST('2025-11-03 10:00:00' AS DATETIME2(0)) AS DataP, N'przelew' AS Typ, N'zaksiegowana' AS Status
        UNION ALL SELECT '2025-11-04 13:20:00', '2025-11-04 14:00:00', N'karta', N'zaksiegowana'
        UNION ALL SELECT '2025-11-07 12:10:00', '2025-11-07 12:30:00', N'blik', N'zaksiegowana'
        UNION ALL SELECT '2025-11-08 14:55:00', '2025-11-08 15:30:00', N'karta', N'zaksiegowana'
        UNION ALL SELECT '2025-11-11 10:20:00', '2025-11-11 11:00:00', N'przelew', N'zaksiegowana'
        UNION ALL SELECT '2025-11-13 12:00:00', '2025-11-13 12:30:00', N'karta', N'zaksiegowana'
        UNION ALL SELECT '2025-11-16 15:25:00', '2025-11-16 16:00:00', N'gotowka', N'zaksiegowana'
        UNION ALL SELECT '2025-11-18 10:15:00', '2025-11-18 11:00:00', N'przelew', N'zaksiegowana'
        UNION ALL SELECT '2025-11-19 11:45:00', '2025-11-19 12:00:00', N'przelew', N'odrzucona'
        UNION ALL SELECT '2025-11-02 11:30:00', '2025-11-02 12:00:00', N'pobranie', N'oczekuje'
    )
    INSERT INTO dbo.Platnosc (SprzedazID, DataPlatnosci, Kwota, TypPlatnosci, StatusPlatnosci)
    SELECT
        s.SprzedazID,
        pay.DataP,
        CASE WHEN pay.Status = N'odrzucona' THEN 0.00 ELSE (SELECT KwotaRazem FROM dbo.Sprzedaz WHERE SprzedazID = s.SprzedazID) END AS Kwota,
        pay.Typ,
        pay.Status
    FROM Pay pay
    JOIN @Sprz s ON s.DataZlozenia = pay.DataZ;

    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(N'02_insert_data.sql failed: %s', 16, 1, @msg);
END CATCH;
GO
