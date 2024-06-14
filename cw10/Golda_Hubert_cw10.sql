--stworzenie nowej bazy danych
create database geologia;

--utworzenie schematów ułatwiających pracę z projektem
create schema znormal;
create schema zdenormal;

--stworzenie znormalizowanych tabel geochronologicznych oraz wypełnienie ich rekordami
create table znormal.GeoEon(id_eon int primary key not null, nazwa_eon varchar(30));
create table znormal.GeoEra(id_era int primary key not null, id_eon int, nazwa_era varchar(30));
create table znormal.GeoOkres(id_okres int primary key not null, id_era int, nazwa_okres varchar(30));
create table znormal.GeoEpoka(id_epoka int primary key not null, id_okres int, nazwa_epoka varchar(30));
create table znormal.GeoPietro(id_pietro int primary key not null, id_epoka int, nazwa_pietro varchar(30));


insert into znormal.GeoEon(id_eon, nazwa_eon) values 
(1, 'FANEROZOIK');

insert into znormal.GeoEra(id_era, id_eon, nazwa_era) values 
(1, 1,'Kenzoik'),
(2, 1,'Mezozoik'),
(3, 1,'Paleozoik');

insert into znormal.GeoOkres(id_okres, id_era, nazwa_okres) values 
(1, 1,'Czwartorząd'),
(2, 1,'Trzeciorząd'),
(3, 2,'Kreda'),
(4, 2,'Jura'),
(5, 2,'Trias'),
(6, 3,'Perm'),
(7, 3,'Karbon'),
(8, 3,'Dewon');

insert into znormal.GeoEpoka(id_epoka, id_okres, nazwa_epoka) values 
(1, 1,'Halocen'),
(2, 1,'Plejstocen'),
(3, 2,'Pliocen'),
(4, 2,'Miocen'),
(5, 2,'Oligocen'),
(6, 2,'Eocen'),
(7, 2,'Paleocen'),
(8, 3,'Górna'),
(9, 3,'Dolnaa'),
(10, 4,'Górna'),
(11, 4,'Środkowa'),
(12, 4,'Dolna'),
(13, 5,'Górna'),
(14, 5,'Środkowa'),
(15, 5,'Dolna'),
(16, 6,'Górny'),
(17, 6,'Dolny'),
(18, 7,'Górny'),
(19, 7,'Dolny'),
(20, 8,'Górny'),
(21, 8,'Środkowy'),
(22, 8,'Dolny');

insert into znormal.GeoPietro(id_pietro, id_epoka, nazwa_pietro) values 
(1, 1,'a'),
(2, 1,'b'),
(3, 2,'c'),
(4, 2,'d'),
(5, 2,'e'),
(6, 2,'f'),
(7, 3,'g'),
(8, 3,'h'),
(9, 4,'i'),
(10, 4,'j'),
(11, 5,'k'),
(12, 5,'l'),
(13, 6,'m'),
(14, 6,'n'),
(15, 6,'o'),
(16, 7,'p'),
(17, 7,'r'),
(18, 8,'s'),
(19, 8,'t'),
(20, 9,'u'),
(21, 9,'v'),
(22, 9,'w'),
(23, 10,'ac'),
(24, 10,'bd'),
(25, 10,'ce'),
(26, 11,'df'),
(27, 12,'eg'),
(28, 12,'fh'),
(29, 12,'gi'),
(30, 12,'hj'),
(31, 13,'ik'),
(32, 13,'jl'),
(33, 13,'km'),
(34, 14,'ln'),
(35, 14,'mo'),
(36, 14,'np'),
(37, 15,'or'),
(38, 15,'ps'),
(39, 15,'rt'),
(40, 16,'su'),
(41, 16,'tv'),
(42, 17,'uw'),
(43, 17,'vc'),
(44, 17,'wd'),
(45, 17,'ae'),
(46, 18,'bf'),
(47, 18,'cg'),
(48, 18,'dh'),
(49, 18,'ei'),
(50, 19,'fj'),
(51, 19,'gk'),
(52, 19,'hl'),
(53, 20,'im'),
(54, 20,'jn'),
(55, 20,'ko'),
(56, 20,'lp'),
(57, 20,'mr'),
(58, 21,'ns'),
(59, 21,'ot'),
(60, 21,'pu'),
(61, 21,'rv'),
(62, 22,'sw'),
(63, 22,'tm'),
(64, 22,'un'),
(65, 22,'vo'),
(66, 22,'wp'),
(67, 22,'xr'),
(68, 22,'ys');

