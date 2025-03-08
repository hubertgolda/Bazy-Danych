-- 1.:
create database firma;

-- 2.:
create schema rozliczenia;

-- 3.:
DROP TABLE rozliczenia.pracownicy;
DROP TABLE rozliczenia.godziny;
DROP TABLE rozliczenia.pensje;
DROP TABLE rozliczenia.premie;

create table rozliczenia.pracownicy(id_pracownika varchar(10) primary key not null, imie varchar(25) not null, nazwisko varchar(30) not null, adres varchar(100), telefon int);
create table rozliczenia.godziny(id_godziny varchar(10) primary key, data date, liczba_godzin int, id_pracownika varchar(10) not null);
create table rozliczenia.pensje(id_pensji varchar(10) primary key not null, stanowisko varchar(25) not null, kwota DOUBLE PRECISION  not null, id_premii varchar(10));
create table rozliczenia.premie(id_premii varchar(10) primary key not null, rodzaj varchar(15) not null, kwota DOUBLE PRECISION  not null);

-- 4.:
insert into rozliczenia.pracownicy(id_pracownika, imie, nazwisko, adres, telefon) values ('A01', 'Jan', 'Kowalski', 'Polna 11a Gdynia', 673865345),
('A02', 'Waclaw', 'Dobrzanski', 'Słoneczna 77 Kraków', 567890123);

insert into rozliczenia.pracownicy(id_pracownika, imie, nazwisko, adres, telefon) values ('B01', 'Anna', 'Kaczorek', 'Leśna 23c Lublin', 536718291), 
('A03', 'Bogdan', 'Ryman', 'Ogrodowa 3 Katowice', 832994167), ('B02', 'Alicja', 'Walaszek', 'Lipowa 87 Rzeszów', 647322653),
('B03', 'Patrycja', 'Gniazdo', 'Morska 5d Wrocław', 537289352), ('A04', 'Mikolaj', 'Drozd', 'Zielona 9 Białystok', 873928733), 
('A05', 'Dawid', 'Trzepak', 'Brzozowa 16 Olsztyn', 673829263), ('B04', 'Honorata', 'Kurtyna', 'Dębowa 243 Szczecin', 543526371), 
('A06', 'Nikodem', 'Strzała', 'Wiosenna 145 Poznań', 678901748);


insert into rozliczenia.godziny(id_godziny, data, liczba_godzin, id_pracownika) values ('G460','2024-01-23', 2, 'A02'),('G067','2024-01-22', 8, 'A03'),
('G765','2024-01-21', 8,'B02'),('S072','2024-03-31', 12, 'A03'),('G546','2024-01-13', 10, 'A01'),
('S873','2024-02-03', 8, 'A05'),('S023','2024-01-18', 8, 'B02'),('G568', '2024-01-23', 10, 'B01'),
('G987', '2024-01-27', 4, 'A04'),('G453', '2024-01-15', 12, 'B01');

insert into rozliczenia.pensje(id_pensji, stanowisko, kwota, id_premii) values ('P04', 'Operator pow. płaskich', 2137.00, NULL), ('P05', 'Kierowca', 4456.99, 'L01'),
('P33','Operator pow. płaskich', 2345., NULL), ('P41', 'Kier. działu rozrywki', 12879.00, 'S12'),
('P84', 'Z-c kier. działu rozrywki', 11769.00, 'S14'), ('P53','Operator pow.', 2345.67, NULL),
('P45', 'Sekretarz', 3586.35, NULL), ('Z03', 'Asystent sprzedaży', 6754.89, NULL),
('Z11', 'Asystent sprzedaży', 6754.89, NULL), ('Z02', 'Sekretarz', 3586.35, NULL);

insert into rozliczenia.premie(id_premii, rodzaj, kwota) values ('S01', 'Specjalna 1', 123.00), ('S02', 'Specjalna 2', 256.00),
('S04', 'Specjalna 4', 479.00), ('S09', 'Specjalna 9', 1289.00),
('S11', 'Specjalna 11', 2457.89), ('S14', 'Specjalna 14', 3476.99),
('L01', 'Lekarska 1', 12.00), ('L03', 'Lekarska 3', 35.00),
('L04', 'Lekarska 4', 89.00), ('KK12', 'Uznaniowa', 100.00);

-- 5.:
select nazwisko, adres
from rozliczenia.pracownicy;

-- 6.:
select data, liczba_godzin
from rozliczenia.godziny;

-- select DATE_PART('day', data) from rozliczenia.godziny
select to_char(data, 'day') as "dzień tygodnia" from rozliczenia.godziny;
select to_char(data, 'month') as "dzień miesiąca" from rozliczenia.godziny;

-- 7.:
select kwota from rozliczenia.pensje;

-- Zmiana nazwy atrybutu i dodanie nowego atrybutu
ALTER TABLE rozliczenia.pensje
RENAME COLUMN kwota TO kwota_brutto;

ALTER TABLE rozliczenia.pensje
ADD COLUMN kwota_netto DECIMAL(10,2);

-- Obliczenie kwoty netto i aktualizacja wartości w tabeli
UPDATE rozliczenia.pensje
SET kwota_netto = kwota_brutto * 0.75; -- Zakładając np. 25% podatek

select kwota_netto, kwota_brutto from rozliczenia.pensje;

-- Zapisanie zmian
COMMIT;

