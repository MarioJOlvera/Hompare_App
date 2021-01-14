------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS dbo.house_prices_alt;

CREATE TABLE dbo.house_prices_alt (
c_estado NUMERIC(3),
c_mnpio NUMERIC(4),
ciudad VARCHAR(100),
municipio VARCHAR(255),
colonia VARCHAR(255),
precio NUMERIC(15,3),
superficie_t NUMERIC(15,3),
superficie_c NUMERIC(15,3),
recamaras NUMERIC(15,3),
banos NUMERIC(15,3),
url TEXT,
lat NUMERIC(15,8),
lon NUMERIC(15,8),
c_estado2 NUMERIC(3),
c_mnpio2 NUMERIC(4)
);
	
CREATE INDEX IDX07 ON dbo.house_prices_alt (c_estado, c_mnpio);
CLUSTER dbo.house_prices_alt USING IDX07;

ALTER TABLE dbo.house_prices
ADD COLUMN id SERIAL PRIMARY KEY;
------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS dbo.indicadores;

CREATE TABLE dbo.indicadores (
c_estado NUMERIC(3),
c_mnpio NUMERIC(4),
estado VARCHAR(150),
municipio VARCHAR(255),
geometry TEXT,
yr_prom_educ NUMERIC(15,3),
yr_esp_educ NUMERIC(15,3),
pib_anual_dls NUMERIC(15,3),
tasa_mor_inf NUMERIC(8,3),
indice_edu NUMERIC(8,3),
indice_salu  NUMERIC(8,3),
indice_inc  NUMERIC(8,3),
idh NUMERIC(8,3),
pos_idh_2015 NUMERIC(5),
robo NUMERIC(6),
homicidio NUMERIC(6),
secuestro NUMERIC(6),
feminicidio NUMERIC(6),
abuso_Sexual NUMERIC(6),
lesiones NUMERIC(6)
);

CREATE INDEX IDX02 ON dbo.indicadores (c_estado, c_mnpio);
CLUSTER dbo.indicadores USING IDX02;

ALTER TABLE dbo.indicadores
ADD COLUMN id SERIAL PRIMARY KEY;
------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS dbo.house_prices;

CREATE TABLE dbo.house_prices (
c_estado NUMERIC(3),
c_tipo_asenta NUMERIC(3),
c_mnpio NUMERIC(4),
ciudad VARCHAR(100),
municipio VARCHAR(255),
colonia VARCHAR(255),
precio NUMERIC(15,3),
supeficie_t NUMERIC(15,3),
supeficie_c NUMERIC(15,3),
recamaras NUMERIC(15,3),
banos NUMERIC(15,3),
estacionamientos NUMERIC(15,3)
);
	
CREATE INDEX IDX03 ON dbo.house_prices (c_estado, c_mnpio);
CLUSTER dbo.house_prices USING IDX03;

ALTER TABLE dbo.house_prices
ADD COLUMN id SERIAL PRIMARY KEY;
--------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS dbo.states_coords;

CREATE TABLE dbo.states_coords (
c_estado NUMERIC(3),
c_mnpio NUMERIC(4),
municipio VARCHAR(255),
ctype varchar(100),
coords TEXT
)

CREATE INDEX IDX04 ON dbo.states_coords (c_estado, c_mnpio);
CLUSTER dbo.states_coords USING IDX04;

--------------------------------------------------------------------------------------------------------------------------
COPY dbo.house_data FROM '/home/mario/Descargas/Final_Data.csv' HEADER CSV;
COPY dbo.indicadores FROM '/home/mario/Documentos/Indicadores_DFdl.csv' HEADER CSV;
COPY dbo.house_prices FROM '/home/mario/Documentos/PropiedadesMegalopolisDL.csv' HEADER CSV;
COPY dbo.house_prices_alt FROM '/home/mario/Documentos/PropiedadesMegalopolis.csv' HEADER CSV;
--------------------------------------------------------------------------------------------------------------------------
SELECT COUNT(*) FROM dbo.house_data
SELECT COUNT(*) FROM dbo.indicadores

