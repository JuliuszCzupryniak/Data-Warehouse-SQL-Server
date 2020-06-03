USE [Magazyn_ETL_1]
GO
/****** Object:  StoredProcedure [dbo].[ETL_1_wymiary]    Script Date: 6/3/2020 11:36:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Juliusz Czupryniak>
-- Create date: <26-05-2020>
-- Description:	<ETL dla wymiarów>
-- =============================================
ALTER PROCEDURE [dbo].[ETL_1_wymiary] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
--HIERARCHIA GEOGRAFICZNA
drop table kod_pocztowy_dim;
drop table miasto_dim;
drop table powiat_dim;
drop table wojewodztwo_dim;


--WOJEWODZTWO: TABELA
create table wojewodztwo_dim(
wojewodztwo_kod nvarchar(5) primary key,
wojewodztwo nvarchar(max),
data_dodania datetime);
--WOJEWODZTWO: REKORDY
insert into wojewodztwo_dim
select concat(SUBSTRING(wojewodztwo,1,3),len(wojewodztwo)),wojewodztwo,CURRENT_TIMESTAMP from
(select distinct wojewodztwo from nieruchomosc
union 
select distinct wojewodztwo from pobranie_materialu) woj;

--POWIAT: TABELA
create table powiat_dim(
powiat_kod nvarchar(10) primary key,
powiat nvarchar(max),
wojewodztwo_kod nvarchar(5) references wojewodztwo_dim(wojewodztwo_kod),
data_dodania datetime);
--POWIAT: REKORDY
insert into powiat_dim
select  concat(wojewodztwo_kod,concat(SUBSTRING(powiat,1,3),len(powiat))),powiat,wojewodztwo_kod,CURRENT_TIMESTAMP from
(select distinct wojewodztwo,powiat from nieruchomosc
union 
select distinct wojewodztwo,powiat from pobranie_materialu) POW join
wojewodztwo_dim on pow.wojewodztwo=wojewodztwo_dim.wojewodztwo;

--MIASTO: TABELA
create table miasto_dim(
miasto_kod nvarchar(15) primary key,
miasto nvarchar(max),
powiat_kod nvarchar(10) references powiat_dim(powiat_kod),
data_dodania datetime);
--MIASTO: REKORDY
insert into miasto_dim
select  concat(powiat_kod,concat(SUBSTRING(miasto,1,3),LEN(miasto))),miasto,powiat_kod,CURRENT_TIMESTAMP from
(select distinct powiat,miasto from nieruchomosc
union 
select distinct powiat,miasto from pobranie_materialu) MIA join
powiat_dim on mia.powiat=powiat_dim.powiat;

--KOD_POCZTOWY: TABELA
create table kod_pocztowy_dim(
kod_poczotwy nvarchar(6) primary key,
miasto_kod nvarchar(15) references miasto_dim(miasto_kod),
data_dodania datetime);
--KOD_POCZTOWY: REKORDY
insert into kod_pocztowy_dim
select  kod_pocztowy,miasto_kod,CURRENT_TIMESTAMP from
(select distinct miasto,kod_pocztowy from nieruchomosc
union 
select distinct miasto,kod_pocztowy from pobranie_materialu) kod join
miasto_dim on kod.miasto=miasto_dim.miasto;


--HIERARCHIA NIERUCHOMOSCI
drop table typ_nieruchomosci_dim;
--NIERUCHOMOSC: TABELA
create table  typ_nieruchomosci_dim(
typ_nieruchomosci nvarchar(40) primary key,
rodzaj_nieruchomosci nvarchar(max),
data_dodania datetime);

--NIERUCHOMOSC: REKORDY
insert into typ_nieruchomosci_dim (rodzaj_nieruchomosci,typ_nieruchomosci,data_dodania)
select distinct rodzaj_nieruchomosci,typ_nieruchomosci,CURRENT_TIMESTAMP
from nieruchomosc
order by 1,2;

--HIERARCHIA PRACOWNIKÓW
ALTER SEQUENCE seq_id_dzial RESTART WITH 1 ;
drop table pracownicy_dim;
drop table dzial_dim;
--DZIAŁ: TABELA
create table dzial_dim(
id_dzialu int primary key,
dzial nvarchar(max),
data_dodania datetime);
--DZIAŁ: REKORDY
insert into dzial_dim
select NEXT VALUE FOR seq_id_dzial as id_dzialu, Dzial,CURRENT_TIMESTAMP from 
(select distinct Dzial from pracownik) dzialy;

--PRACOWNICY: TABELA
create table pracownicy_dim(
id_pracownika nvarchar(50) primary key,
nazwisko nvarchar(max),
imie nvarchar(max),
data_zatrudnienia date,
data_zwolnienia date,
pesel numeric(11),
pesel_new numeric(11),
id_dzialu int references dzial_dim(id_dzialu),
data_dodania datetime);

--PRACOWNICY: REKORDY
insert into pracownicy_dim
select CONCAT('SH_',PESEL),IMIE,NAZWISKO,cast(DATA_ZATRUDNIENIA as DATE),cast(DATA_ZWOLNIENIA as DATE),PESEL,PESEL_NEW,ID_DZIALU,CURRENT_TIMESTAMP from pracownik
join dzial_dim on pracownik.DZIAL=dzial_dim.dzial;

--WYMIAR RODZAJU PRACY
drop table rodzaje_pracy_dim;
ALTER SEQUENCE seq_id_rodzaj_pracy RESTART WITH 1;
--RODZAJ PRACY: TABELA
create table rodzaje_pracy_dim(
id_rodzaj_pracy int primary key,
nazwa nvarchar(max),
jed_miary nvarchar(max),
koszt_jed_miary numeric(12,2),
min_norma_na_h numeric(12,2),
max_norma_na_h numeric(12,2),
data_dodania datetime);
--RODZAJ PRACY: REKORDY
insert into rodzaje_pracy_dim
select NEXT VALUE FOR seq_id_rodzaj_pracy as id_rodzaj_pracy, concat(rodzaj_pracy,concat('_',material)),jed_miary,koszt_jed_miary,min_norma_na_h,max_norma_na_h,CURRENT_TIMESTAMP from 
(select distinct rodzaj_pracy,material,jed_miary,koszt_jed_miary,min_norma_na_h,max_norma_na_h from prace_wykonane) dist_rodz_prac;

--MATERIALY: TABELA
update prace_wykonane 
set jed_miary='Kilogram'
where jed_miary like 'K%gram';

update prace_wykonane 
set jed_miary='Metr Kwadratowy'
where jed_miary like 'Me%Kw%ow%';

update prace_wykonane 
set jed_miary='Sztapel'
where material='Kafelki';

drop table materialy_dim;

create table materialy_dim(
id_materialu nvarchar(3) primary key,
nazwa nvarchar(max),
jed_miary nvarchar(max),
koszt_jed_miary numeric(12,2),
data_dodania datetime);
--MATERIALY: REKORDY
insert into materialy_dim
select distinct SUBSTRING(material,1,3),material,jed_miary,koszt_jed_miary,CURRENT_TIMESTAMP from (
select material,null as jed_miary,null as koszt_jed_miary from pobranie_materialu
union
select material,jed_miary,koszt_jed_miary from prace_wykonane
union
select material,null as jed_miary,null as koszt_jed_miary from zakup_materialow) a
where jed_miary is not null or koszt_jed_miary is not null
order by 1;

--WYMIAR FIRMA
drop table firma_dim;
--FIRMA: TABELA
create table firma_dim(
nip numeric(10) primary key,
grupa nvarchar(max),
kraj nvarchar(max),
data_dodania datetime)
--FIRMA: REKORDY
insert into firma_dim
select distinct NIP,grupa,kraj,CURRENT_TIMESTAMP from zakup_sprzetu
union
select NIP,grupa,kraj,CURRENT_TIMESTAMP from zakup_materialow;



END
