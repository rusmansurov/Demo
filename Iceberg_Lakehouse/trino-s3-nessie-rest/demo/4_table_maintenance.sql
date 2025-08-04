-- Set catalog and schema
USE dlh.my_schema;

-- Compact small files
ALTER TABLE demo_users EXECUTE optimize;

-- Expire old snapshots
ALTER TABLE demo_users EXECUTE expire_snapshots(retention_threshold => '7d');

-- Remove orphan files
ALTER TABLE demo_users EXECUTE remove_orphan_files(retention_threshold => '7d');
