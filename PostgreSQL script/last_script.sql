
-----------------------------------------------
DROP TABLE IF EXISTS indicadores;

CREATE TABLE indicadores (
ID VARCHAR(10) PRIMARY KEY,
cod_estado NUMERIC(3),
cod_municipio NUMERIC(4),
pib_usd NUMERIC(15,3),
idx_education NUMERIC(15,3),
idx_health NUMERIC(15,3),
idx_income NUMERIC(15,3),
idx_humandev NUMERIC(15,3),
total_pob  NUMERIC(12,3),
area NUMERIC(15,3),
hab_km2 NUMERIC(15,3),
delitos NUMERIC(15,3),
pop_crimes NUMERIC(15,3),
crime_rate NUMERIC(15,3)
);
---------------------------------------------------
CREATE INDEX IDX01 ON indicadores (cod_estado, cod_municipio);
CLUSTER indicadores USING IDX01;
-- IMPORT WITH WIZARD
-----------------------------------------------------
SELECT * FROM INDICADORES

CREATE VIEW vw_records AS
SELECT * FROM Indicadores

----------------
DROP TABLE IF EXISTS estados;

CREATE TABLE estados (
cod_estado NUMERIC(3) PRIMARY KEY,
estado VARCHAR(150)
);
-----------------------------------------------------
CREATE INDEX IDX02 ON estados (cod_estado);
CLUSTER estados USING IDX02;
------------------------------------------------------
INSERT INTO dbo.estados
SELECT DISTINCT cod_estado, estado FROM dbo.indicadores
ORDER BY cod_estado
------------------------------------------------------------
SELECT * FROM estados
------------------------------------------------------------
DROP TABLE IF EXISTS municipios;

CREATE TABLE municipios (
cod_edo_mun VARCHAR(15) PRIMARY KEY,
cod_estado NUMERIC(3),
cod_municipio NUMERIC(4),
municipio VARCHAR(255)
);
--------------------------------------------------------------
CREATE INDEX IDX03 ON municipios (cod_edo_mun);
CLUSTER municipios USING IDX03;
---------------------------------------------------------------
INSERT INTO dbo.municipios
SELECT DISTINCT CAST(CONCAT(cod_estado,'-', cod_municipio) AS VARCHAR(20)), cod_estado, cod_municipio, municipio FROM dbo.indicadores
ORDER BY cod_estado, cod_municipio
-----------------------------------------------------------------
SELECT * FROM MUNICIPIOS

-------------------------------------------------------------
ALTER TABLE indicadores
RENAME TO indicadores_temporal;
-----------------------------------------------------------------

DROP TABLE IF EXISTS indicadores;

CREATE TABLE indicadores (
cod_edo_mun VARCHAR(15) PRIMARY KEY,
cod_estado NUMERIC(3),
cod_municipio NUMERIC(4),
pib_usd NUMERIC(15,3),
idx_education NUMERIC(15,3),
idx_health NUMERIC(15,3),
idx_income NUMERIC(15,3),
idx_humandev NUMERIC(15,3),
total_pob  NUMERIC(12,3),
area NUMERIC(15,3),
hab_km2 NUMERIC(15,3),
delitos NUMERIC(15,3),
pop_crimes NUMERIC(15,3),
crime_rate NUMERIC(15,3)
);
----------------------------------------------------------------------------------
CREATE INDEX IDX04 ON indicadores (cod_edo_mun);
CLUSTER indicadores USING IDX04;

SELECT * FROM INDICADORES

-----------------------------------------------------------------------------------
INSERT INTO indicadores
SELECT 
CAST(CONCAT(cod_estado,'-', cod_municipio) AS VARCHAR(20)),
cod_estado,
cod_municipio,
pib_usd,
idx_education,
idx_health,
idx_income
idx_humandev,
total_pob,
area,
hab_km2,
delitos,
pop_crimes,
crime_rate
FROM indicadores_temporal
ORDER BY cod_estado, cod_municipio
-----------------------------------------------------------------------------------------
SELECT * FROM indicadores
DROP TABLE indicadores_temporal
---------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS states_coords;

CREATE TABLE states_coords(
	cod_edo_mun VARCHAR(15) PRIMARY KEY,
    cod_estado numeric(3),
    cod_municipio numeric(4),
    ctype character varying(100) COLLATE pg_catalog."default",
    coords text COLLATE pg_catalog."default"
)
--------------------------------------------------------------------------------------------
CREATE INDEX IDX05 ON states_coords (cod_edo_mun);
CLUSTER states_coords USING IDX05;
--------------------------------------------------------------------------------------------
INSERT INTO dbo.states_coords
SELECT 
CAST(CONCAT(c_estado,'-', c_mnpio) AS VARCHAR(20)),
c_estado,
c_mnpio,
ctype,
coords
FROM dbo.states_coords_temporal
ORDER BY c_estado, c_mnpio
-----------------------------------------------------------------------------------------------
SELECT * FROM states_coords
---------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS houses_temporal;

