// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

cube(`Stories`, {
    sql: `
      SELECT *
      FROM bigquery-public-data.hacker_news.full
      WHERE type = "story" AND STARTS_WITH(UPPER(url), "HTTP")
    `,
  
    measures: {
      count: {
        type: `count`,
      },
    },
  
    dimensions: {
      protocol: {
        sql: `UPPER(REGEXP_EXTRACT(${CUBE}.url, r"^([a-zA-Z]+):"))`,
        type: `string`,
      },
  
      time: {
        sql: `timestamp`,
        type: `time`,
      },
    },
  });