--stworzenie zdenormalizowanej tabeli geochronologicznej

CREATE TABLE zdenormal.GeoTabela AS (SELECT * FROM znormal.GeoPietro NATURAL JOIN znormal.GeoEpoka NATURAL
JOIN znormal.GeoOkres NATURAL JOIN znormal.GeoEra NATURAL JOIN znormal.GeoEon );

--stworzenie tabel z cyframi od 0 do 9 oraz liczbami od 0 do 999 999 potrzebnych w dleszej części eksperymentu
DROP table Dziesiec;
CREATE TABLE Dziesiec (cyfra INT, bit INT);
INSERT INTO Dziesiec (cyfra, bit)
VALUES
    (0, 0),
    (1, 0),
    (2, 0),
    (3, 0),
    (4, 0),
    (5, 0),
    (6, 0),
    (7, 0),
    (8, 0),
    (9, 0);


CREATE TABLE Milion(liczba int,cyfra int, bit int);
INSERT INTO Milion SELECT a1.cyfra +10* a2.cyfra +100*a3.cyfra + 1000*a4.cyfra
+ 10000*a5.cyfra + 10000*a6.cyfra AS liczba , a1.cyfra AS cyfra, a1.bit AS bit
FROM Dziesiec a1, Dziesiec a2, Dziesiec a3, Dziesiec a4, Dziesiec a5, Dziesiec
a6;

--polecenie pozwalające zwrócić czas wykonania się zapytania w PostgreSQL
--EXPLAIN ANALYZE SELECT ...;

--zapytanie nr 1 bez indeksów
EXPLAIN ANALYZE
SELECT COUNT(*) FROM Milion INNER JOIN zdenormal.GeoTabela ON
(mod(Milion.liczba,68)=(zdenormal.GeoTabela.id_pietro));

--wyniki:
--1. pl. time: 0.635 ms ex. time: 109.505 ms
--2. pl. time: 0.094 ms ex. time: 110.835 ms
--3. pl. time: 0.097 ms ex. time: 116.117 ms
--4. pl. time: 0.093 ms ex. time: 102.193 ms
--5. pl. time: 0.092 ms ex. time: 104.500 ms
--6. pl. time: 0.087 ms ex. time: 102.927 ms
--7. pl. time: 0.083 ms ex. time: 103.114 ms
--8. pl. time: 0.097 ms ex. time: 103.031 ms
--9. pl. time: 0.079 ms ex. time: 105.687 ms
--10. pl. time: 0.081 ms ex. time: 112.604 ms


--zapytanie nr 2 bez indeksów
EXPLAIN ANALYZE
SELECT COUNT(*) FROM Milion INNER JOIN znormal.GeoPietro ON
(mod(Milion.liczba,68)=znormal.GeoPietro.id_pietro) NATURAL JOIN znormal.GeoEpoka NATURAL JOIN
znormal.GeoOkres NATURAL JOIN znormal.GeoEra NATURAL JOIN znormal.GeoEon;

--wyniki:
--1. pl. time: 0.343 ms ex. time: 253.625 ms
--2. pl. time: 0.385 ms ex. time: 269.773 ms
--3. pl. time: 0.283 ms ex. time: 273.875 ms
--4. pl. time: 0.338 ms ex. time: 265.753 ms
--5. pl. time: 0.340 ms ex. time: 254.447 ms
--6. pl. time: 0.343 ms ex. time: 278.201 ms
--7. pl. time: 0.312 ms ex. time: 270.956 ms
--8. pl. time: 0.300 ms ex. time: 270.474 ms
--9. pl. time: 0.262 ms ex. time: 253.734 ms
--10. pl. time: 0.311 ms ex. time: 273.146 ms


