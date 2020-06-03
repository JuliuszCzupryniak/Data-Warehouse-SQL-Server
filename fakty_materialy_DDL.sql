create table zuzycie_mater(
id_zuz_mat int primary key,
id_pracy_wykonanej int references prace_wykonane(id_pracy_wykonanej),
id_material nvarchar(3) references materialy(id_materialu),
ilosc_mat numeric(12,2));

create table pobranie_materialu(
id_pobrania int,
id_pracownika int references pracownicy(id_pracownika),
id_materialu nvarchar(3) references materialy(id_materialu),
ilosc_wzietych numeric(12,2),
ilosc_zwroconych numeric(12,2),
data_pobrania date references czas(data_),
kod_pocztowy nvarchar(6) references kod_pocztowy(kod_pocztowy),
constraint PK_pobranie_materialu primary key (id_pobrania,id_materialu));

create table zakup_sprzetu(
id_zakupu int primary key,
nip numeric(10) references firma(nip),
data_kupna date references czas(data_),
ilosc int,
koszt numeric(12,2));

create table zakup_materialu(
id_zakupu int primary key,
nip numeric(10) references firma(nip),
data_kupna date references czas(data_),
id_materialu nvarchar(3) references materialy(id_materialu),
ilosc int,
koszt numeric(12,2));
