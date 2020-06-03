USE [Magazyn_ETL_1]
GO
/****** Object:  StoredProcedure [dbo].[ETL_2_Wymiary]    Script Date: 6/3/2020 11:37:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juliusz Czupryniak
-- Create date: 28.05.2020
-- Description:	ETL dla wymiarow docelowych
-- =============================================
ALTER PROCEDURE [dbo].[ETL_2_Wymiary] 

AS
BEGIN
insert into Model_wymiarowy.dbo.wojewodztwo
select wojewodztwo_kod,wojewodztwo from Magazyn_ETL_1.dbo.wojewodztwo_dim
except
select wojewodztwo_kod,wojewodztwo from Model_wymiarowy.dbo.wojewodztwo;


insert into Model_wymiarowy.dbo.powiat
select powiat_kod,powiat,wojewodztwo_kod from Magazyn_ETL_1.dbo.powiat_dim
except
select powiat_kod,powiat,wojewodztwo_kod from Model_wymiarowy.dbo.powiat;


insert into Model_wymiarowy.dbo.miasto
select miasto_kod,miasto,powiat_kod from Magazyn_ETL_1.dbo.miasto_dim
except
select miasto_kod,miasto,powiat_kod from Model_wymiarowy.dbo.miasto;

insert into Model_wymiarowy.dbo.kod_pocztowy
select kod_poczotwy,miasto_kod from Magazyn_ETL_1.dbo.kod_pocztowy_dim
except 
select kod_pocztowy,miasto_kod from Model_wymiarowy.dbo.kod_pocztowy;

insert into Model_wymiarowy.dbo.typ_nieruchomosci
select typ_nieruchomosci,rodzaj_nieruchomosci from Magazyn_ETL_1.dbo.typ_nieruchomosci_dim
except
select typ_nieruchomosci,rodzaj_nieruchomosci from Model_wymiarowy.dbo.typ_nieruchomosci;

insert into Model_wymiarowy.dbo.czas
select * from Magazyn_ETL_1.dbo.czas
except
select * from Model_wymiarowy.dbo.czas;





END
