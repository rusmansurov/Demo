-- Set catalog and schema
USE USE dlh.my_schema;

-- View all snapshots
SELECT snapshot_id, committed_at
FROM "iceberg"."default"."demo_users$snapshots";

-- Travel to specific snapshot (insert your snapshot_id value from previous query)
SELECT * FROM demo_users FOR VERSION AS OF <snapshot_id>;

-- Travel by timestamp (insert your committed_at value from previous query)
SELECT * FROM demo_users FOR TIMESTAMP AS OF TIMESTAMP '<committed_at>';

-- Rollback to previous snapshot
CALL iceberg.system.rollback_to_snapshot('default', 'demo_users', <snapshot_id>);
