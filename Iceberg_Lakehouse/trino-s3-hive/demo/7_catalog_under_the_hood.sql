-- What happens under the hood?

-- Trino → Hive Metastore → PostgreSQL → metadata_location → MinIO → Parquet

-- Explore metadata_location in PostgreSQL
SELECT d."NAME" AS db_name, t."TBL_NAME", p."PARAM_KEY", p."PARAM_VALUE"
FROM  public."TBLS" t
JOIN public."DBS" d ON d."DB_ID" = t."DB_ID"
JOIN public."TABLE_PARAMS" p ON p."TBL_ID" = t."TBL_ID"
WHERE t."TBL_NAME" = 'demo_users';
