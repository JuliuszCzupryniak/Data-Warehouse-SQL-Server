create table wojewodztwo(
wojewodztwo_kod nvarchar(5) primary key,
wojewodztwo nvarchar(max));

create table powiat(
powiat_kod nvarchar(10) primary key,
powiat nvarchar(max),
wojewodztwo_kod nvarchar(5) references wojewodztwo(wojewodztwo_kod));

create table miasto(
miasto_kod nvarchar(15) primary key,
miasto nvarchar(max),
powiat_kod nvarchar(10) references powiat(powiat_kod));

create table kod_pocztowy(
kod_pocztowy nvarchar(6) primary key,
miasto_kod nvarchar(15) references miasto(miasto_kod));



create table typ_nieruchomosci(
typ_nieruchomosci nvarchar(40) primary key,
rodzaj_nieruchomosci nvarchar(max));