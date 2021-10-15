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

CREATE OR REPLACE TABLE
  mydataset_eu.cycle_hire_fake_partitioned_clustered (
    rental_id INTEGER,
    duration INTEGER,
    bike_id INTEGER,
    end_date TIMESTAMP,
    end_station_id INTEGER,
    end_station_name STRING,
    start_date TIMESTAMP,
    start_station_id INTEGER,
    start_station_name STRING,
    end_station_logical_terminal INTEGER,
    start_station_logical_terminal INTEGER,
    end_station_priority_id INTEGER,
    fake_date DATE )
PARTITION BY
  fake_date
CLUSTER BY
  bike_id
OPTIONS( expiration_timestamp=TIMESTAMP "2025-01-01 00:00:00 UTC",
    description="My partitioned and clustered cycle_hire table",
    labels=[("cookbook_query",
      "development")] ) AS
SELECT
  *, NULL
FROM
  `bigquery-public-data.london_bicycles.cycle_hire`

-- query on new table
SELECT MAX(duration) as max_duration FROM
`mydataset_eu.cycle_hire_fake_partitioned_clustered`
WHERE bike_id =  153

-- query on original dataset
SELECT MAX(duration) as max_duration FROM
`bigquery-public-data.london_bicycles.cycle_hire`
WHERE bike_id =  153


-- query on partioned table from previous recipe
SELECT MAX(duration) as max_duration FROM
`mydataset_eu.cycle_hire_partitioned_clustered`
WHERE bike_id =  153



