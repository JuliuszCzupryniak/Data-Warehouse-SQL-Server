create table wyplata(
id_pracownika int references pracownicy(id_pracownika),
data_wyplaty date references czas(data_),
przepracowane_godziny int,
wyplata numeric(12,2)
constraint PK_wyplata primary key(id_pracownika,data_wyplaty));


create table sprzedaz_nieruchomosci(
id_nieruchomosci nvarchar(20),
data_kupna date references czas(data_),
typ_nieruchomosci nvarchar(40) references typ_nieruchomosci(typ_nieruchomosci),
cena numeric(12,2),
metraz int,
koszt_wytworzenia numeric(10,2),
kod_pocztowy nvarchar(6) references kod_pocztowy(kod_pocztowy),
wazny_od datetime,
wazny_do datetime,
constraint PK_sprzedaz_nieruchomosci primary key(id_nieruchomosci));

create table prace_wykonane(
id_pracy_wykonanej int primary key,
id_pracownika int references pracownicy(id_pracownika),
id_rodz_pracy int references rodzaje_pracy(id_rodzaj_pracy),
data_od date references czas(data_),
data_do date references czas(data_),
kod_pocztowy nvarchar(6) references kod_pocztowy(kod_pocztowy),
ilosc_pracy int);

create table wejscie_w_ogloszenie(
ip_goscia nvarchar(15),
id_nieruchomosci int,
data_wejscia date references czas(data_),
typ_nieruchomosci nvarchar(40) references typ_nieruchomosci(typ_nieruchomosci),
kod_pocztowy nvarchar(6) references kod_pocztowy(kod_pocztowy),
czas int,
constraint PK_wejscie_w_ogloszenie primary key(ip_goscia,id_nieruchomosci,data_wejscia));