--------------------------------------------------------------------------------------------------------------------------
ALTER TABLE dbo.house_data
	ADD COLUMN id SERIAL PRIMARY KEY;

--------------------------------------------------------------------------------------------------------------------------
PGPASSWORD=xxxxxx pg_dump -Fc --no-acl --no-owner -h localhost -U postgres itesm_project2 > project2.dump
--------------------------------------------------------------------------------------------------------------------------
SELECT * FROM DBO.INDICADORES
SELECT * FROM DBO.HOUSE_PRICES
-------------------------------------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS dbo.VW_Datos_Estado;
	
CREATE VIEW DBO.VW_Datos_Estado AS

	SELECT 
		   IND.C_ESTADO,
		   IND.ESTADO,
		   AVG(IND.IDH) AS PROM_IDH,
		   AVG(IND.INDICE_SALU) AS PROM_INDICE_SALUD,
		   AVG(IND.INDICE_INC) AS PROM_INDICE_INGRESO,
		   AVG(IND.INDICE_EDU) AS PROM_INDICE_EDUCACION,
		   SUM(IND.FEMINICIDIO) AS SUM_FEMINICIDIOS,
		   SUM(IND.HOMICIDIO) AS SUM_HOMICIDIOS,
		   SUM(IND.ROBO) AS SUM_ROBOS,
	  	   SUM(IND.LESIONES) AS SUM_LESIONES,
	  	   SUM(IND.ABUSO_SEXUAL) AS SUM_ABUSO_SEXUAL,
	  	   SUM(IND.SECUESTRO) AS SUM_SECUESTRO,	   
	  	   COUNT(PRC.ID) AS NO_INMUEBLES,
		   AVG(PRC.PRECIO) AS PROM_PRECIO,
		   AVG(PRC.SUPEFICIE_T) AS PROM_TERRENO,
		   AVG(PRC.SUPEFICIE_C) AS PROM_CONSTRUCCION,  
		   AVG(PRC.RECAMARAS) AS PROM_RECAMARAS,
		   ROW_NUMBER() OVER (ORDER by IND.ESTADO) AS id
	FROM DBO.INDICADORES AS IND
	INNER JOIN DBO.HOUSE_PRICES AS PRC
	ON IND.C_ESTADO = PRC.C_ESTADO AND
	   IND.C_MNPIO = PRC.C_MNPIO
	
	GROUP BY IND.C_ESTADO, IND.ESTADO;
-------------------------------------------------------------------------------------------------------------------------	
DROP VIEW IF EXISTS dbo.VW_Datos_Municipio;
	
CREATE VIEW DBO.VW_Datos_Municipio AS

	SELECT 
		   IND.C_ESTADO,
		   IND.ESTADO,
		   IND.C_MNPIO,
		   IND.MUNICIPIO,
		   AVG(IND.IDH) AS PROM_IDH,
		   AVG(IND.INDICE_SALU) AS PROM_INDICE_SALUD,
		   AVG(IND.INDICE_INC) AS PROM_INDICE_INGRESO,
		   AVG(IND.INDICE_EDU) AS PROM_INDICE_EDUCACION,
		   SUM(IND.FEMINICIDIO) AS SUM_FEMINICIDIOS,
		   SUM(IND.HOMICIDIO) AS SUM_HOMICIDIOS,
		   SUM(IND.ROBO) AS SUM_ROBOS,
	  	   SUM(IND.LESIONES) AS SUM_LESIONES,
	  	   SUM(IND.ABUSO_SEXUAL) AS SUM_ABUSO_SEXUAL,
	  	   SUM(IND.SECUESTRO) AS SUM_SECUESTRO,	   
	  	   COUNT(PRC.ID) AS NO_INMUEBLES,
		   AVG(PRC.PRECIO) AS PROM_PRECIO,
		   AVG(PRC.SUPEFICIE_T) AS PROM_TERRENO,
		   AVG(PRC.SUPEFICIE_C) AS PROM_CONSTRUCCION,  
		   AVG(PRC.RECAMARAS) AS PROM_RECAMARAS,
		   CONCAT(IND.C_ESTADO, IND.C_MNPIO) as id
	FROM DBO.INDICADORES AS IND
	INNER JOIN DBO.HOUSE_PRICES AS PRC
	ON IND.C_ESTADO = PRC.C_ESTADO AND
	   IND.C_MNPIO = PRC.C_MNPIO
	
	GROUP BY IND.C_ESTADO, IND.ESTADO, IND.C_MNPIO, IND.MUNICIPIO;

