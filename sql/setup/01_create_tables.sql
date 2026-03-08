USE [DomSprzedazyWysylkowej];
GO

SET NOCOUNT ON;
GO

CREATE TABLE dbo.StatusZamowienia (
    StatusID     INT NOT NULL CONSTRAINT PK_StatusZamowienia PRIMARY KEY,  -- brak IDENTITY celowo
    NazwaStatusu NVARCHAR(50) NOT NULL,
    OpisStatusu  NVARCHAR(200) NULL,
    CONSTRAINT UQ_StatusZamowienia_Nazwa UNIQUE (NazwaStatusu)
);
GO

CREATE TABLE dbo.Kategoria (
    KategoriaID    INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Kategoria PRIMARY KEY,
    NazwaKategorii NVARCHAR(80) NOT NULL,
    OpisKategorii  NVARCHAR(200) NULL,
    CONSTRAINT UQ_Kategoria_Nazwa UNIQUE (NazwaKategorii)
);
GO

CREATE TABLE dbo.Producent (
    ProducentID       INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Producent PRIMARY KEY,
    NazwaProducenta   NVARCHAR(120) NOT NULL,
    KrajPochodzenia   NVARCHAR(80)  NOT NULL,
    StronaWWW         NVARCHAR(200) NULL,
    TelefonKontaktowy VARCHAR(20)   NULL,

    CONSTRAINT UQ_Producent_Nazwa UNIQUE (NazwaProducenta),
    CONSTRAINT CK_Producent_Telefon CHECK (TelefonKontaktowy IS NULL OR LEN(TelefonKontaktowy) BETWEEN 7 AND 20)
);
GO

/* glowne */
CREATE TABLE dbo.Klient (
    KlientID        INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Klient PRIMARY KEY,
    Adres           NVARCHAR(200) NOT NULL,
    Telefon         VARCHAR(20)   NULL,
    Email           NVARCHAR(254) NULL,
    DataRejestracji DATE NOT NULL CONSTRAINT DF_Klient_DataRejestracji DEFAULT (CONVERT(date, GETDATE())),
    Imie            NVARCHAR(50) NOT NULL,
    Nazwisko        NVARCHAR(80) NOT NULL,

    CONSTRAINT UQ_Klient_Email UNIQUE (Email),
    CONSTRAINT CK_Klient_Telefon CHECK (Telefon IS NULL OR LEN(Telefon) BETWEEN 7 AND 20),
    CONSTRAINT CK_Klient_Email CHECK (Email IS NULL OR Email LIKE N'%_@_%._%')
);
GO

CREATE TABLE dbo.Pracownik (
    PracownikID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Pracownik PRIMARY KEY,
    Stanowisko  NVARCHAR(30) NOT NULL,
    Dzial       NVARCHAR(30) NOT NULL,
    Telefon     VARCHAR(20)   NULL,
    Email       NVARCHAR(254) NULL,
    Imie        NVARCHAR(50)  NOT NULL,
    Nazwisko    NVARCHAR(80)  NOT NULL,

    CONSTRAINT UQ_Pracownik_Email UNIQUE (Email),
    CONSTRAINT CK_Pracownik_Telefon CHECK (Telefon IS NULL OR LEN(Telefon) BETWEEN 7 AND 20),

    CONSTRAINT CK_Pracownik_Stanowisko CHECK (Stanowisko IN (N'Sprzedawca', N'Magazynier', N'Zaopatrzenie', N'Ksiegowosc', N'Kierownik')),
    CONSTRAINT CK_Pracownik_Dzial CHECK (Dzial IN (N'Sprzedaz', N'Magazyn', N'Zaopatrzenie', N'Finanse', N'Zarzad')),

    CONSTRAINT CK_Pracownik_Email CHECK (Email IS NULL OR Email LIKE N'%_@_%._%')
);
GO

