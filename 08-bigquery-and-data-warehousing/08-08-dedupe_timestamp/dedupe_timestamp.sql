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

-- Run this on command line first to load data
-- bq --location=eu cp -f bigquery-public-data:london_bicycles.cycle_hire mydataset_eu.cycle_hire

-- Validate one original record for a particular trip, in this case an "estimated" journey
SELECT
  *
FROM
  mydataset_eu.cycle_hire
WHERE
  rental_id = 47469109
ORDER BY
  end_date DESC

-- Insert two more records for this trip as the system has a more "accurate" view of the trip as time goes on
INSERT INTO
  dhodun1.mydataset_eu.cycle_hire
VALUES
  ( 47469109, 3300, 7054, '2015-09-03 12:47:00 UTC', 111, 'Park Lane, Hyde Park', '2015-09-03 11:52:00 UTC', 300, 'Serpentine Car Park, Hyde Park', NULL, NULL, NULL ),
  ( 47469109, 3660, 7054, '2015-09-03 12:53:00 UTC', 111, 'Park Lane, Hyde Park', '2015-09-03 11:52:00 UTC', 300, 'Serpentine Car Park, Hyde Park', NULL, NULL, NULL )

-- View all three records
SELECT
  *
FROM
  mydataset_eu.cycle_hire
WHERE
  rental_id = 47469109
ORDER BY
  end_date DESC

-- Use ROW_NUMBER() OVER() to get the most recent one

SELECT
  * EXCEPT(row_num)
FROM (
  SELECT
    *, ROW_NUMBER() OVER (PARTITION BY rental_id ORDER BY end_date DESC) AS row_num
  FROM
    mydataset_eu.cycle_hire )
WHERE
  row_num = 1
  AND rental_id = 47469109

-- Use ARRAY_AGG to get the latest one
SELECT
  latest_record.*
FROM (
  SELECT
    rental_id,
    ARRAY_AGG(rentals ORDER BY end_date DESC LIMIT 1)[OFFSET(0)] latest_record
  FROM
    mydataset_eu.cycle_hire rentals
  WHERE
    rental_id = 47469109
  GROUP BY
    rental_id )

-- Use ARRAY_AGG on the whole dataset
SELECT
  latest_record.*
FROM (
  SELECT
    rental_id,
    ARRAY_AGG(rentals ORDER BY end_date DESC LIMIT 1)[OFFSET(0)] latest_record
  FROM
    mydataset_eu.cycle_hire rentals
  WHERE
    rental_id = 47469109
  GROUP BY
    rental_id )

