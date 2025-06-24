from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("WriteToS3").getOrCreate()

df = spark.createDataFrame([
    ("Alice", 30),
    ("Bob", 25),
    ("Charlie", 35)
], ["name", "age"])

df.show(truncate=False)

df.write.mode("overwrite").parquet("s3a://spark-demo/users/")

print("Data savev in S3")

spark.stop()