CREATE TABLE dbo.Produkt (
    ProduktID         INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Produkt PRIMARY KEY,
    Nazwa             NVARCHAR(120) NOT NULL,
    Opis              NVARCHAR(400) NULL,
    CenaJednostokowa  DECIMAL(10,2) NOT NULL,
    StanMagazynowy    INT NOT NULL,
    RodzajDostepnosci NVARCHAR(20) NOT NULL,
    KategoriaID       INT NOT NULL,
    ProducentID       INT NOT NULL,

    CONSTRAINT CK_Produkt_Cena CHECK (CenaJednostokowa > 0),
    CONSTRAINT CK_Produkt_Stan CHECK (StanMagazynowy >= 0),

    CONSTRAINT CK_Produkt_Rodzaj CHECK (RodzajDostepnosci IN (N'magazyn', N'na zamowienie')),

    CONSTRAINT FK_Produkt_Kategoria FOREIGN KEY (KategoriaID)
        REFERENCES dbo.Kategoria(KategoriaID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Produkt_Producent FOREIGN KEY (ProducentID)
        REFERENCES dbo.Producent(ProducentID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO

CREATE TABLE dbo.Sprzedaz (
    SprzedazID            INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Sprzedaz PRIMARY KEY,
    DataZlozenia          DATETIME2(0) NOT NULL CONSTRAINT DF_Sprzedaz_DataZlozenia DEFAULT (SYSDATETIME()),
    DataPlanowanejWysylki DATE NULL,
    DataWysylki           DATE NULL,
    DataDostarczenia      DATE NULL,
    StatusID              INT NOT NULL,
    KwotaRazem            DECIMAL(12,2) NOT NULL,
    KlientID              INT NOT NULL,
    PracownikID           INT NOT NULL,

    CONSTRAINT CK_Sprzedaz_Kwota CHECK (KwotaRazem >= 0),
    CONSTRAINT CK_Sprzedaz_Daty CHECK (
        (DataPlanowanejWysylki IS NULL OR DataPlanowanejWysylki >= CONVERT(date, DataZlozenia)) AND
        (DataWysylki IS NULL OR DataWysylki >= CONVERT(date, DataZlozenia)) AND
        (DataDostarczenia IS NULL OR DataDostarczenia >= ISNULL(DataWysylki, CONVERT(date, DataZlozenia)))
    ),

    CONSTRAINT FK_Sprzedaz_Status FOREIGN KEY (StatusID)
        REFERENCES dbo.StatusZamowienia(StatusID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Sprzedaz_Klient FOREIGN KEY (KlientID)
        REFERENCES dbo.Klient(KlientID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Sprzedaz_Pracownik FOREIGN KEY (PracownikID)
        REFERENCES dbo.Pracownik(PracownikID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO

CREATE TABLE dbo.PozycjaZamowienia (
    SprzedazID INT NOT NULL,
    ProduktID  INT NOT NULL,
    Ilosc      INT NOT NULL,
    CenaZakupu DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_PozycjaZamowienia PRIMARY KEY (SprzedazID, ProduktID),
    CONSTRAINT CK_Pozycja_Ilosc CHECK (Ilosc > 0),
    CONSTRAINT CK_Pozycja_Cena CHECK (CenaZakupu > 0),

    CONSTRAINT FK_Pozycja_Sprzedaz FOREIGN KEY (SprzedazID)
        REFERENCES dbo.Sprzedaz(SprzedazID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Pozycja_Produkt FOREIGN KEY (ProduktID)
        REFERENCES dbo.Produkt(ProduktID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO

CREATE TABLE dbo.Platnosc (
    PlatnoscID      INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Platnosc PRIMARY KEY,
    SprzedazID      INT NOT NULL,
    DataPlatnosci   DATETIME2(0) NOT NULL,
    Kwota           DECIMAL(12,2) NOT NULL,
    TypPlatnosci    NVARCHAR(20) NOT NULL,
    StatusPlatnosci NVARCHAR(20) NOT NULL,

    CONSTRAINT CK_Platnosc_Kwota CHECK (Kwota >= 0),
    CONSTRAINT CK_Platnosc_Typ CHECK (TypPlatnosci IN (N'karta', N'przelew', N'pobranie', N'blik', N'gotowka')),
    CONSTRAINT CK_Platnosc_Status CHECK (StatusPlatnosci IN (N'oczekuje', N'zaksiegowana', N'odrzucona', N'anulowana')),

    CONSTRAINT UQ_Platnosc_Sprzedaz UNIQUE (SprzedazID),

    CONSTRAINT FK_Platnosc_Sprzedaz FOREIGN KEY (SprzedazID)
        REFERENCES dbo.Sprzedaz(SprzedazID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO

CREATE INDEX IX_Sprzedaz_Status   ON dbo.Sprzedaz(StatusID);
CREATE INDEX IX_Sprzedaz_Klient   ON dbo.Sprzedaz(KlientID);
CREATE INDEX IX_Produkt_Kategoria ON dbo.Produkt(KategoriaID);
GO
