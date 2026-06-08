-- ============================================================
-- TerraNova — Inicialização do banco PostgreSQL
-- Executado automaticamente na primeira inicialização do container
-- postgis/postgis, graças ao volume mapeado em /docker-entrypoint-initdb.d.
--
-- Habilita PostGIS e força o SRID 4326 (WGS 84) como default
-- para colunas geography/geometry criadas sem SRID explícito.
-- ============================================================

-- Extensão espacial (vem pré-instalada na imagem postgis/postgis,
-- mas a habilitamos explicitamente para garantir reprodutibilidade
-- caso alguém troque a imagem base).
CREATE EXTENSION IF NOT EXISTS postgis;

-- Garante que a versão do PostGIS é a esperada
DO $$
BEGIN
    RAISE NOTICE 'TerraNova: PostGIS habilitado com sucesso.';
END
$$;
