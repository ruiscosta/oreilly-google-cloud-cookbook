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

SELECT
  events.event_timestamp,
  events.ip,
  events.user_id,
  events.http_request,
  table.age_bracket,
  table.opted_into_marketing,
  table.last_visit
FROM
  pubsub.topic.dhodun2.events AS events
INNER JOIN
  bigquery.table.dhodun2.weblog.userprofile table
ON
  events.user_id = table.id
