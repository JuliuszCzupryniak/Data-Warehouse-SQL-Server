create table rodzaje_pracy
(
id_rodzaj_pracy int primary key,
nazwa nvarchar(max),
jed_miary nvarchar(max),
koszt_jed_miary numeric(12,2),
min_norma_na_h int,
max_norma_na_h int);

create table materialy(
id_materialu nvarchar(3) primary key,
nazwa nvarchar(max),
jed_miary nvarchar(max),
koszt_jed_miary numeric(12,2));

create table mat_do_rodz_prac(
id int primary key,
id_rodz_pracy int references rodzaje_pracy(id_rodzaj_pracy),
id_materialu nvarchar(3) references materialy(id_materialu),
ilosc_min numeric(12,2),
ilosc_max numeric(12,2));
