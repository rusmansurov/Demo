from pyspark.sql import SparkSession, Row
from datetime import date

spark = SparkSession.builder.appName("Advanced Iceberg Test") .getOrCreate()

print("Create database")
spark.sql("CREATE DATABASE IF NOT EXISTS demo")

print("Create Iceberg table partitioned by event_date")
spark.sql("""
    CREATE TABLE IF NOT EXISTS demo.test_advanced_write (
        id INT,
        name STRING,
        event_date DATE
    )
    PARTITIONED BY (event_date)
""")

print("Initial data append")
df_initial = spark.createDataFrame([
    Row(id=1, name="Alice", event_date=date(2025, 6, 1)),
    Row(id=2, name="Bob",   event_date=date(2025, 6, 1)),
])
df_initial.writeTo("demo.test_advanced_write").append()

print("Overwrite a partition (June 1)")
df_updated = spark.createDataFrame([
    Row(id=1, name="Alice_Updated", event_date=date(2025, 6, 1)),
    Row(id=3, name="Charlie",       event_date=date(2025, 6, 1)),
])
df_updated.writeTo("demo.test_advanced_write").overwritePartitions()

print("Append a new partition (June 2)")
df_more = spark.createDataFrame([
    Row(id=4, name="Diana", event_date=date(2025, 6, 2)),
])
df_more.writeTo("demo.test_advanced_write").append()

print("Upsert data using MERGE INTO")
spark.sql("""
    MERGE INTO demo.test_advanced_write t
    USING (
        SELECT 3 AS id, 'Charlie_Updated' AS name, DATE('2025-06-01') AS event_date
        UNION ALL
        SELECT 5 AS id, 'Eve' AS name, DATE('2025-06-03') AS event_date
    ) s
    ON t.id = s.id
    WHEN MATCHED THEN UPDATE SET *
    WHEN NOT MATCHED THEN INSERT *
""")

print("\n Final table contents:")
spark.sql("SELECT * FROM demo.test_advanced_write ORDER BY id").show(truncate=False)

print("\n Snapshots (history):")
spark.sql("SELECT snapshot_id, committed_at, operation FROM demo.test_advanced_write.snapshots").show(truncate=False)

print("Rollback to previous snapshot")
snapshots = spark.sql("""
    SELECT snapshot_id, committed_at
    FROM demo.test_advanced_write.snapshots
    ORDER BY committed_at DESC
""").collect()

if len(snapshots) >= 2:
    rollback_id = snapshots[1]['snapshot_id']
    print(f"\n Rolling back to snapshot ID: {rollback_id}")
    spark.sql(f"CALL iceberg_catalog.system.rollback_to_snapshot('iceberg_catalog.demo.test_advanced_write', {rollback_id})")


print("\n Table after rollback:")
spark.sql("SELECT * FROM demo.test_advanced_write ORDER BY id").show(truncate=False)

spark.stop()