CREATE TABLE houses_temporal (
ID VARCHAR(1000),
clasificacion VARCHAR(1000),
tipo VARCHAR(1000),
estado VARCHAR(1000),
municipio VARCHAR(1000),
colonia VARCHAR(1000),
Descripcion VARCHAR(1000),
calle VARCHAR(1000),
precio VARCHAR(1000),	
st VARCHAR(1000),
sc VARCHAR(1000),
recamaras VARCHAR(1000),	
banos VARCHAR(1000),
medio_banos VARCHAR(1000),
estacionamientos VARCHAR(1000),
url VARCHAR(1000),
lat  VARCHAR(1000),
lon  VARCHAR(1000),
ageb VARCHAR(1000),
cp VARCHAR(1000),
gral_area VARCHAR(1000)	
);
---------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS houses;

CREATE TABLE houses (
ID SERIAL PRIMARY KEY,
clasif VARCHAR(20),
tipo VARCHAR(20),
estado VARCHAR(25),
municipio VARCHAR(50),
colonia VARCHAR(105),
descripcion VARCHAR(110),
calle VARCHAR(240),
precio NUMERIC(15,3),	
st NUMERIC(15,3),
sc NUMERIC(15,3),
recamaras INTEGER,	
banos INTEGER,
medio_banos INTEGER,
estacionamientos INTEGER,
url VARCHAR(120),
lat  NUMERIC(21,9),
lon  NUMERIC(21,9),
ageb VARCHAR(15),
cp VARCHAR(8),
gral_area NUMERIC(15,3)
);

------------------------------------------------------------------
-----------------------------------------------------
INSERT INTO houses(clasif, tipo, estado, municipio, colonia, descripcion, calle, precio, st,sc, recamaras, banos, medio_banos, estacionamientos, url, lat, lon, ageb, cp, gral_area)
SELECT clasificacion, tipo, estado, municipio, colonia, descripcion, calle,
CAST(precio AS NUMERIC(15,3)),
CAST(st AS NUMERIC(15,3)),
CAST(sc AS NUMERIC(15,3)),
CAST(recamaras AS INT),
CAST(banos AS INT),
CAST(medio_banos AS INT),
CAST(estacionamientos AS INT),
url, 
CAST(lat AS NUMERIC(21,9)),
CAST(lon AS NUMERIC(21,9)),
ageb,
cp,
CAST(gral_area AS NUMERIC(15,3))
FROM houses_temporal
--------------------------------------------------------------------------------------
SELECT * FROM houses LIMIT 100
DROP TABLE houses_temporal
--------------------------------------------------------------------------------------
DROP TABLE IF EXISTS agebs;

CREATE TABLE agebs (
ID VARCHAR(20),
objectid VARCHAR(20),
ageb VARCHAR(20),
cve_ent VARCHAR(25),
cve_mun VARCHAR(25),
cve_loc VARCHAR(25),
cve_ageb VARCHAR(25),
ambito VARCHAR(50),
shape_len VARCHAR(100),	
shape_area VARCHAR(100),
geometry TEXT
);
-------------------------------------------------------------------------------------
ALTER TABLE agebs
ALTER COLUMN cve_ent TYPE NUMERIC(3),
ALTER COLUMN cve_mun TYPE NUMERIC(4);


--------------------------------------------------------------------------------------
DROP TABLE IF EXISTS postal_codes;

CREATE TABLE postal_codes (
ID VARCHAR(20),
cp VARCHAR(20),
geometry TEXT
);
---------------------------------------------------------------------------------------
CREATE ROLE postgres_ro_group;

-- Grant access to existing tables
GRANT USAGE ON SCHEMA public TO postgres_ro_group;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO postgres_ro_group;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO postgres_ro_group;

-- Grant access to future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO postgres_ro_group;

-- Create a final user with password
CREATE USER postgres_ro WITH PASSWORD 'secret';
GRANT postgres_ro_group TO postgres_ro;

--
-- Superuser 
--

-- Create a final user with password
CREATE USER postgres_adm WITH PASSWORD 'secret';
GRANT rds_superuser to postgres_adm;
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS ageb_precio_promedio