--------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS dbo.VW_Map;
	
CREATE VIEW DBO.VW_Map AS

	SELECT 
		   IND.C_ESTADO,
		   IND.ESTADO,
		   IND.C_MNPIO,
		   IND.MUNICIPIO,
		   COORDS.CTYPE,
		   COORDS.COORDS,
		   AVG(IND.IDH) AS PROM_IDH,
		   AVG(PRC.PRECIO) AS PROM_PRECIO,
		   AVG(IND.PIB_ANUAL_DLS) AS PROM_INGRESO,
		   CAST(AVG(PRC.PRECIO / PRC.SUPEFICIE_T) AS NUMERIC(15,2)) AS PROM_PRECIO_M2,
		   CAST(AVG(PRC.PRECIO / PRC.SUPEFICIE_c) AS NUMERIC(15,2)) PROM_PRECIOC_M2,
		   COUNT(PRC.ID) AS NUMERO_PROPIEDADES,
	      ROW_NUMBER() OVER (ORDER by IND.ESTADO, IND.MUNICIPIO) as id
	FROM DBO.INDICADORES AS IND
	INNER JOIN DBO.STATES_COORDS AS COORDS
	ON IND.C_ESTADO = COORDS.C_ESTADO AND
	   IND.C_MNPIO = COORDS.C_MNPIO
	INNER JOIN DBO.HOUSE_PRICES AS PRC
	ON IND.C_ESTADO = PRC.C_ESTADO AND
	   IND.C_MNPIO = PRC.C_MNPIO
	GROUP BY IND.C_ESTADO, IND.ESTADO, IND.C_MNPIO, IND.MUNICIPIO, COORDS.CTYPE, COORDS.COORDS; 
-----------------------------------------------------------------------------------------
DROP VIEW IF EXISTS dbo.VW_Records;
	
CREATE VIEW DBO.VW_Records AS

SELECT * FROM DBO.HOUSE_PRICES
-----------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS dbo.Vw_Estados;

CREATE VIEW dbo.Vw_Estados AS
SELECT DISTINCT c_estado, estado FROM DBO.indicadores


DROP VIEW IF EXISTS dbo.Vw_Municipios;

CREATE VIEW dbo.Vw_Municipios AS
SELECT DISTINCT CONCAT(c_estado,'-',c_mnpio) as id, c_estado,c_mnpio, municipio FROM dbo.indicadores
-----------------------------------------------------------------------------------------------
SELECT COUNT(*) FROM DBO.HOUSE_PRICES;
SELECT COUNT(*) FROM DBO.INDICADORES;
SELECT COUNT(*) FROM DBO.STATES_COORDS;
SELECT COUNT(*) FROM DBO.VW_Datos_Estado;
SELECT COUNT(*) FROM DBO.VW_Datos_Municipio;
SELECT COUNT(*) FROM DBO.VW_Map;


SELECT * FROM DBO.VW_DATOS_ESTADO
SELECT * FROM DBO.VW_DATOS_MUNICIPIO
SELECT * FROM DBO.VW_MAP

SELECT * FROM DBO.HOUSE_PRICES
SELECT * FROM DBO.VW_RECORDS

SELECT * FROM DBO.HOUSE_PRICES_ALT
