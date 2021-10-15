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

-- Top 1 using ROW_NUMBER() OVER()
-- Query should succeed, but will take a bit
-- In this example we are sorting entire dataset, not just partitions.
-- You would still see performance problems with hot keys or large 
-- number of rows for a given key.

SELECT
  rental_id,
  duration,
  bike_id,
  end_date
FROM (
  SELECT
    rental_id,
    duration,
    bike_id,
    end_date,
    ROW_NUMBER() OVER (ORDER BY end_date ASC) rental_num
    
  FROM
    `bigquery-public-data`.london_bicycles.cycle_hire )
WHERE
  rental_num = 1


-- Using ARRAY_AGG()
-- Query should succeed more quickly

SELECT
  rental.*
FROM (
  SELECT
    ARRAY_AGG( rentals
    ORDER BY rentals.end_date ASC LIMIT 1)[OFFSET(0)] rental
  FROM (
    SELECT
      rental_id,
      duration,
      bike_id,
      end_date
    FROM
      `bigquery-public-data`.london_bicycles.cycle_hire) rentals )
