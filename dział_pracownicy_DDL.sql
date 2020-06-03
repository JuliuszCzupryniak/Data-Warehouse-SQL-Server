create table dzial(
id_dzialu int primary key,
dzial nvarchar(max));

create table pracownicy(
id_pracownika int primary key,
nazwisko nvarchar(max),
imie nvarchar(max),
data_zatrudnienia date,
data_zwolnienia date,
pesel numeric(11),
pesel_new numeric(11),
id_dzialu int references dzial(id_dzialu));

select * from dzial;
select * from pracownicy;

