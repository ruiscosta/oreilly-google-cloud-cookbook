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

-- Create a loading table with new and duplicate rows:
CREATE OR REPLACE TABLE
  mydataset_eu.temp_loading_table AS (
 
  --Grab 5 duplicate rows
  SELECT
    *
  FROM
    mydataset_eu.cycle_hire
  LIMIT
    5)
UNION ALL (
  
  --Add a new unique row
  SELECT
    111147469109,
    3180,
    7054,
    '2015-09-03 12:45:00 UTC',
    111,
    'Park Lane, Hyde Park',
    '2015-09-03 11:52:00 UTC',
    300,
    'Serpentine Car Park, Hyde Park',
    NULL,
    NULL,
    NULL)

-- Verify the counts of both tables

--Number of Rows in base table
SELECT COUNT(*) FROM mydataset_eu.cycle_hire;
 
--Number of Rows in loading table
SELECT COUNT(*) FROM mydataset_eu.temp_loading_table;

--Merge using ON clause

MERGE
  mydataset_eu.cycle_hire rentals
USING
  mydataset_eu.temp_loading_table temp
ON
  temp.rental_id = rentals.rental_id
  WHEN NOT MATCHED
  THEN
    INSERT ROW


--Verify number of rows added 
--Number of rows now in base table
SELECT COUNT(*) FROM mydataset_eu.cycle_hire;
