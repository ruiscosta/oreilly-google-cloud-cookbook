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

-- Query before we Pivot the data

SELECT
  start_station_name,
  EXTRACT(DAYOFWEEK
  FROM
    end_date) AS day_of_week,
  AVG(duration) AS average_ride_duration
FROM
  `bigquery-public-data.london_bicycles.cycle_hire`
GROUP BY
  start_station_name,
  day_of_week


-- Pivoted query

SELECT *
FROM (
  SELECT
    start_station_name,
    EXTRACT(DAYOFWEEK FROM end_date) AS day_of_week,
    duration
  FROM
    `bigquery-public-data.london_bicycles.cycle_hire`
)
PIVOT
(
  AVG(duration) AS average_ride_duration
  FOR day_of_week IN (1,2,3,4,5,6,7)
)
