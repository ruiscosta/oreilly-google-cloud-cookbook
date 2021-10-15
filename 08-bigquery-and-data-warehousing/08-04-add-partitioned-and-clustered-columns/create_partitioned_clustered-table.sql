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

-- creates a partitioned and clustered table from an existing non-partitioned table
CREATE OR REPLACE TABLE
  mydataset_eu.cycle_hire_partitioned_clustered
PARTITION BY
  DATE(start_date)
CLUSTER BY
  bike_id
OPTIONS( expiration_timestamp=TIMESTAMP "2025-01-01 00:00:00 UTC",
     description="My partitioned and clustered cycle_hire table",
     labels=[("cookbook_query", "development")] )
AS
SELECT
  *
FROM
  `bigquery-public-data.london_bicycles.cycle_hire`
