-- ============================================================
-- TerraNova — Inicialização do banco PostgreSQL
-- Executado automaticamente na primeira inicialização do container
-- postgis/postgis, graças ao volume mapeado em /docker-entrypoint-initdb.d.
--
-- Habilita a extensão espacial usada pelas migrations do Entity Framework.
-- O SRID 4326 é definido pela aplicação ao criar o Point com NetTopologySuite.
-- ============================================================

CREATE EXTENSION IF NOT EXISTS postgis;

DO $$
BEGIN
    RAISE NOTICE 'TerraNova: PostGIS habilitado com sucesso.';
END
$$;
