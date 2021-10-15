#!/usr/bin/python

# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from pyspark.sql import SparkSession

PROJECT = "dhodun1"

spark = SparkSession \
    .builder \
    .master('yarn') \
    .appName('cookbook-query') \
    .getOrCreate()

# Use the Cloud Storage bucket for temporary BigQuery export data used
# by the connector.
bucket = PROJECT
spark.conf.set('temporaryGcsBucket', bucket)

# Load data from BigQuery.
events = spark.read.format('bigquery') \
    .option('table', f'{PROJECT}:weblog.raw_events') \
    .load()
events.createOrReplaceTempView('raw_events')

# Count how many events per user
regions_count = spark.sql(
    'SELECT COUNT(*) AS num_visits, user_id FROM raw_events GROUP BY user_id')
regions_count.show()
regions_count.printSchema()

# Saving the data to BigQuery
regions_count.write.format('bigquery') \
    .option('table', 'weblog.events_aggregate') \
    .save()
