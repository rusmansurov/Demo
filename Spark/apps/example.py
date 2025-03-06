from pyspark.sql import SparkSession

spark = (
    SparkSession
    .builder
    .appName('demo')
    .getOrCreate()
)

spark.sparkContext.setLogLevel("WARN")

df = spark.createDataFrame(
                            [
                            (1, "John", 21),
                            (2, "Jane", 22),
                            (3, "Joe", 23),
                            ],
                            ["id", "name", "age"],
                            )

df.write.mode('overwrite').parquet('/opt/spark/data/example')

spark.stop()