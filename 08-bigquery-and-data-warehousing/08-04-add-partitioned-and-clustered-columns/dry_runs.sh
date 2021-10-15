# Copyright 2021, Google, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash

# pre-partitioned dry run

QUERY='
SELECT
  duration,
  bike_id,
  start_date,
  start_station_name,
  end_date,
  end_station_name
FROM
  `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
  EXTRACT(DATE FROM start_date ) = "2016-04-03"
  AND EXTRACT(DATE FROM end_date ) = "2016-04-03"
ORDER BY
  duration DESC
LIMIT
  5
'
 
bq query \
--use_legacy_sql=false \
--location=EU \
--dry_run \
$QUERY


# Should output that query will process 2.2GB
 

# post-partitioned dry run

QUERY='
SELECT
  duration,
  bike_id,
  start_date,
  start_station_name,
  end_date,
  end_station_name
FROM
  `mydataset_eu.cycle_hire_partitioned_clustered`
WHERE
  EXTRACT(DATE FROM start_date ) = "2016-04-03"
  AND EXTRACT(DATE FROM end_date ) = "2016-04-03"
ORDER BY
  duration DESC
LIMIT
  5
'
 
bq query \
--use_legacy_sql=false \
--location=EU \
--dry_run \
$QUERY


# Should output that query will process 2MB
 