CREATE TABLE ageb_precio_promedio (
ageb VARCHAR(25),
ingreso_medio NUMERIC(25,10)
);
-------------------------

-----------------------------------------------------------------------------------------------
WITH CTE_AGEBS AS (
SELECT ageb, cve_ent, cve_mun 
FROM agebs
)

SELECT a.*, CAST(b.cve_ent as NUMERIC(3)), CAST(b.cve_mun as NUMERIC(4)) 
INTO houses_final
FROM houses as a INNER JOIN CTE_AGEBS as b ON a.ageb = b.ageb
------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS rep_municipios	;

SELECT  
		CONCAT(a.cve_ent,'-',a.cve_mun ) as id_edo_mun,
		a.cve_ent as cod_estado,
		a.cve_mun as cod_municipio,
		b.estado,
		c.municipio,
		avg(precio) as avg_precio,
		count(a.id) as count_inmuebles,
		avg(a.gral_area) as avg_superficie,
		avg(a.precio) / avg(a.gral_area) as avg_precio_m2,
		avg(idx_humandev) as avg_idh,
		avg(idx_income) as avg_income,
		avg(idx_health) as avg_health,
		avg(idx_education) as avg_education,
		avg(recamaras) as avg_recamaras,
		avg(banos) as avg_banos,
		avg(estacionamientos) as avg_estacionamientos
		
INTO rep_municipios		
FROM houses_final as a
INNER JOIN estados as b ON a.cve_ent = b.cod_estado
INNER JOIN municipios as c ON a.cve_ent = c.cod_estado AND a.cve_mun = c.cod_municipio
INNER JOIN indicadores as d ON a.cve_ent = d.cod_estado AND a.cve_mun = d.cod_municipio

GROUP BY a.cve_ent, a.cve_mun, b.estado, c.municipio
ORDER BY a.cve_ent, a.cve_mun
------------------------------------------------------
DROP TABLE IF EXISTS rep_estados;	

SELECT  a.cve_ent as cod_estado,
		b.estado,
		avg(precio) as avg_precio,
		count(a.id) as count_inmuebles,
		avg(a.gral_area) as avg_superficie,
		avg(a.precio) / avg(a.gral_area) as avg_precio_m2,
		avg(idx_humandev) as avg_idh,
		avg(idx_income) as avg_income,
		avg(idx_health) as avg_health,
		avg(idx_education) as avg_education,
		avg(recamaras) as avg_recamaras,
		avg(banos) as avg_banos,
		avg(estacionamientos) as avg_estacionamientos
		
INTO rep_estados	
FROM houses_final as a
INNER JOIN estados as b ON a.cve_ent = b.cod_estado
INNER JOIN indicadores as d ON a.cve_ent = d.cod_estado AND a.cve_mun = d.cod_municipio

GROUP BY a.cve_ent, b.estado
ORDER BY a.cve_ent
------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_records;

CREATE VIEW vw_records as
SELECT id, cve_ent as cod_estado, estado, cve_mun as cod_municipio,  municipio, colonia, calle, descripcion, precio, url
FROM houses_final
------------------------------------------------------------------------------------------------

SELECT * FROM INDICADORES

---------------------------------------------------------------------------------------
ALTER TABLE estados
ADD COLUMN properties_num int ;

ALTER TABLE municipios
ADD COLUMN properties_num int ;
--------------------------------------------------------------------------------------------------
WITH CTE_COUNT AS (

SELECT cve_ent, count(*) as recs FROM houses_final GROUP BY cve_ent

)

UPDATE estados
SET properties_num = CTE_COUNT.recs
FROM CTE_COUNT
WHERE estados.cod_estado = CTE_COUNT.cve_ent;
--------------------------------------------------------------------------------------------------
WITH CTE_COUNT AS (

SELECT cve_ent, cve_mun, count(*) as recs FROM houses_final GROUP BY cve_ent, cve_mun

)

UPDATE municipios
SET properties_num = CTE_COUNT.recs
FROM CTE_COUNT
WHERE municipios.cod_estado = CTE_COUNT.cve_ent AND municipios.cod_municipio = CTE_COUNT.cve_mun;

--------------------------------------
UPDATE estados
SET properties_num = CASE WHEN properties_num IS NULL THEN 0 ELSE properties_num END

UPDATE municipios
SET properties_num = CASE WHEN properties_num IS NULL THEN 0 ELSE properties_num END

-------------
DROP VIEW IF EXISTS vw_data_map;

CREATE VIEW vw_data_map as
SELECT id, lat, lon, url, precio, colonia, calle, descripcion, cp, cve_ent as cod_estado, cve_mun as cod_municipio
FROM houses_final

