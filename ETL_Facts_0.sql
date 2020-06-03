USE [Magazyn_ETL_1]
GO
/****** Object:  StoredProcedure [dbo].[ETL_0_fakty]    Script Date: 6/3/2020 11:35:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juliusz Czupryniak
-- Create date: 1.06.2020
-- Description:	Integracja dwóch źródeł z kluczem hurtownianym
-- =============================================
ALTER PROCEDURE [dbo].[ETL_0_fakty] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
drop table nieruchomosc;

create table nieruchomosc(
id_nieruchomosci nvarchar(20) primary key,
typ_nieruchomosci nvarchar(max),
rodzaj_nieruchomosci nvarchar(max),
kod_pocztowy nvarchar(6),
miasto nvarchar(max),
powiat nvarchar(max),
wojewodztwo nvarchar(max),
kupiony int,
koszt_wytworzenia numeric(12,2),
cena numeric(12,2),
metraz int,
data_kupna date)

insert into nieruchomosc
select CONCAT('MAZ',CONCAT('_',id_nieruchomosci)),typ_nieruchomosci,rodzaj_nieruchomosci,kod_pocztowy,miasto,powiat,wojewodztwo,kupiony,koszt_wytworzenia,cena,metraz,data_kupna
from nieruchomosc_maz;
insert into nieruchomosc
select CONCAT('INNE',CONCAT('_',id_nieruchomosci)),typ_nieruchomosci,rodzaj_nieruchomosci,kod_pocztowy,miasto,powiat,wojewodztwo,kupiony,koszt_wytworzenia,cena,metraz,data_kupna
from nieruchomosc_inne;
END
