import sys

from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql import Window
from pyspark.sql.functions import col, rank
from pyspark.sql.types import (
    IntegerType,
    StringType,
    StructField,
    StructType,
    TimestampType,
)

args = getResolvedOptions(sys.argv, ["JOB_NAME"])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

job = Job(glueContext)
job.init(args["JOB_NAME"])

TYPES_MAPPING = "s3://ejjunior/config/types_mapping.json"
INPUT_PATH = "s3://ejjunior/input/users/load.csv"
OUTPUT_PATH = "s3://ejjunior/output/users/users.parquet"
DEDUPLICATED_PATH = "s3://ejjunior/output/users/deduplicated.parquet"

df_schema = spark.read.option("multiLine", True).json(TYPES_MAPPING)


def str_to_dtypes(type: str):
    """Responsavel por converter para pyspark types"""

    _type = df_schema.select(type).collect()[0][0]

    data = {"integer": IntegerType(), "timestamp": TimestampType()}
    try:
        return data[_type]
    except KeyError:
        return StringType()


schema = StructType(
    [
        StructField("id", IntegerType(), True),
        StructField("name", StringType(), True),
        StructField("email", StringType(), True),
        StructField("phone", StringType(), True),
        StructField("address", StringType(), True),
        StructField("age", str_to_dtypes("age"), True),
        StructField("create_date", str_to_dtypes("create_date"), True),
        StructField("update_date", str_to_dtypes("update_date"), True),
    ]
)

schema.simpleString()

df_raw = spark.read.option("header", "true").schema(schema).csv(INPUT_PATH)
df_raw.printSchema()

window = Window.partitionBy("id").orderBy(col("update_date").desc())
df_raw.withColumn("rank", rank().over(window)).show(truncate=False)

df_deduplicated = df_raw.withColumn("rank", rank().over(window)).where(col("rank") != 1)
df_no_deduplicated = df_raw.withColumn("rank", rank().over(window)).where(
    col("rank") == 1
)

df_deduplicated = (
    df_deduplicated.drop("rank").write.mode("overwrite").parquet(DEDUPLICATED_PATH)
)
df_no_deduplicated = (
    df_no_deduplicated.drop("rank").write.mode("overwrite").parquet(OUTPUT_PATH)
)

df_deduplicated_parquet = spark.read.parquet(DEDUPLICATED_PATH)
df_no_deduplicated_parquet = spark.read.parquet(OUTPUT_PATH)

df_deduplicated_parquet.show(truncate=False)
df_no_deduplicated_parquet.show(truncate=False)