--zapytanie nr 3 bez indeksów
EXPLAIN ANALYZE
SELECT COUNT(*) FROM Milion WHERE mod(Milion.liczba,68)=
(SELECT id_pietro FROM zdenormal.GeoTabela WHERE mod(Milion.liczba,68)=(id_pietro));

--wyniki:
--1. pl. time: 0.404 ms ex. time: 5921.053 ms
--2. pl. time: 0.081 ms ex. time: 6004.166 ms
--3. pl. time: 0.110 ms ex. time: 5647.660 ms
--4. pl. time: 0.068 ms ex. time: 5770.503 ms
--5. pl. time: 0.077 ms ex. time: 5685.113 ms
--6. pl. time: 0.066 ms ex. time: 5769.741 ms
--7. pl. time: 0.089 ms ex. time: 5823.660 ms
--8. pl. time: 0.070 ms ex. time: 6011.474 ms
--9. pl. time: 0.064 ms ex. time: 5824.406 ms
--10. pl. time: 0.074 ms ex. time: 5826.843 ms


--zapytanie nr 4 bez indeksów, w artykule zamieszczono błędne zapytanie, poniżej wykorzystane zapytanie z poprawioną składnią
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM Milion
WHERE MOD(Milion.liczba, 68) IN (
    SELECT znormal.GeoPietro.id_pietro
    FROM znormal.GeoPietro
    NATURAL JOIN znormal.GeoEpoka
    NATURAL JOIN znormal.GeoOkres
    NATURAL JOIN znormal.GeoEra
    NATURAL JOIN znormal.GeoEon
);

--wyniki:
--1. pl. time: 0.280 ms ex. time: 104.097 ms
--2. pl. time: 0.310 ms ex. time: 100.688 ms
--3. pl. time: 0.288 ms ex. time: 140.859 ms
--4. pl. time: 0.285 ms ex. time: 105.773 ms
--5. pl. time: 0.292 ms ex. time: 102.896 ms
--6. pl. time: 0.281 ms ex. time: 100.780 ms
--7. pl. time: 0.267 ms ex. time: 102.058 ms
--8. pl. time: 0.271 ms ex. time: 103.111 ms
--9. pl. time: 0.276 ms ex. time: 98.250 ms
--10. pl. time: 0.286 ms ex. time: 107.142 ms




--stworzenie indeksów na wielu kolumnach
CREATE INDEX idx_GeoTabela ON zdenormal.GeoTabela (id_eon, id_era, id_okres, id_epoka, id_pietro, nazwa_pietro, nazwa_epoka, nazwa_okres, nazwa_era, nazwa_eon);
CREATE INDEX idxGeoEon ON znormal.GeoEon (id_eon, nazwa_eon);
CREATE INDEX idxGeoEra ON znormal.GeoEra(id_era, id_eon, nazwa_era);
CREATE INDEX idxGeoOkres ON znormal.GeoOkres(id_okres, id_era, nazwa_okres);
CREATE INDEX idxGeoEpoka ON znormal.GeoEpoka(id_epoka , id_okres, nazwa_epoka);
CREATE INDEX idxGeoPietro ON znormal.GeoPietro(id_pietro, id_epoka, nazwa_pietro);


--zapytanie nr 1 z indeksamim
EXPLAIN ANALYZE
SELECT COUNT(*) FROM Milion INNER JOIN zdenormal.GeoTabela ON
(mod(Milion.liczba,68)=(zdenormal.GeoTabela.id_pietro));

