create table czas(
data_ date primary key,
dzien int,
miesiac int,
kwartal int,
rok int,
dzien_tygodnia nvarchar(max));

create table firma(
nip numeric(10) primary key,
grupa nvarchar(max),
kraj nvarchar(max));