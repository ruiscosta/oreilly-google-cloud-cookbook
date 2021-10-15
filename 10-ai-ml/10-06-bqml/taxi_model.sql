-- Copyright 2021, Google, Inc.
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

--     http://www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- Examine the taxi dataset
SELECT*
FROM
  `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2018`
WHERE
  EXTRACT(DATE FROM pickup_datetime) = "2018-01-28"


-- create a basic model
CREATE OR REPLACE MODEL
  mydataset.taxi_model OPTIONS(model_type='linear_reg',
    input_label_cols=['fare_amount']) AS
SELECT
  fare_amount,
  CAST(pickup_location_id AS string) AS pickup_location,
  CAST(dropoff_location_id AS string) AS dropoff_location,
  CAST(EXTRACT(HOUR FROM pickup_datetime) AS string) AS hour,
  CAST(EXTRACT(DAYOFWEEK FROM pickup_datetime) AS string) AS day_of_week,
FROM
  `bigquery-public-data`.new_york_taxi_trips.tlc_yellow_trips_2018
WHERE 
    EXTRACT(DATE FROM pickup_datetime) < "2018-07-01"


-- examine the model training statistics
SELECT * FROM ML.EVALUATE(MODEL mydataset.taxi_model)


-- making some batch predictions
SELECT *
FROM
  ML.PREDICT(MODEL `mydataset.taxi_model`,
    (
    SELECT
      fare_amount,
      CAST(pickup_location_id AS string) AS pickup_location,
      CAST(dropoff_location_id AS string) AS dropoff_location,
      CAST(EXTRACT(HOUR FROM pickup_datetime) AS string) AS hour,
      CAST(EXTRACT(DAYOFWEEK FROM pickup_datetime) AS string) AS day_of_week,
    FROM
      `bigquery-public-data`.new_york_taxi_trips.tlc_yellow_trips_2018
    WHERE
      EXTRACT(DATE FROM pickup_datetime) = "2018-07-01"
    LIMIT 20 ))
