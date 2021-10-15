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

-- Schema hierarchy:
-- + Customers (sibling table of Orders)
-- + Orders (sibling table of Customers)

CREATE TABLE Customers (
  CustomerId INT64 NOT NULL,
  FirstName  STRING(1024),
  LastName   STRING(1024),
  Address     STRING(1024),
) PRIMARY KEY (CustomerId);

CREATE TABLE Orders (
  CustomerId    INT64 NOT NULL,
  OrderId       INT64 NOT NULL,
  OrderTotal    FLOAT64 NOT NULL,
  QuantityItems INT64 NOT NULL,
  OrderItems    ARRAY<INT64>,
) PRIMARY KEY (CustomerId, OrderId);