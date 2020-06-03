USE [Magazyn_ETL_1]
GO
/****** Object:  StoredProcedure [dbo].[ETL_4_Errory]    Script Date: 6/3/2020 11:37:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juliusz Czupryniak
-- Create date: 03.06.2020
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[ETL_4_Errory] 

AS
BEGIN
delete sprzedaz_nieruchomosci_temp;
delete sprzedaz_nieruchomosci_insert;
delete sprzedaz_nieruchomosci_update;
insert into sprzedaz_nieruchomosci_temp
select * from sprzedaz_nieruchomosci_errors;
EXEC ETL_1_wymiary;
EXEC ETL_2_Wymiary;
delete sprzedaz_nieruchomosci_errors;
--	REKORDY
insert into sprzedaz_nieruchomosci_insert
select id_nieruchomosci,data_kupna,typ_nieruchomosci,cena,metraz,koszt_wytworzenia,kod_pocztowy from Magazyn_ETL_1.dbo.sprzedaz_nieruchomosci_temp
where Magazyn_ETL_1.dbo.sprzedaz_nieruchomosci_temp.id_nieruchomosci not in (select id_nieruchomosci from Model_wymiarowy.dbo.sprzedaz_nieruchomosci );


insert into sprzedaz_nieruchomosci_update
select id_nieruchomosci,data_kupna,typ_nieruchomosci,cena,metraz,koszt_wytworzenia,kod_pocztowy from Magazyn_ETL_1.dbo.sprzedaz_nieruchomosci_temp
where Magazyn_ETL_1.dbo.sprzedaz_nieruchomosci_temp.id_nieruchomosci in (select id_nieruchomosci from Model_wymiarowy.dbo.sprzedaz_nieruchomosci );

--ZMIENNE DO INSERTOWANIA/UPDATOWANIA
declare @id nvarchar(20);
declare @data_kupna date;
declare @typ_nieruchomosci nvarchar(40);
declare @cena numeric(12,2)
declare @metraz int;
declare @koszt_wytworzenia numeric(12,2);
declare @kod_pocztowy nvarchar(6);
--WARTOŚCI DO PORÓWNANIA
declare @p_id nvarchar(20);
declare @p_data_kupna date;
declare @p_typ_nieruchomosci nvarchar(40);
declare @p_cena numeric(12,2)
declare @p_metraz int;
declare @p_koszt_wytworzenia numeric(12,2);
declare @p_kod_pocztowy nvarchar(6);


--KURSOR UPDATE
declare cur_update CURSOR
	FOR select * from sprzedaz_nieruchomosci_update;
OPEN cur_update
FETCH NEXT FROM cur_update into @id,@data_kupna,@typ_nieruchomosci,@cena,@metraz,@koszt_wytworzenia,@kod_pocztowy;
WHILE @@FETCH_STATUS = 0
BEGIN
	BEGIN TRY
		IF ((@data_kupna = (select data_kupna from Model_wymiarowy.dbo.sprzedaz_nieruchomosci where id_nieruchomosci=@id and wazny_do is null))
		AND (@typ_nieruchomosci = (select typ_nieruchomosci from Model_wymiarowy.dbo.sprzedaz_nieruchomosci where id_nieruchomosci=@id and wazny_do is null))
		AND (@cena = (select cena from Model_wymiarowy.dbo.sprzedaz_nieruchomosci where id_nieruchomosci=@id and wazny_do is null))
		AND (@metraz = (select metraz from Model_wymiarowy.dbo.sprzedaz_nieruchomosci where id_nieruchomosci=@id and wazny_do is null))
		AND (@koszt_wytworzenia = (select koszt_wytworzenia from Model_wymiarowy.dbo.sprzedaz_nieruchomosci where id_nieruchomosci=@id and wazny_do is null))
		AND (@kod_pocztowy = (select kod_pocztowy from Model_wymiarowy.dbo.sprzedaz_nieruchomosci where id_nieruchomosci=@id and wazny_do is null)))
		BEGIN
		select NULL;
		END
		ELSE
		BEGIN
			update Model_wymiarowy.dbo.sprzedaz_nieruchomosci
			set wazny_do=CURRENT_TIMESTAMP
			where
			id_nieruchomosci=@id and wazny_do is NULL;
			insert into Model_wymiarowy.dbo.sprzedaz_nieruchomosci(id_nieruchomosci,data_kupna,typ_nieruchomosci,cena,metraz,koszt_wytworzenia,kod_pocztowy,wazny_od,wazny_do) Values (@id,@data_kupna,@typ_nieruchomosci,@cena,@metraz,@koszt_wytworzenia,@kod_pocztowy,CURRENT_TIMESTAMP,NULL);
		END
	END TRY
	BEGIN CATCH
		insert into sprzedaz_nieruchomosci_errors(id_nieruchomosci,data_kupna,typ_nieruchomosci,cena,metraz,koszt_wytworzenia,kod_pocztowy) Values (@id,@data_kupna,@typ_nieruchomosci,@cena,@metraz,@koszt_wytworzenia,@kod_pocztowy);
	END CATCH
FETCH NEXT FROM cur_update into @id,@data_kupna,@typ_nieruchomosci,@cena,@metraz,@koszt_wytworzenia,@kod_pocztowy;
END;
CLOSE cur_update;
DEALLOCATE cur_update;


--KURSOR INSERTY
declare cur_ins CURSOR
	FOR select * from sprzedaz_nieruchomosci_insert;
OPEN cur_ins
FETCH NEXT FROM cur_ins into @id,@data_kupna,@typ_nieruchomosci,@cena,@metraz,@koszt_wytworzenia,@kod_pocztowy;
WHILE @@FETCH_STATUS = 0
BEGIN
	BEGIN TRY
		insert into Model_wymiarowy.dbo.sprzedaz_nieruchomosci(id_nieruchomosci,data_kupna,typ_nieruchomosci,cena,metraz,koszt_wytworzenia,kod_pocztowy,wazny_od,wazny_do) Values (@id,@data_kupna,@typ_nieruchomosci,@cena,@metraz,@koszt_wytworzenia,@kod_pocztowy,CURRENT_TIMESTAMP,NULL);
	END TRY
	BEGIN CATCH
		insert into sprzedaz_nieruchomosci_errors(id_nieruchomosci,data_kupna,typ_nieruchomosci,cena,metraz,koszt_wytworzenia,kod_pocztowy) Values (@id,@data_kupna,@typ_nieruchomosci,@cena,@metraz,@koszt_wytworzenia,@kod_pocztowy);
	END CATCH
FETCH NEXT FROM cur_ins into @id,@data_kupna,@typ_nieruchomosci,@cena,@metraz,@koszt_wytworzenia,@kod_pocztowy;
END;
CLOSE cur_ins;
DEALLOCATE cur_ins;


update Model_wymiarowy.dbo.sprzedaz_nieruchomosci
set wazny_do = CURRENT_TIMESTAMP
where id_nieruchomosci in (select id_nieruchomosci from Model_wymiarowy.dbo.sprzedaz_nieruchomosci
where wazny_do is null and id_nieruchomosci not in (select id_nieruchomosci from sprzedaz_nieruchomosci_temp));
END