--wyniki:
--1. pl. time: 1.634 ms ex. time: 104.395 ms
--2. pl. time: 0.115 ms ex. time: 102.928 ms
--3. pl. time: 0.134 ms ex. time: 104.952 ms
--4. pl. time: 0.112 ms ex. time: 106.247 ms
--5. pl. time: 0.111 ms ex. time: 105.956 ms
--6. pl. time: 0.109 ms ex. time: 101.381 ms
--7. pl. time: 0.100 ms ex. time: 103.900 ms
--8. pl. time: 0.124 ms ex. time: 103.054 ms
--9. pl. time: 0.128 ms ex. time: 102.506 ms
--10. pl. time: 0.103 ms ex. time: 105.374 ms


--zapytanie nr 2 z indeksami
EXPLAIN ANALYZE
SELECT COUNT(*) FROM Milion INNER JOIN znormal.GeoPietro ON
(mod(Milion.liczba,68)=znormal.GeoPietro.id_pietro) NATURAL JOIN znormal.GeoEpoka NATURAL JOIN
znormal.GeoOkres NATURAL JOIN znormal.GeoEra NATURAL JOIN znormal.GeoEon;

--wyniki:
--1. pl. time: 3.737 ms ex. time: 132.873 ms
--2. pl. time: 0.408 ms ex. time: 152.480 ms
--3. pl. time: 0.488 ms ex. time: 148.278 ms
--4. pl. time: 0.362 ms ex. time: 133.886 ms
--5. pl. time: 0.372 ms ex. time: 149.996 ms
--6. pl. time: 0.405 ms ex. time: 138.769 ms
--7. pl. time: 0.470 ms ex. time: 147.045 ms
--8. pl. time: 0.363 ms ex. time: 136.766 ms
--9. pl. time: 0.379 ms ex. time: 133.431 ms
--10. pl. time: 0.379 ms ex. time: 143.423 ms


--zapytanie nr 3 z indeksami
EXPLAIN ANALYZE
SELECT COUNT(*) FROM Milion WHERE mod(Milion.liczba,68)=
(SELECT id_pietro FROM zdenormal.GeoTabela WHERE mod(Milion.liczba,68)=(id_pietro));

--wyniki:
--1. pl. time: 0.091 ms ex. time: 6071.460 ms
--2. pl. time: 0.089 ms ex. time: 5846.399 ms
--3. pl. time: 0.084 ms ex. time: 5698.123 ms
--4. pl. time: 0.082 ms ex. time: 5943.596 ms
--5. pl. time: 0.091 ms ex. time: 5720.837 ms
--6. pl. time: 0.138 ms ex. time: 5779.708 ms
--7. pl. time: 0.091 ms ex. time: 5742.806 ms
--8. pl. time: 0.086 ms ex. time: 5854.614 ms
--9. pl. time: 0.079 ms ex. time: 5784.902 ms
--10. pl. time: 0.086 ms ex. time: 5876.901 ms


--zapytanie nr 4 z indeksami, w artykule zamieszczono błędne zapytanie, poniżej wykorzystane zapytanie z poprawioną składnią
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM Milion
WHERE MOD(Milion.liczba, 68) IN (
    SELECT znormal.GeoPietro.id_pietro
    FROM znormal.GeoPietro
    NATURAL JOIN znormal.GeoEpoka
    NATURAL JOIN znormal.GeoOkres
    NATURAL JOIN znormal.GeoEra
    NATURAL JOIN znormal.GeoEon
);

--wyniki:
--1. pl. time: 0.394 ms ex. time: 102.229 ms
--2. pl. time: 0.377 ms ex. time: 104.066 ms
--3. pl. time: 0.381 ms ex. time: 106.338 ms
--4. pl. time: 0.375 ms ex. time: 106.228 ms
--5. pl. time: 0.423 ms ex. time: 102.686 ms
--6. pl. time: 0.377 ms ex. time: 99.919 ms
--7. pl. time: 0.363 ms ex. time: 112.789 ms
--8. pl. time: 0.415 ms ex. time: 109.384 ms
--9. pl. time: 0.376 ms ex. time: 104.250 ms
--10. pl. time: 0.419 ms ex. time: 101.182 ms








